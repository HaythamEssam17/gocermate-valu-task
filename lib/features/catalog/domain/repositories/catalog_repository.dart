import '../../../../core/cache/caching_manager.dart';
import '../../../../core/network/result.dart';
import '../entities/deal.dart';

abstract class CatalogRepository {
  Future<Result<CachingManager<List<String>>>> getBrands({String? categoryId});

  Future<Result<CachingManager<List<DealEntity>>>> getDeals({
    bool forceRefresh = false,
  });

  List<String> suggestFromCache(String query);
}
