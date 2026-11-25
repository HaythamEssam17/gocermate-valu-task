import 'package:grocermate/core/storage/json_store.dart';
import 'package:grocermate/features/offline_sync/data/models/outbox_entry_model.dart';
import 'package:grocermate/features/offline_sync/domain/entities/outbox_entry.dart';

class OutboxLocalDataSource {
  OutboxLocalDataSource(this._store);
  final JsonStore _store;
  static const _key = 'outbox';
  static const _versionKey = 'sync_version';

  List<OutboxEntry> read() {
    final raw = _store.read(_key);
    if (raw is! List) return [];
    final out = <OutboxEntry>[];
    for (final e in raw) {
      try {
        out.add(OutboxEntryModel.fromJson(Map<String, dynamic>.from(e as Map)));
      } catch (_) {}
    }
    return out;
  }

  Future<void> write(List<OutboxEntry> entries) =>
      _store.write(_key, entries.map(OutboxEntryModel.toJson).toList());

  int readVersion() => (_store.read(_versionKey) as num?)?.toInt() ?? 42;
  Future<void> writeVersion(int v) => _store.write(_versionKey, v);
}
