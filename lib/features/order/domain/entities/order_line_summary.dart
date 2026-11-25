import 'package:equatable/equatable.dart';

class OrderLineSummary extends Equatable {
  const OrderLineSummary({
    required this.productId,
    required this.qty,
    required this.unitPrice,
  });
  final String productId;
  final int qty;
  final double unitPrice;

  @override
  List<Object?> get props => [productId, qty, unitPrice];
}
