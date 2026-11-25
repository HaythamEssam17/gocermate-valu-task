abstract class CatalogRemoteDataSource {
  Future<dynamic> getBrands(String? categoryId);

  Future<dynamic> getDealsOfDay();
}
