import 'package:equatable/equatable.dart';

class PurchaseLine extends Equatable {
  const PurchaseLine({
    required this.productId,
    required this.qty,
    this.expectedPrice,
  });
  final String productId;
  final int qty;

  final double? expectedPrice;

  @override
  List<Object?> get props => [productId, qty, expectedPrice];
}
