import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocermate/core/utils/enums/view_status.dart';
import 'package:grocermate/features/catalog/domain/usecases/get_brands_usecase.dart';

import 'brands_states.dart';

class BrandsCubit extends Cubit<BrandsState> {
  BrandsCubit(this._getBrands) : super(const BrandsState());
  final GetBrandsUseCase _getBrands;

  Future<void> load(String? categoryId) async {
    emit(const BrandsState(status: ViewStatus.loading));
    final result = await _getBrands(categoryId: categoryId);
    result.fold(
      (_) => emit(const BrandsState(status: ViewStatus.failure)),
      (v) => emit(BrandsState(status: ViewStatus.success, brands: v.data)),
    );
  }
}
