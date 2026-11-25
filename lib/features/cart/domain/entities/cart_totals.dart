import 'package:equatable/equatable.dart';
import 'package:grocermate/core/utils/extensions/num_extensions.dart';

import 'cart_item.dart';

class CartTotals extends Equatable {
  const CartTotals({
    required this.itemCount,
    required this.itemsTotal,
    required this.discount,
    required this.subtotal,
    required this.tax,
    required this.delivery,
    required this.total,
    required this.freeDeliveryRemaining,
  });

  static const empty = CartTotals(
    itemCount: 0,
    itemsTotal: 0,
    discount: 0,
    subtotal: 0,
    tax: 0,
    delivery: 0,
    total: 0,
    freeDeliveryRemaining: 0,
  );

  final int itemCount;
  final double itemsTotal;
  final double discount;
  final double subtotal;
  final double tax;
  final double delivery;
  final double total;
  final double freeDeliveryRemaining;

  @override
  List<Object?> get props => [
    itemCount,
    itemsTotal,
    discount,
    subtotal,
    tax,
    delivery,
    total,
    freeDeliveryRemaining,
  ];
}

class CartTotalsCalculator {
  const CartTotalsCalculator();

  CartTotals calculate(
    List<CartItem> items, {
    required double taxRate,
    required double deliveryFee,
    required double freeDeliveryThreshold,
  }) {
    if (items.isEmpty) return CartTotals.empty;
    final itemsTotal = items
        .fold(0.0, (s, i) => s + i.listPrice * i.qty)
        .roundAmountToDouble();

    final subtotal = (items.fold(
      0.0,
      (s, i) => s + i.unitPrice * i.qty,
    )).roundAmountToDouble();
    final tax = (subtotal * taxRate).roundAmountToDouble();
    final delivery = subtotal >= freeDeliveryThreshold ? 0.0 : deliveryFee;

    return CartTotals(
      itemCount: items.fold(0, (s, i) => s + i.qty),
      itemsTotal: itemsTotal,
      discount: (itemsTotal - subtotal).roundAmountToDouble(),
      subtotal: subtotal,
      tax: tax,
      delivery: delivery,
      total: (subtotal + tax + delivery).roundAmountToDouble(),
      freeDeliveryRemaining: delivery > 0
          ? (freeDeliveryThreshold - subtotal).roundAmountToDouble()
          : 0,
    );
  }
}
