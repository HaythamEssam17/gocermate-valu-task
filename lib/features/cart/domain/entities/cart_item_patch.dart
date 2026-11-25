import 'package:equatable/equatable.dart';

class CartItemPatch extends Equatable {
  const CartItemPatch(this.productId, {this.unitPrice, this.stock, this.qty});
  final String productId;
  final double? unitPrice;
  final int? stock;
  final int? qty;

  @override
  List<Object?> get props => [productId, unitPrice, stock, qty];
}
