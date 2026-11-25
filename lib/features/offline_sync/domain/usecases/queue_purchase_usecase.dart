import 'package:grocermate/features/cart/domain/entities/cart_item.dart';
import 'package:grocermate/features/cart/domain/repositories/cart_repository.dart';
import 'package:grocermate/features/offline_sync/domain/entities/outbox_entry.dart';
import 'package:grocermate/features/offline_sync/domain/repositories/outbox_repository.dart';

class QueuePurchaseUseCase {
  const QueuePurchaseUseCase(this._outbox, this._cart);
  final OutboxRepository _outbox;
  final CartRepository _cart;

  Future<OutboxEntry> call(
    List<CartItem> items, {
    String? idempotencyKey,
  }) async {
    await _cart.remove(items.map((i) => i.productId).toSet());
    return _outbox.enqueue(items, id: idempotencyKey);
  }
}
