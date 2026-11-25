import 'package:equatable/equatable.dart';

import 'order_line_summary.dart';

class OrderSummary extends Equatable {
  const OrderSummary({
    required this.orderId,
    required this.status,
    required this.createdAt,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.deliveryFee,
    required this.total,
  });

  final String orderId;
  final String status;
  final DateTime createdAt;
  final List<OrderLineSummary> items;
  final double subtotal;
  final double tax;
  final double deliveryFee;
  final double total;

  @override
  List<Object?> get props => [
    orderId,
    status,
    createdAt,
    items,
    subtotal,
    tax,
    deliveryFee,
    total,
  ];
}
