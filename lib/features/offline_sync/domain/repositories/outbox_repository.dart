import 'package:grocermate/features/cart/domain/entities/cart_item.dart';
import 'package:grocermate/features/offline_sync/domain/entities/outbox_entry.dart';

abstract interface class OutboxRepository {
  Stream<List<OutboxEntry>> watch();
  List<OutboxEntry> all();
  Future<OutboxEntry> enqueue(List<CartItem> items, {String? id});
  Future<void> update(OutboxEntry entry);
  Future<void> remove(String id);
}
