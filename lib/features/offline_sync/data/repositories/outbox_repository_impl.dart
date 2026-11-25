import 'dart:async';

import '../../../cart/domain/entities/cart_item.dart';
import '../../domain/entities/outbox_entry.dart';
import '../../domain/repositories/outbox_repository.dart';
import '../datasources/outbox_local_data_source.dart';

class OutboxRepositoryImpl implements OutboxRepository {
  OutboxRepositoryImpl(this._local) {
    // A crash while "syncing" must not leave an entry stuck: treat it as queued.
    _entries = _local
        .read()
        .map((e) => e.status == OutboxStatus.syncing ? e.copyWith(status: OutboxStatus.queued) : e)
        .toList();
  }

  final OutboxLocalDataSource _local;
  final _controller = StreamController<List<OutboxEntry>>.broadcast();
  late List<OutboxEntry> _entries;

  @override
  Stream<List<OutboxEntry>> watch() async* {
    yield all();
    yield* _controller.stream;
  }

  @override
  List<OutboxEntry> all() => List.unmodifiable(_entries);

  Future<void> _commit(List<OutboxEntry> next) async {
    _entries = next;
    _controller.add(all());
    await _local.write(next);
  }

  @override
  Future<OutboxEntry> enqueue(List<CartItem> items, {String? id}) async {
    final entry = OutboxEntry(
      id: id ?? 'ob_${DateTime.now().microsecondsSinceEpoch}',
      items: items,
      createdAt: DateTime.now(),
    );
    await _commit([entry, ..._entries.where((e) => e.id != entry.id)]);
    return entry;
  }

  @override
  Future<void> update(OutboxEntry entry) =>
      _commit([for (final e in _entries) e.id == entry.id ? entry : e]);

  @override
  Future<void> remove(String id) => _commit(_entries.where((e) => e.id != id).toList());
}
