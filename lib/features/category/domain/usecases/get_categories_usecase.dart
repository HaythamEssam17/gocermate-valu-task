import 'package:grocermate/core/cache/caching_manager.dart';
import 'package:grocermate/core/network/result.dart';
import 'package:grocermate/features/category/domain/entities/category_entity.dart';
import 'package:grocermate/features/category/domain/repositories/category_repository.dart';

class GetCategoriesUseCase {
  const GetCategoriesUseCase(this._repo);
  final CategoryRepository _repo;

  Future<Result<CachingManager<List<CategoryEntity>>>> call({
    bool forceRefresh = false,
  }) => _repo.getCategories(forceRefresh: forceRefresh);
}
