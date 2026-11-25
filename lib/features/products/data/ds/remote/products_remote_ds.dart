import 'package:grocermate/features/products/domain/entities/products_query.dart';

abstract class ProductsRemoteDataSource {
  Future<dynamic> getProducts(ProductsQuery query);

  Future<dynamic> getProductsByIds(List<String> ids);
}
