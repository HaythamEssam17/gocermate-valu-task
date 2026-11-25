sealed class ProductDetailsEvent {
  const ProductDetailsEvent();
}

class ProductDetailsRequested extends ProductDetailsEvent {
  const ProductDetailsRequested(this.id);
  final String id;
}
