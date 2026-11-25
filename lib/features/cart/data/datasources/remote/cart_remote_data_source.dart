abstract interface class CartRemoteDataSource {
  Future<Map<String, int>> stockCheck(List<String> ids);
}
