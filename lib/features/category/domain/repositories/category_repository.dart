import 'package:grocermate/core/cache/caching_manager.dart';
import 'package:grocermate/core/network/result.dart';
import 'package:grocermate/features/category/domain/entities/category_entity.dart';

abstract class CategoryRepository {
  Future<Result<CachingManager<List<CategoryEntity>>>> getCategories({
    bool forceRefresh = false,
  });
}
