abstract interface class ProductDetailsRemoteDataSource {
  Future<dynamic> details(String id);
  Future<dynamic> inventory(String id);
  Future<dynamic> priceHistory(String id);
}
