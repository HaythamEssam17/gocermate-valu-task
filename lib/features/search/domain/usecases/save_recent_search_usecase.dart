import 'package:grocermate/features/search/domain/repositories/search_repository.dart';

class SaveRecentSearchUseCase {
  const SaveRecentSearchUseCase(this._repo);

  final SearchRepository _repo;

  Future<void> call(String q) => _repo.saveRecentSearch(q);
}
