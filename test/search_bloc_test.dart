import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocermate/core/cache/caching_manager.dart';
import 'package:grocermate/core/network/result.dart';
import 'package:grocermate/features/products/domain/entities/paged_products.dart';
import 'package:grocermate/features/products/domain/entities/products_query.dart';
import 'package:grocermate/features/products/domain/usecases/get_products_usecase.dart';
import 'package:grocermate/features/search/domain/usecases/clear_recent_searches_usecase.dart';
import 'package:grocermate/features/search/domain/usecases/get_recent_searches_usecase.dart';
import 'package:grocermate/features/search/domain/usecases/get_suggestions_usecases.dart';
import 'package:grocermate/features/search/domain/usecases/save_recent_search_usecase.dart';
import 'package:grocermate/features/search/presentation/bloc/search/search_bloc.dart';
import 'package:grocermate/features/search/presentation/bloc/search/search_events.dart';
import 'package:grocermate/features/search/presentation/bloc/search/search_states.dart';
import 'package:mocktail/mocktail.dart';

class _GetProducts extends Mock implements GetProductsUseCase {}

class _GetSuggestions extends Mock implements GetSuggestionsUseCase {}

class _GetRecents extends Mock implements GetRecentSearchesUseCase {}

class _SaveRecent extends Mock implements SaveRecentSearchUseCase {}

class _ClearRecents extends Mock implements ClearRecentSearchesUseCase {}

void main() {
  late _GetProducts getProducts;

  setUpAll(() => registerFallbackValue(const ProductsQuery()));

  SearchBloc build() {
    getProducts = _GetProducts();
    final suggestions = _GetSuggestions();
    final recents = _GetRecents();
    final save = _SaveRecent();
    when(() => getProducts(any())).thenAnswer(
      (_) async => const Success(
        CachingManager(
          PagedProducts(items: [], page: 1, pageSize: 10, total: 0),
        ),
      ),
    );
    when(() => suggestions(any())).thenAnswer((_) async => <String>[]);
    when(() => recents()).thenReturn(<String>[]);
    when(() => save(any())).thenAnswer((_) async {});
    return SearchBloc(
      getProducts: getProducts,
      getSuggestions: suggestions,
      getRecents: recents,
      saveRecent: save,
      clearRecents: _ClearRecents(),
      debounce: const Duration(milliseconds: 50),
    );
  }

  blocTest<SearchBloc, SearchState>(
    'debounce: fast typing triggers a single search for the last text',
    build: build,
    act: (bloc) async {
      bloc.add(const SearchQueryChanged('a'));
      await Future<void>.delayed(const Duration(milliseconds: 10));
      bloc.add(const SearchQueryChanged('ap'));
      await Future<void>.delayed(const Duration(milliseconds: 10));
      bloc.add(const SearchQueryChanged('app'));
    },
    wait: const Duration(milliseconds: 300),
    verify: (_) {
      final captured = verify(() => getProducts(captureAny())).captured;
      expect(captured.length, 1);
      expect((captured.single as ProductsQuery).search, 'app');
    },
  );

  blocTest<SearchBloc, SearchState>(
    'clearing the text returns to the idle state without searching',
    build: build,
    act: (bloc) => bloc.add(const SearchQueryChanged('', immediate: true)),
    wait: const Duration(milliseconds: 100),
    verify: (bloc) {
      expect(bloc.state.isIdle, true);
      verifyNever(() => getProducts(any()));
    },
  );

  blocTest<SearchBloc, SearchState>(
    'changing a filter re-runs the search immediately with category/brand',
    build: build,
    act: (bloc) => bloc.add(
      const SearchFilterChanged(categoryId: 'c_fruit', brand: 'FreshFarm'),
    ),
    wait: const Duration(milliseconds: 100),
    verify: (bloc) {
      final q =
          verify(() => getProducts(captureAny())).captured.single
              as ProductsQuery;
      expect(q.categoryId, 'c_fruit');
      expect(q.brand, 'FreshFarm');
      expect(bloc.state.activeFilters, 2);
    },
  );
}
