import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocermate/core/utils/enums/view_status.dart';
import 'package:grocermate/features/category/domain/usecases/get_categories_usecase.dart';

import 'category_event.dart';
import 'category_states.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  CategoriesBloc(this._getCategories) : super(const CategoriesState()) {
    on<CategoriesRequested>(_onRequested);
  }

  final GetCategoriesUseCase _getCategories;

  Future<void> _onRequested(
    CategoriesRequested e,
    Emitter<CategoriesState> emit,
  ) async {
    if (state.categories.isEmpty) {
      emit(const CategoriesState(status: ViewStatus.loading));
    }
    final result = await _getCategories(forceRefresh: e.forceRefresh);
    result.fold(
      (f) {
        if (state.categories.isEmpty) {
          emit(CategoriesState(status: ViewStatus.failure, failure: f));
        }
      },
      (v) =>
          emit(CategoriesState(status: ViewStatus.success, categories: v.data)),
    );
  }
}
