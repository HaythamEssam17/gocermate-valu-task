import 'package:grocermate/features/checkout/domain/entities/purchase_entites/purchase_request.dart';
import 'package:grocermate/features/checkout/domain/entities/purchase_entites/purchase_result.dart';

import '../../../../core/network/result.dart';

abstract interface class CheckoutRepository {
  Future<Result<PurchaseResult>> placeOrder(PurchaseRequest request);
}
