import 'package:grocermate/features/cart/domain/entities/cart_snapshot.dart';
import 'package:grocermate/features/cart/domain/repositories/cart_repository.dart';
import 'package:grocermate/features/products/domain/entities/product_entity.dart';

class AddToCartUseCase {
  const AddToCartUseCase(this._repo);
  final CartRepository _repo;
  Future<CartOutcome> call(ProductEntity product, {int qty = 1}) =>
      _repo.add(product, qty: qty);
}
