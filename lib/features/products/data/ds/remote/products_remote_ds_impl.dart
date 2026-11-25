import 'package:grocermate/core/network/api_client.dart';
import 'package:grocermate/features/products/domain/entities/products_query.dart';

import 'products_remote_ds.dart';

class ProductsRemoteDataSourceImpl implements ProductsRemoteDataSource {
  final ApiClient _api;

  ProductsRemoteDataSourceImpl(this._api);

  @override
  Future<dynamic> getProducts(ProductsQuery q) => _api.get(
    '/products',
    query: {
      if (q.categoryId != null) 'category': q.categoryId,
      'page': q.page,
      'pageSize': q.pageSize,
      if (q.search != null && q.search!.isNotEmpty) 'search': q.search,
      if (q.brand != null) 'brand': q.brand,
    },
  );

  @override
  Future<dynamic> getProductsByIds(List<String> ids) => _api.get(
    '/products',
    query: {'ids': ids.join(','), 'pageSize': ids.length},
  );
}
