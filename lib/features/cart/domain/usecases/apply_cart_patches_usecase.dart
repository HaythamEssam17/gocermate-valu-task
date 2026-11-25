import 'package:grocermate/features/cart/domain/entities/cart_item_patch.dart';
import 'package:grocermate/features/cart/domain/repositories/cart_repository.dart';

class ApplyCartPatchesUseCase {
  const ApplyCartPatchesUseCase(this._repo);
  final CartRepository _repo;
  Future<void> call(List<CartItemPatch> patches) => _repo.applyPatches(patches);
}
