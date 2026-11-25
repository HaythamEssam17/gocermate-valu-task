import 'package:grocermate/core/cache/caching_fetcher.dart';
import 'package:grocermate/core/cache/caching_manager.dart';
import 'package:grocermate/core/network/result.dart';
import 'package:grocermate/features/product_details/data/datasources/product_details_remote_data_source.dart';
import 'package:grocermate/features/product_details/data/models/inventory_model.dart';
import 'package:grocermate/features/product_details/data/models/price_history_model.dart';
import 'package:grocermate/features/product_details/data/models/product_details_model.dart';
import 'package:grocermate/features/product_details/domain/entities/inventory.dart';
import 'package:grocermate/features/product_details/domain/entities/price_history.dart';
import 'package:grocermate/features/product_details/domain/entities/product_details.dart';
import 'package:grocermate/features/product_details/domain/repositories/product_details_repository.dart';

class ProductDetailsRepositoryImpl implements ProductDetailsRepository {
  ProductDetailsRepositoryImpl(this._remote, this._fetcher);
  final ProductDetailsRemoteDataSource _remote;
  final CachingFetcher _fetcher;

  Map<String, dynamic> _map(dynamic j) => Map<String, dynamic>.from(j as Map);

  @override
  Future<Result<CachingManager<ProductDetails>>> getDetails(String id) =>
      _fetcher.fetch<ProductDetails>(
        key: 'details:$id',
        remote: () => _remote.details(id),
        parse: (j) => ProductDetailsModel.fromJson(_map(j)),
      );

  @override
  Future<Result<CachingManager<Inventory>>> getInventory(String id) =>
      _fetcher.fetch<Inventory>(
        key: 'inventory:$id',
        ttl: const Duration(seconds: 30),
        remote: () => _remote.inventory(id),
        parse: (j) => InventoryModel.fromJson(_map(j)),
      );

  @override
  Future<Result<CachingManager<PriceHistory>>> getPriceHistory(String id) =>
      _fetcher.fetch<PriceHistory>(
        key: 'history:$id',
        remote: () => _remote.priceHistory(id),
        parse: (j) => PriceHistoryModel.fromJson(_map(j)),
      );
}
