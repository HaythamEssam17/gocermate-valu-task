import 'package:grocermate/features/cart/domain/entities/cart_item.dart';
import 'package:grocermate/features/cart/domain/repositories/cart_repository.dart';

class RestoreToCartUseCase {
  const RestoreToCartUseCase(this._repo);
  final CartRepository _repo;
  Future<void> call(List<CartItem> items) => _repo.restore(items);
}
