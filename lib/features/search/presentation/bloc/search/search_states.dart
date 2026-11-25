import 'package:equatable/equatable.dart';
import 'package:grocermate/core/error/failure.dart';
import 'package:grocermate/core/utils/enums/view_status.dart';
import 'package:grocermate/features/products/domain/entities/product_entity.dart';

class SearchState extends Equatable {
  const SearchState({
    this.query = '',
    this.categoryId,
    this.brand,
    this.status = ViewStatus.initial,
    this.items = const [],
    this.page = 0,
    this.total = 0,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.loadMoreFailure,
    this.failure,
    this.suggestions = const [],
    this.recents = const [],
    this.fromCache = false,
  });

  static const _keep = Object();

  final String query;
  final String? categoryId;
  final String? brand;
  final ViewStatus status;
  final List<ProductEntity> items;
  final int page;
  final int total;
  final bool hasMore;
  final bool isLoadingMore;
  final Failure? loadMoreFailure;
  final Failure? failure;
  final List<String> suggestions;
  final List<String> recents;
  final bool fromCache;

  bool get isIdle => query.isEmpty && categoryId == null && brand == null;
  int get activeFilters =>
      (categoryId != null ? 1 : 0) + (brand != null ? 1 : 0);

  SearchState copyWith({
    String? query,
    Object? categoryId = _keep,
    Object? brand = _keep,
    ViewStatus? status,
    List<ProductEntity>? items,
    int? page,
    int? total,
    bool? hasMore,
    bool? isLoadingMore,
    Object? loadMoreFailure = _keep,
    Object? failure = _keep,
    List<String>? suggestions,
    List<String>? recents,
    bool? fromCache,
  }) => SearchState(
    query: query ?? this.query,
    categoryId: identical(categoryId, _keep)
        ? this.categoryId
        : categoryId as String?,
    brand: identical(brand, _keep) ? this.brand : brand as String?,
    status: status ?? this.status,
    items: items ?? this.items,
    page: page ?? this.page,
    total: total ?? this.total,
    hasMore: hasMore ?? this.hasMore,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    loadMoreFailure: identical(loadMoreFailure, _keep)
        ? this.loadMoreFailure
        : loadMoreFailure as Failure?,
    failure: identical(failure, _keep) ? this.failure : failure as Failure?,
    suggestions: suggestions ?? this.suggestions,
    recents: recents ?? this.recents,
    fromCache: fromCache ?? this.fromCache,
  );

  @override
  List<Object?> get props => [
    query,
    categoryId,
    brand,
    status,
    items,
    page,
    total,
    hasMore,
    isLoadingMore,
    loadMoreFailure,
    failure,
    suggestions,
    recents,
    fromCache,
  ];
}
