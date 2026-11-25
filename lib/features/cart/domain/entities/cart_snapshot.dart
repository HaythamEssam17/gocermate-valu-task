import 'package:equatable/equatable.dart';

import 'cart_item.dart';

class CartSnapshot extends Equatable {
  const CartSnapshot({this.cart = const [], this.saved = const []});
  final List<CartItem> cart;
  final List<CartItem> saved;

  @override
  List<Object?> get props => [cart, saved];
}

enum CartOutcome { added, clampedToStock, outOfStock }
