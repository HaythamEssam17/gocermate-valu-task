import 'package:equatable/equatable.dart';

class ProductsQuery extends Equatable {
  const ProductsQuery({
    this.categoryId,
    this.search,
    this.brand,
    this.page = 1,
    this.pageSize = 10,
    this.forceRefresh = false,
  });

  final String? categoryId;
  final String? search;
  final String? brand;
  final int page;
  final int pageSize;
  final bool forceRefresh;

  ProductsQuery copyWith({int? page, bool? forceRefresh}) => ProductsQuery(
    categoryId: categoryId,
    search: search,
    brand: brand,
    page: page ?? this.page,
    pageSize: pageSize,
    forceRefresh: forceRefresh ?? this.forceRefresh,
  );

  @override
  List<Object?> get props => [
    categoryId,
    search,
    brand,
    page,
    pageSize,
    forceRefresh,
  ];
}
