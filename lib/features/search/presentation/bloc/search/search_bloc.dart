import 'dart:async';

import 'package:dart_bloc_concurrency/dart_bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocermate/core/utils/enums/view_status.dart';
import 'package:grocermate/features/products/domain/entities/products_query.dart';
import 'package:grocermate/features/products/domain/usecases/get_products_usecase.dart';
import 'package:grocermate/features/search/domain/usecases/clear_recent_searches_usecase.dart';
import 'package:grocermate/features/search/domain/usecases/get_recent_searches_usecase.dart';
import 'package:grocermate/features/search/domain/usecases/get_suggestions_usecases.dart';
import 'package:grocermate/features/search/domain/usecases/save_recent_search_usecase.dart';

import 'search_events.dart';
import 'search_states.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({
    required this._getProducts,
    required this._getSuggestions,
    required this._getRecents,
    required this._saveRecent,
    required this._clearRecents,
    required this._debounce,
    this._pageSize = 10,
  }) : super(const SearchState()) {
    on<SearchStarted>(
      (e, emit) => emit(state.copyWith(recents: _getRecents())),
    );
    on<SearchQueryChanged>(_onQuery, transformer: restartable());
    on<SearchFilterChanged>((e, emit) {
      emit(state.copyWith(categoryId: e.categoryId, brand: e.brand));
      add(SearchQueryChanged(state.query, immediate: true));
    });
    on<SearchRetry>(
      (e, emit) => add(SearchQueryChanged(state.query, immediate: true)),
    );
    on<SearchLoadMore>(_onLoadMore, transformer: droppable());
    on<SearchRecentsCleared>((e, emit) async {
      await _clearRecents();
      emit(state.copyWith(recents: const []));
    });
  }

  final GetProductsUseCase _getProducts;
  final GetSuggestionsUseCase _getSuggestions;
  final GetRecentSearchesUseCase _getRecents;
  final SaveRecentSearchUseCase _saveRecent;
  final ClearRecentSearchesUseCase _clearRecents;
  final Duration _debounce;
  final int _pageSize;

  ProductsQuery _query(int page) => ProductsQuery(
    search: state.query,
    categoryId: state.categoryId,
    brand: state.brand,
    page: page,
    pageSize: _pageSize,
  );

  Future<void> _onQuery(SearchQueryChanged e, Emitter<SearchState> emit) async {
    final q = e.query.trim();
    emit(state.copyWith(query: q));

    if (state.isIdle) {
      emit(
        state.copyWith(
          status: ViewStatus.initial,
          items: const [],
          suggestions: const [],
          hasMore: false,
          failure: null,
          recents: _getRecents(),
        ),
      );
      return;
    }

    if (!e.immediate) await Future<void>.delayed(_debounce);
    if (e.immediate && q.isNotEmpty) {
      await _saveRecent(q);
      emit(state.copyWith(recents: _getRecents()));
    }

    emit(
      state.copyWith(
        status: ViewStatus.loading,
        items: const [],
        page: 0,
        hasMore: false,
        isLoadingMore: false,
        failure: null,
        loadMoreFailure: null,
      ),
    );

    final suggestionsFuture = q.isEmpty
        ? Future.value(<String>[])
        : _getSuggestions(q);
    final resultFuture = _getProducts(_query(1));

    final suggestions = await suggestionsFuture;
    emit(state.copyWith(suggestions: suggestions));

    final result = await resultFuture;
    result.fold(
      (f) => emit(state.copyWith(status: ViewStatus.failure, failure: f)),
      (v) => emit(
        state.copyWith(
          status: ViewStatus.success,
          items: v.data.items,
          page: v.data.page,
          total: v.data.total,
          hasMore: v.data.hasMore,
          fromCache: v.fromCache,
        ),
      ),
    );
  }

  Future<void> _onLoadMore(SearchLoadMore e, Emitter<SearchState> emit) async {
    if (state.status != ViewStatus.success ||
        !state.hasMore ||
        state.isLoadingMore) {
      return;
    }
    final snapshotQuery = state.query;
    emit(state.copyWith(isLoadingMore: true, loadMoreFailure: null));
    final result = await _getProducts(_query(state.page + 1));
    if (state.query != snapshotQuery) return;
    result.fold(
      (f) => emit(state.copyWith(isLoadingMore: false, loadMoreFailure: f)),
      (v) => emit(
        state.copyWith(
          isLoadingMore: false,
          items: [...state.items, ...v.data.items],
          page: v.data.page,
          hasMore: v.data.hasMore,
          total: v.data.total,
        ),
      ),
    );
  }
}
