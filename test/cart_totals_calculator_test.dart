import 'package:flutter_test/flutter_test.dart';
import 'package:grocermate/features/cart/domain/entities/cart_item.dart';
import 'package:grocermate/features/cart/domain/entities/cart_totals.dart';

CartItem item(String id, double price, double original, int qty) => CartItem(
      productId: id,
      title: id,
      brand: 'b',
      image: '',
      categoryId: 'c',
      unitPrice: price,
      originalPrice: original,
      stock: 99,
      qty: qty,
    );

void main() {
  const calc = CartTotalsCalculator();

  CartTotals run(List<CartItem> items) => calc.calculate(
        items,
        taxRate: 0.05,
        deliveryFee: 1.0,
        freeDeliveryThreshold: 25.0,
      );

  test('empty cart has zero totals and no delivery fee', () {
    expect(run([]), CartTotals.empty);
  });

  test('matches the order example of the task (subtotal 5.07 -> total 6.32)', () {
    final t = run([item('milk', 1.29, 1.49, 2), item('apple', 2.49, 2.99, 1)]);
    expect(t.subtotal, 5.07);
    expect(t.tax, 0.25);
    expect(t.delivery, 1.0);
    expect(t.total, 6.32);
    expect(t.itemCount, 3);
  });

  test('discount is the difference between list price and price', () {
    final t = run([item('milk', 1.29, 1.49, 2)]);
    expect(t.itemsTotal, 2.98);
    expect(t.discount, 0.4);
  });

  test('delivery is free from the threshold', () {
    final t = run([item('big', 25.0, 25.0, 1)]);
    expect(t.delivery, 0);
    expect(t.freeDeliveryRemaining, 0);
  });

  test('reports how much is missing for free delivery', () {
    final t = run([item('a', 10.0, 10.0, 1)]);
    expect(t.freeDeliveryRemaining, 15.0);
  });
}
