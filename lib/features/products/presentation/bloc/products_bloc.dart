import 'package:dart_bloc_concurrency/dart_bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocermate/core/utils/enums/view_status.dart';
import 'package:grocermate/features/products/domain/entities/products_query.dart';
import 'package:grocermate/features/products/domain/usecases/get_products_usecase.dart';

import 'products_events.dart';
import 'products_states.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  ProductsBloc(this._getProducts, {this.pageSize = 10})
    : super(const ProductsState()) {
    on<ProductsStarted>(
      (e, emit) => _loadFirst(emit, state.categoryId),
      transformer: restartable(),
    );
    on<ProductsCategorySelected>(
      (e, emit) => _loadFirst(emit, e.categoryId),
      transformer: restartable(),
    );
    on<ProductsRetry>(
      (e, emit) => _loadFirst(emit, state.categoryId),
      transformer: restartable(),
    );
    on<ProductsRefreshed>(_onRefreshed, transformer: restartable());
    on<ProductsLoadMore>(_onLoadMore, transformer: droppable());
  }

  final GetProductsUseCase _getProducts;
  final int pageSize;

  Future<void> _loadFirst(
    Emitter<ProductsState> emit,
    String? categoryId,
  ) async {
    emit(ProductsState(status: ViewStatus.loading, categoryId: categoryId));
    final result = await _getProducts(
      ProductsQuery(categoryId: categoryId, pageSize: pageSize),
    );
    result.fold(
      (f) => emit(
        ProductsState(
          status: ViewStatus.failure,
          categoryId: categoryId,
          failure: f,
        ),
      ),
      (v) => emit(
        ProductsState(
          status: ViewStatus.success,
          categoryId: categoryId,
          items: v.data.items,
          page: v.data.page,
          total: v.data.total,
          hasMore: v.data.hasMore,
          fromCache: v.fromCache,
        ),
      ),
    );
  }

  Future<void> _onRefreshed(
    ProductsRefreshed e,
    Emitter<ProductsState> emit,
  ) async {
    if (state.status != ViewStatus.success) {
      return _loadFirst(emit, state.categoryId);
    }
    emit(state.copyWith(isRefreshing: true));
    final category = state.categoryId;
    final result = await _getProducts(
      ProductsQuery(
        categoryId: category,
        pageSize: pageSize,
        forceRefresh: true,
      ),
    );
    result.fold(
      (f) => emit(state.copyWith(isRefreshing: false)),
      (v) => emit(
        ProductsState(
          status: ViewStatus.success,
          categoryId: category,
          items: v.data.items,
          page: v.data.page,
          total: v.data.total,
          hasMore: v.data.hasMore,
          fromCache: v.fromCache,
        ),
      ),
    );
  }

  Future<void> _onLoadMore(
    ProductsLoadMore e,
    Emitter<ProductsState> emit,
  ) async {
    if (state.status != ViewStatus.success ||
        !state.hasMore ||
        state.isLoadingMore) {
      return;
    }
    final category = state.categoryId;
    emit(state.copyWith(isLoadingMore: true, loadMoreFailure: null));
    final result = await _getProducts(
      ProductsQuery(
        categoryId: category,
        page: state.page + 1,
        pageSize: pageSize,
      ),
    );
    if (state.categoryId != category) {
      return; // user switched category meanwhile
    }
    result.fold(
      (f) => emit(state.copyWith(isLoadingMore: false, loadMoreFailure: f)),
      (v) => emit(
        state.copyWith(
          isLoadingMore: false,
          items: [...state.items, ...v.data.items],
          page: v.data.page,
          total: v.data.total,
          hasMore: v.data.hasMore,
        ),
      ),
    );
  }
}
