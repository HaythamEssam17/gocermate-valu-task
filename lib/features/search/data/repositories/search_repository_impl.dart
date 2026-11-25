import 'package:grocermate/core/network/connectivity_service.dart';
import 'package:grocermate/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:grocermate/features/search/data/datasources/recent_searches_local_data_source.dart';
import 'package:grocermate/features/search/data/datasources/search_remote_data_source.dart';
import 'package:grocermate/features/search/domain/repositories/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  SearchRepositoryImpl(
    this._remote,
    this._recents,
    this._catalog,
    this._connectivity,
  );

  final SearchRemoteDataSource _remote;
  final RecentSearchesLocalDataSource _recents;
  final CatalogRepository _catalog;
  final ConnectivityService _connectivity;

  @override
  Future<List<String>> getSuggestions(String query) async {
    if (_connectivity.isOnline) {
      try {
        return await _remote.suggest(query);
      } catch (_) {}
    }
    return _catalog.suggestFromCache(query);
  }

  @override
  List<String> getRecentSearches() => _recents.read();

  @override
  Future<void> saveRecentSearch(String query) => _recents.add(query);

  @override
  Future<void> clearRecentSearches() => _recents.clear();
}
