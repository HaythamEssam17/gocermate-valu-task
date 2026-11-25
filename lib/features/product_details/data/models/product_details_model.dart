import 'package:grocermate/features/product_details/domain/entities/product_details.dart';
import 'package:grocermate/features/products/data/models/product_model.dart';

class ProductDetailsModel extends ProductDetails {
  const ProductDetailsModel({
    required super.product,
    required super.images,
    required super.description,
    required super.nutrition,
    required super.allergens,
    required super.relatedIds,
  });

  factory ProductDetailsModel.fromJson(Map<String, dynamic> j) =>
      ProductDetailsModel(
        product: ProductModel.fromJson(j),
        images:
            (j['images'] as List?)?.cast<String>() ??
            [j['image'] as String? ?? ''],
        description: (j['description'] as String?) ?? '',
        nutrition: {
          for (final e in Map<String, dynamic>.from(
            (j['nutrition'] as Map?) ?? const {},
          ).entries)
            e.key: e.value as num,
        },
        allergens: (j['allergens'] as List?)?.cast<String>() ?? const [],
        relatedIds: (j['related'] as List?)?.cast<String>() ?? const [],
      );
}
