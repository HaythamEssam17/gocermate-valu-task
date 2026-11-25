import 'package:grocermate/core/cache/caching_manager.dart';
import 'package:grocermate/core/network/result.dart';
import 'package:grocermate/features/product_details/domain/entities/inventory.dart';
import 'package:grocermate/features/product_details/domain/repositories/product_details_repository.dart';

class GetInventoryUseCase {
  const GetInventoryUseCase(this._repo);
  final ProductDetailsRepository _repo;

  Future<Result<CachingManager<Inventory>>> call(String id) =>
      _repo.getInventory(id);
}
