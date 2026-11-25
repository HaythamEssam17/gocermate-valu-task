import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocermate/core/utils/enums/view_status.dart';
import 'package:grocermate/features/product_details/domain/usecases/get_inventory_usecase.dart';
import 'package:grocermate/features/product_details/domain/usecases/get_price_history_usecase.dart';
import 'package:grocermate/features/product_details/domain/usecases/get_product_details_usecases.dart';
import 'package:grocermate/features/products/domain/usecases/get_products_by_ids_usecase.dart';

import 'product_details_events.dart';
import 'product_details_states.dart';

class ProductDetailsBloc
    extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  ProductDetailsBloc(
    this._getDetails,
    this._getInventory,
    this._getHistory,
    this._getProductsByIds,
  ) : super(const ProductDetailsState()) {
    on<ProductDetailsRequested>(_onRequested);
  }

  final GetProductDetailsUseCase _getDetails;
  final GetInventoryUseCase _getInventory;
  final GetPriceHistoryUseCase _getHistory;
  final GetProductsByIdsUseCase _getProductsByIds;

  Future<void> _onRequested(
    ProductDetailsRequested e,
    Emitter<ProductDetailsState> emit,
  ) async {
    emit(const ProductDetailsState(status: ViewStatus.loading));
    final result = await _getDetails(e.id);
    final loaded = result.valueOrNull;
    if (loaded == null) {
      result.fold(
        (f) =>
            emit(ProductDetailsState(status: ViewStatus.failure, failure: f)),
        (_) {},
      );
      return;
    }
    emit(
      ProductDetailsState(
        status: ViewStatus.success,
        details: loaded.data,
        fromCache: loaded.fromCache,
      ),
    );

    final (inv, hist, rel) = await (
      _getInventory(e.id),
      _getHistory(e.id),
      _getProductsByIds(loaded.data.relatedIds),
    ).wait;

    emit(
      ProductDetailsState(
        status: ViewStatus.success,
        details: loaded.data,
        fromCache: loaded.fromCache,
        inventory: inv.valueOrNull?.data,
        history: hist.valueOrNull?.data,
        related: rel,
      ),
    );
  }
}
