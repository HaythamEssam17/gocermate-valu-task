import 'package:grocermate/core/cache/caching_manager.dart';
import 'package:grocermate/core/network/result.dart';
import 'package:grocermate/features/products/domain/entities/paged_products.dart';
import 'package:grocermate/features/products/domain/entities/product_entity.dart';
import 'package:grocermate/features/products/domain/entities/products_query.dart';

abstract class ProductsRepository {
  Future<Result<CachingManager<PagedProducts>>> getProducts(
    ProductsQuery query,
  );

  Future<List<ProductEntity>> getProductsByIds(List<String> ids);
}
