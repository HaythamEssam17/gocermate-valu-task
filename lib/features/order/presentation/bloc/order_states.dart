import 'package:equatable/equatable.dart';
import 'package:grocermate/core/utils/enums/view_status.dart';
import 'package:grocermate/features/order/domain/entities/order_summary.dart';
import 'package:grocermate/features/products/domain/entities/product_entity.dart';

class OrderState extends Equatable {
  const OrderState({
    this.status = ViewStatus.initial,
    this.order,
    this.products = const {},
  });

  final ViewStatus status;
  final OrderSummary? order;
  final Map<String, ProductEntity> products;

  @override
  List<Object?> get props => [status, order, products];
}
