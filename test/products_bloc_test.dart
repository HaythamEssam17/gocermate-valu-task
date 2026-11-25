import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocermate/core/cache/caching_manager.dart';
import 'package:grocermate/core/error/failure.dart';
import 'package:grocermate/core/network/result.dart';
import 'package:grocermate/core/utils/enums/view_status.dart';
import 'package:grocermate/features/products/domain/entities/paged_products.dart';
import 'package:grocermate/features/products/domain/entities/product_entity.dart';
import 'package:grocermate/features/products/domain/entities/products_query.dart';
import 'package:grocermate/features/products/domain/usecases/get_products_usecase.dart';
import 'package:grocermate/features/products/presentation/bloc/products_bloc.dart';
import 'package:grocermate/features/products/presentation/bloc/products_events.dart';
import 'package:grocermate/features/products/presentation/bloc/products_states.dart';
import 'package:mocktail/mocktail.dart';

class _GetProducts extends Mock implements GetProductsUseCase {}

ProductEntity p(String id) => ProductEntity(
  id: id,
  title: id,
  brand: 'b',
  price: 1,
  originalPrice: 1,
  stock: 3,
  image: '',
  badges: const [],
  categoryId: 'c',
  rating: 4,
);

Result<CachingManager<PagedProducts>> page(
  int n,
  List<ProductEntity> items,
  int total,
) => Success(
  CachingManager(
    PagedProducts(items: items, page: n, pageSize: 2, total: total),
  ),
);

void main() {
  late _GetProducts getProducts;

  setUpAll(() => registerFallbackValue(const ProductsQuery()));
  setUp(() => getProducts = _GetProducts());

  blocTest<ProductsBloc, ProductsState>(
    'loads the first page then appends the next one (pagination)',
    build: () {
      when(() => getProducts(any())).thenAnswer((inv) async {
        final q = inv.positionalArguments.first as ProductsQuery;
        return q.page == 1
            ? page(1, [p('a'), p('b')], 3)
            : page(2, [p('c')], 3);
      });
      return ProductsBloc(getProducts, pageSize: 2);
    },
    act: (bloc) async {
      bloc.add(const ProductsStarted());
      await Future<void>.delayed(const Duration(milliseconds: 20));
      bloc.add(const ProductsLoadMore());
    },
    wait: const Duration(milliseconds: 100),
    verify: (bloc) {
      expect(bloc.state.items.map((e) => e.id), ['a', 'b', 'c']);
      expect(bloc.state.hasMore, false);
      expect(bloc.state.isLoadingMore, false);
    },
  );

  blocTest<ProductsBloc, ProductsState>(
    'first page failure -> failure state, retry recovers',
    build: () {
      var calls = 0;
      when(() => getProducts(any())).thenAnswer((_) async {
        calls++;
        return calls == 1
            ? const Failed(NetworkFailure())
            : page(1, [p('a')], 1);
      });
      return ProductsBloc(getProducts, pageSize: 2);
    },
    act: (bloc) async {
      bloc.add(const ProductsStarted());
      await Future<void>.delayed(const Duration(milliseconds: 20));
      expect(bloc.state.status, ViewStatus.failure);
      bloc.add(const ProductsRetry());
    },
    wait: const Duration(milliseconds: 100),
    verify: (bloc) => expect(bloc.state.status, ViewStatus.success),
  );

  blocTest<ProductsBloc, ProductsState>(
    'load-more failure keeps the items and exposes a retryable error',
    build: () {
      when(() => getProducts(any())).thenAnswer((inv) async {
        final q = inv.positionalArguments.first as ProductsQuery;
        return q.page == 1
            ? page(1, [p('a'), p('b')], 4)
            : const Failed(NetworkFailure());
      });
      return ProductsBloc(getProducts, pageSize: 2);
    },
    act: (bloc) async {
      bloc.add(const ProductsStarted());
      await Future<void>.delayed(const Duration(milliseconds: 20));
      bloc.add(const ProductsLoadMore());
    },
    wait: const Duration(milliseconds: 100),
    verify: (bloc) {
      expect(bloc.state.items.length, 2);
      expect(bloc.state.loadMoreFailure, isNotNull);
      expect(bloc.state.status, ViewStatus.success);
    },
  );
}
