import 'package:grocermate/core/error/exceptions.dart';
import 'package:grocermate/core/network/result.dart';
import 'package:grocermate/core/utils/guard.dart';
import 'package:grocermate/features/checkout/data/models/purchase_models.dart';
import 'package:grocermate/features/checkout/domain/entities/purchase_entites/purchase_request.dart';
import 'package:grocermate/features/checkout/domain/entities/purchase_entites/purchase_result.dart';
import 'package:grocermate/features/offline_sync/data/datasources/outbox_local_data_source.dart';
import 'package:grocermate/features/offline_sync/data/datasources/sync_remote_data_source.dart';
import 'package:grocermate/features/offline_sync/domain/repositories/sync_repository.dart';

class SyncRepositoryImpl implements SyncRepository {
  SyncRepositoryImpl(this._remote, this._local);

  final SyncRemoteDataSource _remote;
  final OutboxLocalDataSource _local;

  @override
  Future<Result<PurchaseResult>> syncPurchase(PurchaseRequest request) =>
      guard(() async {
        final json = Map<String, dynamic>.from(
          await _remote.sync({
            'baseVersion': _local.readVersion(),
            'mutations': [
              {
                'op': 'purchase',
                'idempotencyKey': request.idempotencyKey,
                'payload': PurchaseModels.requestToJson(request),
              },
            ],
          }) as Map,
        );
        if (json['status'] != 'ok') {
          throw ApiException(409, 'Sync rejected: ${json['status']}');
        }
        await _local.writeVersion((json['newVersion'] as num).toInt());
        final first = Map<String, dynamic>.from(
          (json['results'] as List).first as Map,
        );
        return PurchaseModels.resultFromJson(
          Map<String, dynamic>.from(first['purchase'] as Map),
        );
      });
}
