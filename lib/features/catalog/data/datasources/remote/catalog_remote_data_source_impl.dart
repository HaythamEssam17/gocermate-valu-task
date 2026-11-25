import 'package:grocermate/core/network/api_client.dart';

import 'catalog_remote_data_source.dart';

class CatalogRemoteDataSourceImpl implements CatalogRemoteDataSource {
  CatalogRemoteDataSourceImpl(this._api);
  final ApiClient _api;

  @override
  Future<dynamic> getBrands(String? categoryId) =>
      _api.get('/brands', query: {'categoryId': ?categoryId});

  @override
  Future<dynamic> getDealsOfDay() => _api.get('/deals-of-day');
}
