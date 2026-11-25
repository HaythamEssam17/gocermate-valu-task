import 'package:grocermate/core/network/api_client.dart';

abstract interface class SearchRemoteDataSource {
  Future<List<String>> suggest(String query);
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  SearchRemoteDataSourceImpl(this._api);

  final ApiClient _api;

  @override
  Future<List<String>> suggest(String query) async {
    final json = Map<String, dynamic>.from(
      await _api.get('/suggest', query: {'q': query}) as Map,
    );
    return (json['suggestions'] as List).cast<String>();
  }
}
