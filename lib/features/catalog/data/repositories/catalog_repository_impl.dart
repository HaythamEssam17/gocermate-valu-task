import 'package:grocermate/core/cache/caching_fetcher.dart';
import 'package:grocermate/core/cache/caching_manager.dart';
import 'package:grocermate/core/network/result.dart';
import 'package:grocermate/core/utils/suggestions.dart';
import 'package:grocermate/features/catalog/data/datasources/local/catalog_local_data_source.dart';
import 'package:grocermate/features/catalog/data/datasources/remote/catalog_remote_data_source.dart';
import 'package:grocermate/features/catalog/data/models/deal_model.dart';
import 'package:grocermate/features/catalog/domain/entities/deal.dart';
import 'package:grocermate/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:grocermate/features/products/domain/usecases/get_products_by_ids_usecase.dart';

class CatalogRepositoryImpl implements CatalogRepository {
  CatalogRepositoryImpl(
    this._remote,
    this._local,
    this._fetcher,
    this._getProductsByIds,
  );

  final CatalogRemoteDataSource _remote;
  final CatalogLocalDataSource _local;
  final CachingFetcher _fetcher;
  final GetProductsByIdsUseCase _getProductsByIds;

  @override
  Future<Result<CachingManager<List<String>>>> getBrands({
    String? categoryId,
  }) => _fetcher.fetch<List<String>>(
    key: 'brands:${categoryId ?? 'all'}',
    ttl: const Duration(hours: 6),
    remote: () => _remote.getBrands(categoryId),
    parse: (j) {
      if (j is! Map) return const [];
      final map = Map<String, dynamic>.from(j);
      final brands = categoryId != null
          ? (map[categoryId] as List? ?? const [])
          : map.values.expand((e) => e is List ? e : const []);
      return (brands.cast<String>().toSet().toList()..sort());
    },
  );

  @override
  Future<Result<CachingManager<List<DealEntity>>>> getDeals({
    bool forceRefresh = false,
  }) async {
    final result = await _fetcher.fetch<List<DealDto>>(
      key: 'deals',
      ttl: const Duration(minutes: 10),
      forceRefresh: forceRefresh,
      remote: _remote.getDealsOfDay,
      parse: (j) => DealDto.listFromJson(j),
    );
    switch (result) {
      case Failed<CachingManager<List<DealDto>>>(:final failure):
        return Failed(failure);
      case Success<CachingManager<List<DealDto>>>(:final value):
        final now = DateTime.now();
        final active = value.data.where((d) => d.endsAt.isAfter(now)).toList();
        final products = await _getProductsByIds(
          active.map((d) => d.productId).toList(),
        );

        final byId = {for (final p in products) p.id: p};
        final deals = [
          for (final d in active)
            if (byId[d.productId] != null)
              DealEntity(
                product: byId[d.productId]!,
                dealPrice: d.dealPrice,
                endsAt: d.endsAt,
              ),
        ];
        return Success(
          CachingManager(
            deals,
            fromCache: value.fromCache,
            createdAt: value.createdAt,
          ),
        );
    }
  }

  @override
  List<String> suggestFromCache(String query) =>
      buildSearchSuggestions(_local.titles(), query);
}
