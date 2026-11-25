import 'package:grocermate/core/cache/caching_manager.dart';
import 'package:grocermate/core/network/result.dart';
import 'package:grocermate/features/product_details/domain/entities/price_history.dart';
import 'package:grocermate/features/product_details/domain/repositories/product_details_repository.dart';

class GetPriceHistoryUseCase {
  const GetPriceHistoryUseCase(this._repo);
  final ProductDetailsRepository _repo;

  Future<Result<CachingManager<PriceHistory>>> call(String id) =>
      _repo.getPriceHistory(id);
}
