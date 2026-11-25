import 'package:grocermate/core/network/api_client.dart';

import 'checkout_remote_data_source_impl.dart';

class CheckoutRemoteDataSourceImpl implements CheckoutRemoteDataSource {
  CheckoutRemoteDataSourceImpl(this._api);
  final ApiClient _api;

  @override
  Future<dynamic> purchase(Map<String, dynamic> body) =>
      _api.post('/purchase', body: body);
}
