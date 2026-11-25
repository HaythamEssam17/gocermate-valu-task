import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocermate/core/utils/enums/check_out_status.dart';
import 'package:grocermate/features/cart/domain/usecases/apply_cart_patches_usecase.dart';
import 'package:grocermate/features/cart/domain/usecases/remove_items_usecase.dart';
import 'package:grocermate/features/cart/domain/usecases/restore_to_cart_usecase.dart';
import 'package:grocermate/features/checkout/domain/entities/purchase_entites/purchase_result.dart';
import 'package:grocermate/features/checkout/domain/entities/review_resolver.dart';
import 'package:grocermate/features/offline_sync/domain/usecases/complete_outbox_entry_usecase.dart';
import 'package:grocermate/features/offline_sync/domain/usecases/queue_purchase_usecase.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../../../core/network/result.dart';
import '../../domain/usecases/checkout_usecases.dart';
import 'checkout_events.dart';
import 'checkout_states.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  CheckoutBloc({
    required this._placeOrder,
    required this._resolver,
    required this._applyPatches,
    required this._removeItems,
    required this._restoreToCart,
    required this._queuePurchase,
    required this._completeOutbox,
    required this._connectivity,
    this._uuid = const Uuid(),
  }) : super(const CheckoutState()) {
    on<CheckoutPlaceRequested>(_onPlace);
    on<CheckoutIssueResolved>(_onIssueResolved);
    on<CheckoutResubmitted>(_onResubmitted);
    on<CheckoutReviewDismissed>(
      (e, emit) =>
          emit(state.copyWith(status: CheckoutStatus.idle, issues: const [])),
    );
  }

  final PlaceOrderUseCase _placeOrder;
  final ReviewResolver _resolver;
  final ApplyCartPatchesUseCase _applyPatches;
  final RemoveItemsUseCase _removeItems;
  final RestoreToCartUseCase _restoreToCart;
  final QueuePurchaseUseCase _queuePurchase;
  final CompleteOutboxEntryUseCase _completeOutbox;
  final ConnectivityService _connectivity;
  final Uuid _uuid;

  bool get _fromOutbox => state.outboxEntryId != null;

  Future<void> _onPlace(
    CheckoutPlaceRequested e,
    Emitter<CheckoutState> emit,
  ) async {
    if (state.status == CheckoutStatus.submitting) return;
    // The same key is reused for retries/re-submits => the server never double-orders.
    final key = e.outboxEntryId ?? state.idempotencyKey ?? _uuid.v4();
    emit(
      state.copyWith(
        items: e.items,
        outboxEntryId: e.outboxEntryId,
        idempotencyKey: key,
        failure: null,
      ),
    );

    if (!_connectivity.isOnline) {
      if (_fromOutbox) {
        emit(
          state.copyWith(
            status: CheckoutStatus.failure,
            failure: const OfflineFailure(
              'You are offline. Reconnect to review this order.',
            ),
          ),
        );
        return;
      }
      await _queuePurchase(e.items, idempotencyKey: key);
      emit(state.copyWith(status: CheckoutStatus.queued));
      return;
    }
    await _submit(emit);
  }

  Future<void> _submit(Emitter<CheckoutState> emit) async {
    emit(state.copyWith(status: CheckoutStatus.submitting, failure: null));
    final result = await _placeOrder(
      state.items,
      idempotencyKey: state.idempotencyKey,
    );
    switch (result) {
      case Failed<PurchaseResult>(:final failure):
        emit(state.copyWith(status: CheckoutStatus.failure, failure: failure));
      case Success<PurchaseResult>(:final value):
        await _handle(value, emit);
    }
  }

  Future<void> _handle(PurchaseResult r, Emitter<CheckoutState> emit) async {
    switch (r) {
      case PurchaseSuccess():
        if (_fromOutbox) {
          await _completeOutbox(
            state.outboxEntryId!,
            orderId: r.orderId,
            total: r.finalTotal,
          );
        } else {
          await _removeItems(state.items.map((i) => i.productId).toSet());
        }
        emit(
          state.copyWith(
            status: CheckoutStatus.success,
            orderId: r.orderId,
            total: r.finalTotal,
            issues: const [],
          ),
        );
      case PurchasePartial():
        final missingIds = r.missing.map((m) => m.productId).toSet();
        final fulfilled = state.items
            .where((i) => !missingIds.contains(i.productId))
            .toList();
        final missing = state.items
            .where((i) => missingIds.contains(i.productId))
            .toList();
        if (_fromOutbox) {
          await _restoreToCart(missing);
          await _completeOutbox(
            state.outboxEntryId!,
            orderId: r.orderId,
            note: '${missing.length} unavailable item(s) returned to your cart',
          );
        } else {
          await _removeItems(fulfilled.map((i) => i.productId).toSet());
        }
        emit(
          state.copyWith(
            status: CheckoutStatus.partial,
            orderId: r.orderId,
            missing: missing,
            issues: const [],
          ),
        );
      case PurchasePriceChanged() ||
          PurchaseOutOfStock() ||
          PurchaseReviewRequired():
        emit(
          state.copyWith(
            status: CheckoutStatus.review,
            issues: _resolver.issuesFor(r, state.items),
          ),
        );
    }
  }

  void _onIssueResolved(CheckoutIssueResolved e, Emitter<CheckoutState> emit) {
    emit(
      state.copyWith(
        issues: [
          for (final i in state.issues)
            i.key == e.issueKey ? i.withResolution(e.resolution) : i,
        ],
      ),
    );
  }

  Future<void> _onResubmitted(
    CheckoutResubmitted e,
    Emitter<CheckoutState> emit,
  ) async {
    if (!state.allResolved) return;
    final resolved = _resolver.apply(state.items, state.issues);
    if (!_fromOutbox) {
      await _applyPatches(resolved.patches);
      if (resolved.removedIds.isNotEmpty) {
        await _removeItems(resolved.removedIds);
      }
    }
    if (resolved.items.isEmpty) {
      emit(
        state.copyWith(
          status: CheckoutStatus.cancelled,
          items: const [],
          issues: const [],
        ),
      );
      return;
    }
    emit(state.copyWith(items: resolved.items, issues: const []));
    await _submit(emit);
  }
}
