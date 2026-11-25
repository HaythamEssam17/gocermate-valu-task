import 'package:equatable/equatable.dart';
import 'package:grocermate/features/products/domain/entities/product_entity.dart';

class ProductDetails extends Equatable {
  const ProductDetails({
    required this.product,
    required this.images,
    required this.description,
    required this.nutrition,
    required this.allergens,
    required this.relatedIds,
  });

  final ProductEntity product;
  final List<String> images;
  final String description;
  final Map<String, num> nutrition;
  final List<String> allergens;
  final List<String> relatedIds;

  @override
  List<Object?> get props => [
    product,
    images,
    description,
    nutrition,
    allergens,
    relatedIds,
  ];
}
