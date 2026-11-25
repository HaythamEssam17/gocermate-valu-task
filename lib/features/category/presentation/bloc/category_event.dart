sealed class CategoriesEvent {
  const CategoriesEvent();
}

class CategoriesRequested extends CategoriesEvent {
  const CategoriesRequested({this.forceRefresh = false});
  final bool forceRefresh;
}
