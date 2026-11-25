import 'package:grocermate/features/search/domain/repositories/search_repository.dart';

class ClearRecentSearchesUseCase {
  const ClearRecentSearchesUseCase(this._repo);

  final SearchRepository _repo;

  Future<void> call() => _repo.clearRecentSearches();
}
