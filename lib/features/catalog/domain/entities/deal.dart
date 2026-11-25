import 'package:equatable/equatable.dart';
import 'package:grocermate/features/products/domain/entities/product_entity.dart';

class DealEntity extends Equatable {
  const DealEntity({
    required this.product,
    required this.dealPrice,
    required this.endsAt,
  });

  final ProductEntity product;
  final double dealPrice;
  final DateTime endsAt;

  ProductEntity get dealProduct => product.copyWith(price: dealPrice);

  @override
  List<Object?> get props => [product, dealPrice, endsAt];
}
