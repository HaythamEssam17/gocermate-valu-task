import 'package:grocermate/core/network/api_client.dart';

import 'cart_remote_data_source.dart';

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  CartRemoteDataSourceImpl(this._api);
  final ApiClient _api;

  @override
  Future<Map<String, int>> stockCheck(List<String> ids) async {
    final json = Map<String, dynamic>.from(
      await _api.get('/stock-check', query: {'ids': ids.join(',')}) as Map,
    );
    return {
      for (final s in (json['stocks'] as List).cast<Map>())
        s['productId'] as String: (s['stock'] as num).toInt(),
    };
  }
}
