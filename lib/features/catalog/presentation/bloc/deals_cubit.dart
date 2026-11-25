import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocermate/core/utils/enums/view_status.dart';
import 'package:grocermate/features/catalog/domain/usecases/catalog_usecases.dart';

import 'deals_states.dart';

class DealsCubit extends Cubit<DealsState> {
  DealsCubit(this._getDeals) : super(const DealsState());
  final GetDealsUseCase _getDeals;

  Future<void> load({bool forceRefresh = false}) async {
    if (state.deals.isEmpty) emit(const DealsState(status: ViewStatus.loading));
    final result = await _getDeals(forceRefresh: forceRefresh);
    result.fold(
      (_) => emit(DealsState(status: ViewStatus.failure, deals: state.deals)),
      (v) => emit(DealsState(status: ViewStatus.success, deals: v.data)),
    );
  }
}
