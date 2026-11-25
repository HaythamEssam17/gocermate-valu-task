import 'package:grocermate/features/cart/domain/repositories/cart_repository.dart';

class MoveItemsUseCase {
  const MoveItemsUseCase(this._repo);
  final CartRepository _repo;
  Future<void> call(Set<String> ids, {required bool toSaved}) =>
      _repo.move(ids, toSaved: toSaved);
}
