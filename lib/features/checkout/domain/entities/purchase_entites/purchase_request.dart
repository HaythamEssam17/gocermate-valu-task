import 'package:equatable/equatable.dart';
import 'package:grocermate/features/cart/domain/entities/cart_item.dart';

import 'purchase_line.dart';

class PurchaseRequest extends Equatable {
  const PurchaseRequest({
    required this.lines,
    this.idempotencyKey,
    this.currency = 'EGP',
  });

  factory PurchaseRequest.fromCartItems(
    List<CartItem> items, {
    required bool revalidatePrices,
    String? idempotencyKey,
    String currency = 'EGP',
  }) => PurchaseRequest(
    lines: [
      for (final i in items)
        PurchaseLine(
          productId: i.productId,
          qty: i.qty,
          expectedPrice: revalidatePrices ? i.unitPrice : null,
        ),
    ],
    idempotencyKey: idempotencyKey,
    currency: currency,
  );

  final List<PurchaseLine> lines;
  final String? idempotencyKey;
  final String currency;

  @override
  List<Object?> get props => [lines, idempotencyKey, currency];
}
