import 'package:grocermate/core/storage/json_store.dart';

class RecentSearchesLocalDataSource {
  RecentSearchesLocalDataSource(this._store);

  final JsonStore _store;
  static const _key = 'recent_searches';
  static const _max = 10;

  List<String> read() {
    final raw = _store.read(_key);
    return raw is List ? raw.whereType<String>().toList() : <String>[];
  }

  Future<void> add(String q) {
    final list = read()..removeWhere((e) => e.toLowerCase() == q.toLowerCase());
    list.insert(0, q);
    return _store.write(_key, list.take(_max).toList());
  }

  Future<void> clear() => _store.delete(_key);
}
