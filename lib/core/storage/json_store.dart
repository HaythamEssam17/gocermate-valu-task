import 'dart:convert';

import 'package:hive/hive.dart';

abstract interface class JsonStore {
  dynamic read(String key);
  Future<void> write(String key, Object? value);
  Future<void> delete(String key);
  Iterable<String> get keys;
}

class HiveJsonStore implements JsonStore {
  HiveJsonStore(this._box);
  final Box<String> _box;

  @override
  dynamic read(String key) {
    final raw = _box.get(key);
    return raw == null ? null : jsonDecode(raw);
  }

  @override
  Future<void> write(String key, Object? value) =>
      _box.put(key, jsonEncode(value));

  @override
  Future<void> delete(String key) => _box.delete(key);

  @override
  Iterable<String> get keys => _box.keys.cast<String>();
}

class InMemoryJsonStore implements JsonStore {
  final Map<String, String> _data = {};

  @override
  dynamic read(String key) {
    final raw = _data[key];
    return raw == null ? null : jsonDecode(raw);
  }

  @override
  Future<void> write(String key, Object? value) async =>
      _data[key] = jsonEncode(value);

  @override
  Future<void> delete(String key) async => _data.remove(key);

  @override
  Iterable<String> get keys => _data.keys;
}
