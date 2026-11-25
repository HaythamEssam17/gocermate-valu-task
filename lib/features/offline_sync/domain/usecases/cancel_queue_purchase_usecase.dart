import 'package:grocermate/features/cart/domain/repositories/cart_repository.dart';
import 'package:grocermate/features/offline_sync/domain/entities/outbox_entry.dart';
import 'package:grocermate/features/offline_sync/domain/repositories/outbox_repository.dart';

class CancelQueuedPurchaseUseCase {
  const CancelQueuedPurchaseUseCase(this._outbox, this._cart);
  final OutboxRepository _outbox;
  final CartRepository _cart;

  Future<void> call(OutboxEntry entry) async {
    await _cart.restore(entry.items);
    await _outbox.remove(entry.id);
  }
}
