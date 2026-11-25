import '../../../cart/data/models/cart_item_model.dart';
import '../../domain/entities/outbox_entry.dart';

class OutboxEntryModel {
  const OutboxEntryModel._();

  static Map<String, dynamic> toJson(OutboxEntry e) => {
    'id': e.id,
    'items': CartItemModel.listToJson(e.items),
    'createdAt': e.createdAt.toIso8601String(),
    'status': e.status.name,
    'attempts': e.attempts,
    'note': e.note,
    'orderId': e.orderId,
    'total': e.total,
  };

  static OutboxEntry fromJson(Map<String, dynamic> j) => OutboxEntry(
    id: j['id'] as String,
    items: CartItemModel.listFromJson(j['items']),
    createdAt: DateTime.parse(j['createdAt'] as String),
    status: OutboxStatus.values.firstWhere(
      (s) => s.name == j['status'],
      orElse: () => OutboxStatus.queued,
    ),
    attempts: (j['attempts'] as num?)?.toInt() ?? 0,
    note: j['note'] as String?,
    orderId: j['orderId'] as String?,
    total: (j['total'] as num?)?.toDouble(),
  );
}
