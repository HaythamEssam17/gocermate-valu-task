import 'package:grocermate/features/product_details/domain/entities/price_history.dart';

class PriceHistoryModel extends PriceHistory {
  const PriceHistoryModel(super.productId, super.prices);

  factory PriceHistoryModel.fromJson(Map<String, dynamic> j) =>
      PriceHistoryModel(
        j['productId'] as String,
        (j['history'] as List).map((e) => (e as num).toDouble()).toList(),
      );
}
