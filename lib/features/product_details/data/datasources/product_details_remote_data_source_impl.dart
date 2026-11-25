import 'package:grocermate/core/network/api_client.dart';

import 'product_details_remote_data_source.dart';

class ProductDetailsRemoteDataSourceImpl
    implements ProductDetailsRemoteDataSource {
  ProductDetailsRemoteDataSourceImpl(this._api);
  final ApiClient _api;

  @override
  Future<dynamic> details(String id) => _api.get('/product/$id');

  @override
  Future<dynamic> inventory(String id) => _api.get('/inventory/$id');

  @override
  Future<dynamic> priceHistory(String id) => _api.get('/price-history/$id');
}
