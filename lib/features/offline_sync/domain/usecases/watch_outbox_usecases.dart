import 'package:grocermate/features/offline_sync/domain/entities/outbox_entry.dart';
import 'package:grocermate/features/offline_sync/domain/repositories/outbox_repository.dart';

class WatchOutboxUseCase {
  const WatchOutboxUseCase(this._repo);
  final OutboxRepository _repo;
  Stream<List<OutboxEntry>> call() => _repo.watch();
}
