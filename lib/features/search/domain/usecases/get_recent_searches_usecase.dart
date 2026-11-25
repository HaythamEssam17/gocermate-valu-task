import 'package:grocermate/features/search/domain/repositories/search_repository.dart';

class GetRecentSearchesUseCase {
  const GetRecentSearchesUseCase(this._repo);

  final SearchRepository _repo;

  List<String> call() => _repo.getRecentSearches();
}
