import 'package:grocermate/core/network/result.dart';
import 'package:grocermate/features/checkout/domain/entities/purchase_entites/purchase_request.dart';
import 'package:grocermate/features/checkout/domain/entities/purchase_entites/purchase_result.dart';

abstract interface class SyncRepository {
  Future<Result<PurchaseResult>> syncPurchase(PurchaseRequest request);
}
