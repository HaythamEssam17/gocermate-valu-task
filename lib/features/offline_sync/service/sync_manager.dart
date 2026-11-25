import 'dart:async';

import 'package:grocermate/core/config/flags_repository.dart';
import 'package:grocermate/core/error/failure.dart';
import 'package:grocermate/core/network/connectivity_service.dart';
import 'package:grocermate/core/network/result.dart';
import 'package:grocermate/features/cart/domain/usecases/restore_to_cart_usecase.dart';
import 'package:grocermate/features/checkout/domain/entities/purchase_entites/purchase_request.dart';
import 'package:grocermate/features/checkout/domain/entities/purchase_entites/purchase_result.dart';
import 'package:grocermate/features/offline_sync/domain/entities/outbox_entry.dart';
import 'package:grocermate/features/offline_sync/domain/repositories/outbox_repository.dart';
import 'package:grocermate/features/offline_sync/domain/repositories/sync_repository.dart';

class SyncManager {
  SyncManager({
    required this._outbox,
    required this._sync,
    required this._restoreToCart,
    required this._connectivity,
    required this._flags,
    this.maxServerAttempts = 3,
  });

  final OutboxRepository _outbox;
  final SyncRepository _sync;
  final RestoreToCartUseCase _restoreToCart;
  final ConnectivityService _connectivity;
  final FlagsRepository _flags;
  final int maxServerAttempts;

  StreamSubscription<bool>? _sub;
  bool _running = false;

  void start() {
    _sub ??= _connectivity.onChanged.listen((online) {
      if (online) syncNow();
    });
    if (_connectivity.isOnline) syncNow();
  }

  Future<void> dispose() async => _sub?.cancel();

  /// Returns when the queue has been processed once.
  Future<void> syncNow() async {
    if (_running || !_connectivity.isOnline) return;
    _running = true;
    try {
      final pending = _outbox.all().where((e) => e.isPending).toList().reversed;
      for (final entry in pending) {
        if (!_connectivity.isOnline) break;
        await _process(entry);
      }
    } finally {
      _running = false;
    }
  }

  Future<void> _process(OutboxEntry entry) async {
    final attempt = entry.attempts + 1;
    await _outbox.update(
      entry.copyWith(status: OutboxStatus.syncing, attempts: attempt),
    );

    final flags = _flags.current;
    final result = await _sync.syncPurchase(
      PurchaseRequest.fromCartItems(
        entry.items,
        revalidatePrices: flags.enablePriceRevalidation,
        idempotencyKey: entry.id,
        currency: flags.currency,
      ),
    );

    final current = entry.copyWith(attempts: attempt);
    switch (result) {
      case Failed<PurchaseResult>(:final failure):
        final retryable =
            failure is NetworkFailure || failure is OfflineFailure;
        final giveUp = !retryable && attempt >= maxServerAttempts;
        await _outbox.update(
          current.copyWith(
            status: giveUp ? OutboxStatus.failed : OutboxStatus.queued,
            note: giveUp
                ? failure.message
                : 'Waiting for a connection - will retry',
          ),
        );
      case Success<PurchaseResult>(:final value):
        await _apply(current, value);
    }
  }

  Future<void> _apply(OutboxEntry entry, PurchaseResult r) async {
    switch (r) {
      case PurchaseSuccess():
        await _outbox.update(
          entry.copyWith(
            status: OutboxStatus.completed,
            orderId: r.orderId,
            total: r.finalTotal,
            note: 'Order placed',
          ),
        );
      case PurchasePartial():
        final missingIds = r.missing.map((m) => m.productId).toSet();
        final missing = entry.items
            .where((i) => missingIds.contains(i.productId))
            .toList();
        await _restoreToCart(missing);
        await _outbox.update(
          entry.copyWith(
            status: OutboxStatus.completed,
            orderId: r.orderId,
            note: '${missing.length} unavailable item(s) returned to your cart',
          ),
        );
      case PurchasePriceChanged():
        await _review(
          entry,
          '${r.changes.length} price(s) changed while you were offline',
        );
      case PurchaseOutOfStock():
        await _review(
          entry,
          '${r.items.length} item(s) are no longer available in that quantity',
        );
      case PurchaseReviewRequired():
        await _review(
          entry,
          'Prices and availability changed (${r.priceChanges.length + r.oos.length} item(s))',
        );
    }
  }

  Future<void> _review(OutboxEntry entry, String note) => _outbox.update(
    entry.copyWith(status: OutboxStatus.needsReview, note: note),
  );
}
