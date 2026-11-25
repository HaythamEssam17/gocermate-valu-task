import 'package:grocermate/features/order/domain/entities/order_line_summary.dart';
import 'package:grocermate/features/order/domain/entities/order_summary.dart';

class OrderModel extends OrderSummary {
  const OrderModel({
    required super.orderId,
    required super.status,
    required super.createdAt,
    required super.items,
    required super.subtotal,
    required super.tax,
    required super.deliveryFee,
    required super.total,
  });

  factory OrderModel.fromJson(Map<String, dynamic> j) => OrderModel(
    orderId: j['orderId'] as String,
    status: j['status'] as String,
    createdAt: DateTime.parse(j['createdAt'] as String).toLocal(),
    items: (j['items'] as List)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .map(
          (e) => OrderLineSummary(
            productId: e['productId'] as String,
            qty: (e['qty'] as num).toInt(),
            unitPrice: (e['unitPrice'] as num).toDouble(),
          ),
        )
        .toList(),
    subtotal: (j['subtotal'] as num).toDouble(),
    tax: (j['tax'] as num).toDouble(),
    deliveryFee: (j['deliveryFee'] as num).toDouble(),
    total: (j['total'] as num).toDouble(),
  );
}
