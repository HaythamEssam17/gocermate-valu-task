import 'package:grocermate/features/search/domain/repositories/search_repository.dart';

class GetSuggestionsUseCase {
  const GetSuggestionsUseCase(this._repo);

  final SearchRepository _repo;

  Future<List<String>> call(String q) => _repo.getSuggestions(q);
}
