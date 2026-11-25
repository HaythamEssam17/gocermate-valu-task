import 'package:grocermate/core/cache/caching_fetcher.dart';
import 'package:grocermate/core/cache/caching_manager.dart';
import 'package:grocermate/core/network/connectivity_service.dart';
import 'package:grocermate/core/network/result.dart';
import 'package:grocermate/features/catalog/data/datasources/local/catalog_local_data_source.dart';
import 'package:grocermate/features/products/data/models/paged_products_model.dart';
import 'package:grocermate/features/products/data/models/product_model.dart';
import 'package:grocermate/features/products/domain/entities/paged_products.dart';
import 'package:grocermate/features/products/domain/entities/product_entity.dart';
import 'package:grocermate/features/products/domain/entities/products_query.dart';

import '../../domain/repositories/products_repository.dart';
import '../ds/remote/products_remote_ds.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsRemoteDataSource remote;
  final CachingFetcher _fetcher;
  final CatalogLocalDataSource _local;
  final ConnectivityService _connectivity;

  ProductsRepositoryImpl(
    this.remote,
    this._fetcher,
    this._local,
    this._connectivity,
  );

  @override
  Future<Result<CachingManager<PagedProducts>>> getProducts(
    ProductsQuery q,
  ) async {
    final result = await _fetcher.fetch<PagedProducts>(
      key:
          'products:${q.categoryId}|${q.search}|${q.brand}|${q.page}|${q.pageSize}',
      forceRefresh: q.forceRefresh,
      remote: () => remote.getProducts(q),
      parse: (j) =>
          PagedProductsModel.fromJson(Map<String, dynamic>.from(j as Map)),
    );
    switch (result) {
      case Success<CachingManager<PagedProducts>>(:final value):
        if (!value.fromCache) await _local.upsert(value.data.items);
        return result;
      case Failed<CachingManager<PagedProducts>>(:final failure):
        if (_local.count == 0) return Failed(failure);
        return Success(CachingManager(_local.query(q), fromCache: true));
    }
  }

  @override
  Future<List<ProductEntity>> getProductsByIds(List<String> ids) async {
    final found = {for (final p in _local.byIds(ids)) p.id: p};
    final missing = ids.where((id) => !found.containsKey(id)).toList();

    if (missing.isNotEmpty && _connectivity.isOnline) {
      try {
        final json = Map<String, dynamic>.from(
          await remote.getProductsByIds(missing) as Map,
        );
        final fetched = PagedProductsModel.fromJson(json).items;
        await _local.upsert(fetched);
        for (final p in fetched) {
          found[p.id] = ProductModel.fromEntity(p);
        }
      } catch (_) {}
    }
    return [
      for (final id in ids)
        if (found[id] != null) found[id]!,
    ];
  }
}
