import 'package:grocermate/core/network/result.dart';
import 'package:grocermate/features/cart/domain/repositories/cart_repository.dart';

class RefreshCartStockUseCase {
  const RefreshCartStockUseCase(this._repo);
  final CartRepository _repo;
  Future<Result<void>> call() => _repo.refreshStock();
}
