import 'package:grocermate/core/network/api_client.dart';

abstract interface class SyncRemoteDataSource {
  Future<dynamic> sync(Map<String, dynamic> body);
}

class SyncRemoteDataSourceImpl implements SyncRemoteDataSource {
  SyncRemoteDataSourceImpl(this._api);
  final ApiClient _api;

  @override
  Future<dynamic> sync(Map<String, dynamic> body) =>
      _api.post('/sync', body: body);
}
