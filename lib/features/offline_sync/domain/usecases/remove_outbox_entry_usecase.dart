import 'package:grocermate/features/offline_sync/domain/repositories/outbox_repository.dart';

class RemoveOutboxEntryUseCase {
  const RemoveOutboxEntryUseCase(this._outbox);
  final OutboxRepository _outbox;
  Future<void> call(String id) => _outbox.remove(id);
}
