import 'package:grocermate/core/network/result.dart';
import 'package:grocermate/core/utils/guard.dart';
import 'package:grocermate/features/order/data/models/order_model.dart';
import 'package:grocermate/features/order/domain/entities/order_summary.dart';

import '../../domain/repositories/order_repository.dart';
import '../ds/remote/order_remote_ds.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remote;

  OrderRepositoryImpl(this.remote);

  @override
  Future<Result<OrderSummary>> getOrder(String orderId) => guard(() async {
    final json = await remote.getOrder(orderId);
    return OrderModel.fromJson(Map<String, dynamic>.from(json as Map));
  });
}
