import 'package:grocermate/core/cache/caching_manager.dart';
import 'package:grocermate/core/network/result.dart';
import 'package:grocermate/features/product_details/domain/entities/product_details.dart';
import 'package:grocermate/features/product_details/domain/repositories/product_details_repository.dart';

class GetProductDetailsUseCase {
  const GetProductDetailsUseCase(this._repo);
  final ProductDetailsRepository _repo;
  Future<Result<CachingManager<ProductDetails>>> call(String id) =>
      _repo.getDetails(id);
}
