import 'package:grocermate/features/products/domain/entities/product_entity.dart';

sealed class CartEvent {
  const CartEvent();
}

class CartStarted extends CartEvent {
  const CartStarted();
}

class CartItemAdded extends CartEvent {
  const CartItemAdded(this.product, {this.qty = 1});
  final ProductEntity product;
  final int qty;
}

class CartQtyChanged extends CartEvent {
  const CartQtyChanged(this.productId, this.qty);
  final String productId;
  final int qty;
}

class CartItemsRemoved extends CartEvent {
  const CartItemsRemoved(this.ids, {this.fromSaved = false});
  final Set<String> ids;
  final bool fromSaved;
}

class CartItemsMoved extends CartEvent {
  const CartItemsMoved(this.ids, {required this.toSaved});
  final Set<String> ids;
  final bool toSaved;
}

class CartSelectionToggled extends CartEvent {
  const CartSelectionToggled(this.productId);
  final String productId;
}

class CartSelectAll extends CartEvent {
  const CartSelectAll();
}

class CartSelectionCleared extends CartEvent {
  const CartSelectionCleared();
}

class CartTabChanged extends CartEvent {
  const CartTabChanged(this.index);
  final int index;
}

class CartStockRefreshRequested extends CartEvent {
  const CartStockRefreshRequested();
}
