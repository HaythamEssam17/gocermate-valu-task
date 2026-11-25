import 'dart:async';

import 'package:grocermate/core/error/map_error.dart';

import '../error/failure.dart';
import '../network/connectivity_service.dart';
import '../network/result.dart';
import '../storage/cache_store.dart';
import 'caching_manager.dart';

class CachingFetcher {
  CachingFetcher(
    this._cache,
    this._connectivity, {
    this.defaultTtl = const Duration(minutes: 2),
  });

  final CacheStore _cache;
  final ConnectivityService _connectivity;
  final Duration defaultTtl;

  Future<Result<CachingManager<T>>> fetch<T>({
    required String key,
    required Future<dynamic> Function() remote,
    required T Function(dynamic json) parse,
    Duration? ttl,
    bool forceRefresh = false,
  }) async {
    final entry = _cache.get(key);

    if (!_connectivity.isOnline) {
      if (entry == null) {
        return Failed<CachingManager<T>>(const OfflineFailure());
      }
      final hit = _tryEntry(entry, parse, fromCache: true);
      return hit != null
          ? Success<CachingManager<T>>(hit)
          : Failed<CachingManager<T>>(
              const UnknownFailure('Saved data is corrupted.'),
            );
    }

    if (entry != null && !forceRefresh && entry.age < (ttl ?? defaultTtl)) {
      final hit = _tryEntry(entry, parse, fromCache: false);
      if (hit != null) {
        unawaited(_revalidate(key, remote));
        return Success<CachingManager<T>>(hit);
      }
    }

    try {
      final json = await remote();
      final data = parse(json);
      await _cache.put(key, json);
      return Success<CachingManager<T>>(CachingManager<T>(data));
    } catch (e) {
      final fallback = entry == null
          ? null
          : _tryEntry(entry, parse, fromCache: true);
      if (fallback != null) return Success<CachingManager<T>>(fallback);
      return Failed<CachingManager<T>>(mapError(e));
    }
  }

  CachingManager<T>? _tryEntry<T>(
    CacheEntry entry,
    T Function(dynamic) parse, {
    required bool fromCache,
  }) {
    try {
      return CachingManager<T>(
        parse(entry.data),
        fromCache: fromCache,
        createdAt: entry.savedAt,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> _revalidate(
    String key,
    Future<dynamic> Function() remote,
  ) async {
    try {
      await _cache.put(key, await remote());
    } catch (_) {
      /* best effort */
    }
  }
}
