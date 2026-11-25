import 'package:grocermate/core/domain/entities/paginated_result.dart';
import 'package:grocermate/core/network/paginated_result_model.dart';
import 'package:grocermate/features/products/data/models/product_model.dart';

class PagedProductsModel {
  const PagedProductsModel._();

  static PaginatedResult<ProductModel> fromJson(Map<String, dynamic> j) =>
      PaginatedResultModel.fromJson<ProductModel>(j, ProductModel.fromJson);
}
