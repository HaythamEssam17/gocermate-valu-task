abstract interface class SearchRepository {
  Future<List<String>> getSuggestions(String query);
  List<String> getRecentSearches();
  Future<void> saveRecentSearch(String query);
  Future<void> clearRecentSearches();
}
