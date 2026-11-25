import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocermate/core/utils/enums/view_status.dart';
import 'package:grocermate/features/order/domain/usecases/order_usecase.dart';
import 'package:grocermate/features/products/domain/usecases/get_products_by_ids_usecase.dart';

import 'order_states.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit(this._getOrder, this._getProducts) : super(const OrderState());

  final GetOrderUseCase _getOrder;
  final GetProductsByIdsUseCase _getProducts;

  Future<void> load(String orderId) async {
    emit(const OrderState(status: ViewStatus.loading));
    final result = await _getOrder(orderId);
    final order = result.valueOrNull;
    if (order == null) {
      emit(const OrderState(status: ViewStatus.failure));
      return;
    }
    final products = await _getProducts(
      order.items.map((i) => i.productId).toList(),
    );
    emit(
      OrderState(
        status: ViewStatus.success,
        order: order,
        products: {for (final p in products) p.id: p},
      ),
    );
  }
}
