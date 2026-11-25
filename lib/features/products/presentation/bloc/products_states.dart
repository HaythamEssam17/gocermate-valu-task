import 'package:equatable/equatable.dart';
import 'package:grocermate/core/error/failure.dart';
import 'package:grocermate/core/utils/enums/view_status.dart';
import 'package:grocermate/features/products/domain/entities/product_entity.dart';

class ProductsState extends Equatable {
  const ProductsState({
    this.status = ViewStatus.initial,
    this.items = const [],
    this.page = 0,
    this.total = 0,
    this.hasMore = false,
    this.categoryId,
    this.isLoadingMore = false,
    this.isRefreshing = false,
    this.loadMoreFailure,
    this.failure,
    this.fromCache = false,
  });

  static const _keep = Object();

  final ViewStatus status;
  final List<ProductEntity> items;
  final int page;
  final int total;
  final bool hasMore;
  final String? categoryId;
  final bool isLoadingMore;
  final bool isRefreshing;
  final Failure? loadMoreFailure;
  final Failure? failure;
  final bool fromCache;

  ProductsState copyWith({
    ViewStatus? status,
    List<ProductEntity>? items,
    int? page,
    int? total,
    bool? hasMore,
    Object? categoryId = _keep,
    bool? isLoadingMore,
    bool? isRefreshing,
    Object? loadMoreFailure = _keep,
    Object? failure = _keep,
    bool? fromCache,
  }) => ProductsState(
    status: status ?? this.status,
    items: items ?? this.items,
    page: page ?? this.page,
    total: total ?? this.total,
    hasMore: hasMore ?? this.hasMore,
    categoryId: identical(categoryId, _keep)
        ? this.categoryId
        : categoryId as String?,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    isRefreshing: isRefreshing ?? this.isRefreshing,
    loadMoreFailure: identical(loadMoreFailure, _keep)
        ? this.loadMoreFailure
        : loadMoreFailure as Failure?,
    failure: identical(failure, _keep) ? this.failure : failure as Failure?,
    fromCache: fromCache ?? this.fromCache,
  );

  @override
  List<Object?> get props => [
    status,
    items,
    page,
    total,
    hasMore,
    categoryId,
    isLoadingMore,
    isRefreshing,
    loadMoreFailure,
    failure,
    fromCache,
  ];
}
