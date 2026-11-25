import 'package:grocermate/core/network/result.dart';
import 'package:grocermate/features/order/domain/entities/order_summary.dart';

import '../repositories/order_repository.dart';

class GetOrderUseCase {
  const GetOrderUseCase(this._repo);
  final OrderRepository _repo;

  Future<Result<OrderSummary>> call(String orderId) => _repo.getOrder(orderId);
}
