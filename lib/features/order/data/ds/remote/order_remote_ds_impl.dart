import 'package:grocermate/core/network/api_client.dart';

import 'order_remote_ds.dart';

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  OrderRemoteDataSourceImpl(this._api);
  final ApiClient _api;

  @override
  Future<dynamic> getOrder(String orderId) => _api.get('/orders/$orderId');
}
