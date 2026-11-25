import 'package:grocermate/core/cache/caching_manager.dart';
import 'package:grocermate/features/product_details/domain/entities/inventory.dart';
import 'package:grocermate/features/product_details/domain/entities/price_history.dart';

import '../../../../core/network/result.dart';
import '../entities/product_details.dart';

abstract interface class ProductDetailsRepository {
  Future<Result<CachingManager<ProductDetails>>> getDetails(String id);
  Future<Result<CachingManager<Inventory>>> getInventory(String id);
  Future<Result<CachingManager<PriceHistory>>> getPriceHistory(String id);
}
