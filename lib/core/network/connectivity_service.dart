import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

import 'mock_server_config.dart';

class ConnectivityService {
  ConnectivityService(this._connectivity, this._config);

  final Connectivity _connectivity;
  final MockServerConfig _config;
  final _controller = StreamController<bool>.broadcast();
  StreamSubscription<List<ConnectivityResult>>? _sub;

  bool _hasNetwork = true;
  bool _online = true;

  bool get isOnline => _online;
  Stream<bool> get onChanged => _controller.stream;

  Future<void> init() async {
    _hasNetwork = _hasConnection(await _connectivity.checkConnectivity());
    _online = _hasNetwork && !_config.simulateOffline;
    _sub = _connectivity.onConnectivityChanged.listen((results) {
      _hasNetwork = _hasConnection(results);
      _recompute();
    });
    _config.addListener(_recompute);
  }

  bool _hasConnection(List<ConnectivityResult> r) =>
      r.any((e) => e != ConnectivityResult.none);

  void _recompute() {
    final next = _hasNetwork && !_config.simulateOffline;
    if (next == _online) return;
    _online = next;
    _controller.add(next);
  }

  Future<void> dispose() async {
    _config.removeListener(_recompute);
    await _sub?.cancel();
    await _controller.close();
  }
}
