import 'package:grocermate/core/cache/caching_manager.dart';
import 'package:grocermate/core/network/result.dart';
import 'package:grocermate/features/catalog/domain/entities/deal.dart';
import 'package:grocermate/features/catalog/domain/repositories/catalog_repository.dart';

class GetDealsUseCase {
  const GetDealsUseCase(this._repo);
  final CatalogRepository _repo;

  Future<Result<CachingManager<List<DealEntity>>>> call({
    bool forceRefresh = false,
  }) => _repo.getDeals(forceRefresh: forceRefresh);
}
