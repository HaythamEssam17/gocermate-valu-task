import 'json_store.dart';

class CacheEntry {
  const CacheEntry(this.data, this.savedAt);
  final dynamic data;
  final DateTime savedAt;

  Duration get age => DateTime.now().difference(savedAt);
}

class CacheStore {
  CacheStore(this._store);
  final JsonStore _store;

  CacheEntry? get(String key) {
    final raw = _store.read('c:$key');
    if (raw is! Map) return null;
    final ts = raw['ts'];
    if (ts is! int) return null;
    return CacheEntry(raw['data'], DateTime.fromMillisecondsSinceEpoch(ts));
  }

  Future<void> put(String key, dynamic data) => _store.write('c:$key', {
    'ts': DateTime.now().millisecondsSinceEpoch,
    'data': data,
  });

  Future<void> clear() async {
    for (final k in _store.keys.where((k) => k.startsWith('c:')).toList()) {
      await _store.delete(k);
    }
  }
}
