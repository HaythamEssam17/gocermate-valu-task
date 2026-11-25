import 'package:equatable/equatable.dart';

import '../../../cart/domain/entities/cart_item.dart';

enum OutboxStatus { queued, syncing, needsReview, completed, failed }

/// A purchase placed while offline, waiting to be revalidated & submitted.
/// [id] doubles as the idempotency key so a retry can never create two orders.
class OutboxEntry extends Equatable {
  const OutboxEntry({
    required this.id,
    required this.items,
    required this.createdAt,
    this.status = OutboxStatus.queued,
    this.attempts = 0,
    this.note,
    this.orderId,
    this.total,
  });

  final String id;
  final List<CartItem> items;
  final DateTime createdAt;
  final OutboxStatus status;
  final int attempts;
  final String? note;
  final String? orderId;
  final double? total;

  double get estimatedTotal => items.fold(0.0, (s, i) => s + i.lineTotal);
  int get itemCount => items.fold(0, (s, i) => s + i.qty);
  bool get isPending => status == OutboxStatus.queued || status == OutboxStatus.syncing;

  OutboxEntry copyWith({
    OutboxStatus? status,
    int? attempts,
    String? note,
    String? orderId,
    double? total,
    List<CartItem>? items,
  }) =>
      OutboxEntry(
        id: id,
        items: items ?? this.items,
        createdAt: createdAt,
        status: status ?? this.status,
        attempts: attempts ?? this.attempts,
        note: note ?? this.note,
        orderId: orderId ?? this.orderId,
        total: total ?? this.total,
      );

  @override
  List<Object?> get props => [id, items, createdAt, status, attempts, note, orderId, total];
}
