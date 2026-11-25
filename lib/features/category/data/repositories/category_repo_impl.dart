import 'package:grocermate/core/cache/caching_fetcher.dart';
import 'package:grocermate/core/cache/caching_manager.dart';
import 'package:grocermate/core/network/result.dart';
import 'package:grocermate/features/category/data/models/category_model.dart';
import 'package:grocermate/features/category/domain/entities/category_entity.dart';

import '../../domain/repositories/category_repository.dart';
import '../ds/remote/category_remote_ds.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remote;
  final CachingFetcher _fetcher;

  CategoryRepositoryImpl(this.remote, this._fetcher);

  @override
  Future<Result<CachingManager<List<CategoryEntity>>>> getCategories({
    bool forceRefresh = false,
  }) => _fetcher.fetch<List<CategoryEntity>>(
    key: 'categories',
    ttl: const Duration(hours: 6),
    forceRefresh: forceRefresh,
    remote: remote.getCategories,
    parse: (j) => (j as List)
        .map<CategoryEntity>(
          (e) => CategoryModel.fromJson(Map<String, dynamic>.from(e as Map)),
        )
        .toList(),
  );
}
