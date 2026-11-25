import 'package:grocermate/features/checkout/data/datasources/checkout_remote_data_source_impl.dart';
import 'package:grocermate/features/checkout/domain/entities/purchase_entites/purchase_request.dart';
import 'package:grocermate/features/checkout/domain/entities/purchase_entites/purchase_result.dart';

import '../../../../core/network/result.dart';
import '../../../../core/utils/guard.dart';
import '../../domain/repositories/checkout_repository.dart';
import '../models/purchase_models.dart';

class CheckoutRepositoryImpl implements CheckoutRepository {
  CheckoutRepositoryImpl(this._remote);
  final CheckoutRemoteDataSource _remote;

  @override
  Future<Result<PurchaseResult>> placeOrder(PurchaseRequest request) =>
      guard(() async {
        final json = await _remote.purchase(
          PurchaseModels.requestToJson(request),
        );
        return PurchaseModels.resultFromJson(
          Map<String, dynamic>.from(json as Map),
        );
      });
}
