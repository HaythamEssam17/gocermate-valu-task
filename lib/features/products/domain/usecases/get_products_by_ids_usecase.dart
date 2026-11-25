import 'package:grocermate/features/products/domain/entities/product_entity.dart';
import 'package:grocermate/features/products/domain/repositories/products_repository.dart';

class GetProductsByIdsUseCase {
  const GetProductsByIdsUseCase(this._repo);
  final ProductsRepository _repo;
  Future<List<ProductEntity>> call(List<String> ids) =>
      _repo.getProductsByIds(ids);
}
