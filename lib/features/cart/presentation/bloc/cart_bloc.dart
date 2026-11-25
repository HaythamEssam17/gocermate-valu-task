import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocermate/features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:grocermate/features/cart/domain/usecases/move_items_usecase.dart';
import 'package:grocermate/features/cart/domain/usecases/remove_items_usecase.dart';
import 'package:grocermate/features/cart/domain/usecases/update_quantity_usecase.dart';
import 'package:grocermate/features/cart/domain/usecases/watch_cart_usecase.dart';

import '../../../../core/config/flags_repository.dart';
import '../../domain/entities/cart_snapshot.dart';
import '../../domain/entities/cart_totals.dart';
import '../../domain/usecases/refresh_cart_stock_usecases.dart';
import 'cart_events.dart';
import 'cart_states.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final WatchCartUseCase _watchCart;
  final AddToCartUseCase _addToCart;
  final UpdateQuantityUseCase _updateQuantity;
  final RemoveItemsUseCase _removeItems;
  final MoveItemsUseCase _moveItems;
  final RefreshCartStockUseCase _refreshStock;
  final FlagsRepository _flags;
  final CartTotalsCalculator _calculator;

  CartBloc({
    required this._watchCart,
    required this._addToCart,
    required this._updateQuantity,
    required this._removeItems,
    required this._moveItems,
    required this._refreshStock,
    required this._flags,
    this._calculator = const CartTotalsCalculator(),
  }) : super(const CartState()) {
    on<CartStarted>(_onStarted);
    on<CartItemAdded>(_onAdded);
    on<CartQtyChanged>(_onQtyChanged);
    on<CartItemsRemoved>((e, emit) async {
      await _removeItems(e.ids, fromSaved: e.fromSaved);
      emit(state.copyWith(selected: const {}));
    });
    on<CartItemsMoved>((e, emit) async {
      await _moveItems(e.ids, toSaved: e.toSaved);
      emit(state.copyWith(selected: const {}));
      _notify(emit, e.toSaved ? 'Saved for later' : 'Moved to cart');
    });
    on<CartSelectionToggled>((e, emit) {
      final next = {...state.selected};
      if (!next.add(e.productId)) next.remove(e.productId);
      emit(state.copyWith(selected: next));
    });
    on<CartSelectAll>(
      (e, emit) => emit(
        state.copyWith(
          selected: state.activeList.map((i) => i.productId).toSet(),
        ),
      ),
    );
    on<CartSelectionCleared>(
      (e, emit) => emit(state.copyWith(selected: const {})),
    );
    on<CartTabChanged>(
      (e, emit) => emit(state.copyWith(tabIndex: e.index, selected: const {})),
    );
    on<CartStockRefreshRequested>((e, emit) async {
      await _refreshStock();
    });
  }

  void _notify(Emitter<CartState> emit, String text) =>
      emit(state.copyWith(message: text, messageId: state.messageId + 1));

  Future<void> _onStarted(CartStarted e, Emitter<CartState> emit) async {
    add(const CartStockRefreshRequested());
    await emit.forEach<CartSnapshot>(_watchCart(), onData: _fromSnapshot);
  }

  CartState _fromSnapshot(CartSnapshot s) {
    final f = _flags.current;
    final ids = {...s.cart, ...s.saved}.map((i) => i.productId).toSet();
    return state.copyWith(
      cart: s.cart,
      saved: s.saved,
      loaded: true,
      totals: _calculator.calculate(
        s.cart,
        taxRate: f.taxRate,
        deliveryFee: f.deliveryFee,
        freeDeliveryThreshold: f.freeDeliveryThreshold,
      ),
      qtyById: {for (final i in s.cart) i.productId: i.qty},
      selected: state.selected.intersection(ids),
    );
  }

  Future<void> _onAdded(CartItemAdded e, Emitter<CartState> emit) async {
    final wasInCart = state.qtyOf(e.product.id) > 0;
    final outcome = await _addToCart(e.product, qty: e.qty);
    switch (outcome) {
      case CartOutcome.outOfStock:
        _notify(emit, '${e.product.title} is out of stock');
      case CartOutcome.clampedToStock:
        _notify(emit, 'Only ${e.product.stock} available');
      case CartOutcome.added:
        if (!wasInCart) _notify(emit, 'Added to cart');
    }
  }

  Future<void> _onQtyChanged(CartQtyChanged e, Emitter<CartState> emit) async {
    final outcome = await _updateQuantity(e.productId, e.qty);
    if (outcome == CartOutcome.clampedToStock) {
      final stock =
          state.cart
              .where((i) => i.productId == e.productId)
              .firstOrNull
              ?.stock ??
          0;
      _notify(emit, 'Only $stock available');
    }
  }
}
