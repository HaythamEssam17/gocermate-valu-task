import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocermate/core/utils/enums/network_banner_enum.dart';

import '../network/connectivity_service.dart';
import 'connectivity_states.dart';

class ConnectivityCubit extends Cubit<ConnectivityState> {
  ConnectivityCubit(ConnectivityService service)
    : super(
        ConnectivityState(
          isOnline: service.isOnline,
          banner: service.isOnline ? NetworkBanner.none : NetworkBanner.offline,
        ),
      ) {
    _sub = service.onChanged.listen(_onChanged);
  }

  StreamSubscription<bool>? _sub;
  Timer? _timer;

  void _onChanged(bool online) {
    _timer?.cancel();
    if (!online) {
      emit(
        const ConnectivityState(isOnline: false, banner: NetworkBanner.offline),
      );
      return;
    }
    emit(
      const ConnectivityState(isOnline: true, banner: NetworkBanner.restored),
    );
    _timer = Timer(const Duration(seconds: 3), () {
      if (!isClosed) {
        emit(
          const ConnectivityState(isOnline: true, banner: NetworkBanner.none),
        );
      }
    });
  }

  @override
  Future<void> close() async {
    _timer?.cancel();
    await _sub?.cancel();
    return super.close();
  }
}
