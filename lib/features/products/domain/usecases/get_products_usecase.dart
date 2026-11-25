import 'package:grocermate/core/cache/caching_manager.dart';
import 'package:grocermate/core/network/result.dart';
import 'package:grocermate/features/products/domain/entities/paged_products.dart';
import 'package:grocermate/features/products/domain/entities/products_query.dart';
import 'package:grocermate/features/products/domain/repositories/products_repository.dart';

class GetProductsUseCase {
  const GetProductsUseCase(this._repo);
  final ProductsRepository _repo;

  Future<Result<CachingManager<PagedProducts>>> call(ProductsQuery query) =>
      _repo.getProducts(query);
}
