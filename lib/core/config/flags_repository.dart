import 'package:flutter/foundation.dart';

import '../network/api_client.dart';
import '../network/connectivity_service.dart';
import '../storage/cache_store.dart';
import 'app_flags.dart';

class FlagsRepository {
  FlagsRepository(this._api, this._cache, this._connectivity);

  final ApiClient _api;
  final CacheStore _cache;
  final ConnectivityService _connectivity;
  final ValueNotifier<AppFlags> _flags = ValueNotifier(const AppFlags());

  ValueListenable<AppFlags> get listenable => _flags;
  AppFlags get current => _flags.value;

  Future<void> load() async {
    final cached = _cache.get('flags');
    if (cached != null && cached.data is Map) {
      _flags.value = AppFlags.fromJson(
        Map<String, dynamic>.from(cached.data as Map),
      );
    }
    await refresh();
  }

  Future<void> refresh() async {
    if (!_connectivity.isOnline) return;
    try {
      final json = await _api.get('/flags').timeout(const Duration(seconds: 4));
      _flags.value = AppFlags.fromJson(Map<String, dynamic>.from(json as Map));
      await _cache.put('flags', json);
    } catch (_) {}
  }
}
