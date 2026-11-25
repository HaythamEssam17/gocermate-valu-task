import 'package:grocermate/features/cart/domain/entities/cart_snapshot.dart';
import 'package:grocermate/features/cart/domain/repositories/cart_repository.dart';

class UpdateQuantityUseCase {
  const UpdateQuantityUseCase(this._repo);
  final CartRepository _repo;
  Future<CartOutcome> call(String id, int qty) => _repo.setQty(id, qty);
}
