sealed class ProductsEvent {
  const ProductsEvent();
}

class ProductsStarted extends ProductsEvent {
  const ProductsStarted();
}

class ProductsCategorySelected extends ProductsEvent {
  const ProductsCategorySelected(this.categoryId);
  final String? categoryId;
}

class ProductsLoadMore extends ProductsEvent {
  const ProductsLoadMore();
}

class ProductsRetry extends ProductsEvent {
  const ProductsRetry();
}

class ProductsRefreshed extends ProductsEvent {
  const ProductsRefreshed();
}
