sealed class SearchEvent {
  const SearchEvent();
}

class SearchStarted extends SearchEvent {
  const SearchStarted();
}

class SearchQueryChanged extends SearchEvent {
  const SearchQueryChanged(this.query, {this.immediate = false});
  final String query;
  final bool immediate;
}

class SearchFilterChanged extends SearchEvent {
  const SearchFilterChanged({this.categoryId, this.brand});
  final String? categoryId;
  final String? brand;
}

class SearchLoadMore extends SearchEvent {
  const SearchLoadMore();
}

class SearchRetry extends SearchEvent {
  const SearchRetry();
}

class SearchRecentsCleared extends SearchEvent {
  const SearchRecentsCleared();
}
