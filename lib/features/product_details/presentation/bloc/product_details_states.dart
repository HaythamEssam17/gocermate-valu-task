import 'package:equatable/equatable.dart';
import 'package:grocermate/core/error/failure.dart';
import 'package:grocermate/core/utils/enums/view_status.dart';
import 'package:grocermate/features/product_details/domain/entities/inventory.dart';
import 'package:grocermate/features/product_details/domain/entities/price_history.dart';
import 'package:grocermate/features/product_details/domain/entities/product_details.dart';
import 'package:grocermate/features/products/domain/entities/product_entity.dart';

class ProductDetailsState extends Equatable {
  const ProductDetailsState({
    this.status = ViewStatus.initial,
    this.details,
    this.inventory,
    this.history,
    this.related = const [],
    this.fromCache = false,
    this.failure,
  });

  final ViewStatus status;
  final ProductDetails? details;
  final Inventory? inventory;
  final PriceHistory? history;
  final List<ProductEntity> related;
  final bool fromCache;
  final Failure? failure;

  @override
  List<Object?> get props => [
    status,
    details,
    inventory,
    history,
    related,
    fromCache,
    failure,
  ];
}
