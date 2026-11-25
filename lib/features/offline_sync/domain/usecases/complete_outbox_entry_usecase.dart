import 'package:grocermate/features/offline_sync/domain/entities/outbox_entry.dart';
import 'package:grocermate/features/offline_sync/domain/repositories/outbox_repository.dart';

class CompleteOutboxEntryUseCase {
  const CompleteOutboxEntryUseCase(this._outbox);
  final OutboxRepository _outbox;

  Future<void> call(
    String id, {
    String? orderId,
    double? total,
    String? note,
  }) async {
    final entry = _outbox.all().where((e) => e.id == id).firstOrNull;
    if (entry == null) return;
    await _outbox.update(
      entry.copyWith(
        status: OutboxStatus.completed,
        orderId: orderId,
        total: total,
        note: note,
      ),
    );
  }
}
