import 'package:grocermate/features/cart/domain/repositories/cart_repository.dart';

class RemoveItemsUseCase {
  const RemoveItemsUseCase(this._repo);
  final CartRepository _repo;
  Future<void> call(Set<String> ids, {bool fromSaved = false}) =>
      _repo.remove(ids, fromSaved: fromSaved);
}
