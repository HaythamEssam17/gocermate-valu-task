import 'package:grocermate/features/cart/domain/entities/cart_snapshot.dart';
import 'package:grocermate/features/cart/domain/repositories/cart_repository.dart';

class WatchCartUseCase {
  const WatchCartUseCase(this._repo);
  final CartRepository _repo;
  Stream<CartSnapshot> call() => _repo.watch();
}
