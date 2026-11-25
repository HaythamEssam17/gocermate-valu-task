import 'package:grocermate/core/cache/caching_manager.dart';
import 'package:grocermate/core/network/result.dart';
import 'package:grocermate/features/catalog/domain/repositories/catalog_repository.dart';

class GetBrandsUseCase {
  const GetBrandsUseCase(this._repo);
  final CatalogRepository _repo;
  Future<Result<CachingManager<List<String>>>> call({String? categoryId}) =>
      _repo.getBrands(categoryId: categoryId);
}
