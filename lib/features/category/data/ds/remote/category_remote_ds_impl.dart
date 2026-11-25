import 'package:grocermate/core/network/api_client.dart';

import 'category_remote_ds.dart';

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  CategoryRemoteDataSourceImpl(this._api);
  final ApiClient _api;

  @override
  Future<dynamic> getCategories() => _api.get('/categories');
}
