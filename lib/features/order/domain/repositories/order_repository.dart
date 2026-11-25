import 'package:grocermate/core/network/result.dart';
import 'package:grocermate/features/order/domain/entities/order_summary.dart';

abstract class OrderRepository {
  Future<Result<OrderSummary>> getOrder(String orderId);
}
