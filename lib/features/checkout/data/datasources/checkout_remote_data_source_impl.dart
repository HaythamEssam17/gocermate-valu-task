abstract interface class CheckoutRemoteDataSource {
  Future<dynamic> purchase(Map<String, dynamic> body);
}
