import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:grocermate/core/config/app_flags.dart';
import 'package:grocermate/core/config/flags_repository.dart';
import 'package:grocermate/core/error/failure.dart';
import 'package:grocermate/core/network/connectivity_service.dart';
import 'package:grocermate/core/network/result.dart';
import 'package:grocermate/core/storage/json_store.dart';
import 'package:grocermate/features/cart/domain/entities/cart_item.dart';
import 'package:grocermate/features/cart/domain/repositories/cart_repository.dart';
import 'package:grocermate/features/cart/domain/usecases/restore_to_cart_usecase.dart';
import 'package:grocermate/features/checkout/domain/entities/purchase_entites/price_change.dart';
import 'package:grocermate/features/checkout/domain/entities/purchase_entites/purchase_line.dart';
import 'package:grocermate/features/checkout/domain/entities/purchase_entites/purchase_request.dart';
import 'package:grocermate/features/checkout/domain/entities/purchase_entites/purchase_result.dart';
import 'package:grocermate/features/checkout/domain/entities/purchase_entites/stock_issue.dart';
import 'package:grocermate/features/offline_sync/data/datasources/outbox_local_data_source.dart';
import 'package:grocermate/features/offline_sync/data/repositories/outbox_repository_impl.dart';
import 'package:grocermate/features/offline_sync/domain/entities/outbox_entry.dart';
import 'package:grocermate/features/offline_sync/domain/repositories/outbox_repository.dart';
import 'package:grocermate/features/offline_sync/domain/repositories/sync_repository.dart';
import 'package:grocermate/features/offline_sync/service/sync_manager.dart';
import 'package:mocktail/mocktail.dart';

class _Sync extends Mock implements SyncRepository {}

class _Cart extends Mock implements CartRepository {}

class _Connectivity extends Mock implements ConnectivityService {}

class _Flags extends Mock implements FlagsRepository {}

CartItem item(String id, {int qty = 1}) => CartItem(
  productId: id,
  title: id,
  brand: 'b',
  image: '',
  categoryId: 'c',
  unitPrice: 2,
  originalPrice: 2,
  stock: 5,
  qty: qty,
);

void main() {
  late OutboxRepository outbox;
  late _Sync sync;
  late _Cart cart;
  late _Connectivity connectivity;
  late SyncManager manager;

  setUpAll(() => registerFallbackValue(const PurchaseRequest(lines: [])));

  setUp(() async {
    outbox = OutboxRepositoryImpl(OutboxLocalDataSource(InMemoryJsonStore()));
    sync = _Sync();
    cart = _Cart();
    connectivity = _Connectivity();
    final flags = _Flags();
    when(() => flags.current).thenReturn(const AppFlags());
    when(() => connectivity.isOnline).thenReturn(true);
    when(() => connectivity.onChanged)
        .thenAnswer((_) => const Stream<bool>.empty());
    when(() => cart.restore(any())).thenAnswer((_) async {});
    manager = SyncManager(
      outbox: outbox,
      sync: sync,
      restoreToCart: RestoreToCartUseCase(cart),
      connectivity: connectivity,
      flags: flags,
    );
    await outbox.enqueue([item('milk', qty: 2), item('bread')], id: 'key-1');
  });

  OutboxEntry entry() => outbox.all().single;

  test(
    'success -> completed, and the entry id is sent as idempotency key',
    () async {
      when(() => sync.syncPurchase(any())).thenAnswer(
        (_) async =>
            const Success(PurchaseSuccess(orderId: 'o_1', finalTotal: 7.5)),
      );

      await manager.syncNow();

      expect(entry().status, OutboxStatus.completed);
      expect(entry().orderId, 'o_1');
      final req =
          verify(() => sync.syncPurchase(captureAny())).captured.single
              as PurchaseRequest;
      expect(req.idempotencyKey, 'key-1');
      expect(req.lines.first.expectedPrice, 2); // price revalidation enabled
    },
  );

  test('price change / OOS -> needsReview (user must resolve)', () async {
    when(() => sync.syncPurchase(any())).thenAnswer(
      (_) async => const Success(
        PurchaseReviewRequired(
          priceChanges: [
            PriceChange(productId: 'milk', oldPrice: 2, newPrice: 2.2),
          ],
          oos: [StockIssue(productId: 'bread', available: 0)],
        ),
      ),
    );

    await manager.syncNow();

    expect(entry().status, OutboxStatus.needsReview);
    expect(entry().note, isNotNull);
  });

  test('partial -> completed and missing items go back to the cart', () async {
    when(() => sync.syncPurchase(any())).thenAnswer(
      (_) async => const Success(
        PurchasePartial(
          orderId: 'o_2',
          fulfilled: [PurchaseLine(productId: 'milk', qty: 2)],
          missing: [PurchaseLine(productId: 'bread', qty: 1)],
          note: '',
        ),
      ),
    );

    await manager.syncNow();

    expect(entry().status, OutboxStatus.completed);
    final restored =
        verify(() => cart.restore(captureAny())).captured.single
            as List<CartItem>;
    expect(restored.single.productId, 'bread');
  });

  test(
    'network failure keeps the order queued for the next reconnect',
    () async {
      when(() => sync.syncPurchase(any()))
          .thenAnswer((_) async => const Failed(NetworkFailure()));

      await manager.syncNow();

      expect(entry().status, OutboxStatus.queued);
      expect(entry().attempts, 1);
    },
  );

  test('does nothing while offline', () async {
    when(() => connectivity.isOnline).thenReturn(false);
    await manager.syncNow();
    verifyNever(() => sync.syncPurchase(any()));
    expect(entry().status, OutboxStatus.queued);
  });
}
