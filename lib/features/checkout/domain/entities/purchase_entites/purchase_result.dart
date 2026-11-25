import 'price_change.dart';
import 'purchase_line.dart';
import 'stock_issue.dart';

sealed class PurchaseResult {
  const PurchaseResult();
}

final class PurchaseSuccess extends PurchaseResult {
  const PurchaseSuccess({required this.orderId, required this.finalTotal});
  final String orderId;
  final double finalTotal;
}

final class PurchasePriceChanged extends PurchaseResult {
  const PurchasePriceChanged(this.changes);
  final List<PriceChange> changes;
}

final class PurchaseOutOfStock extends PurchaseResult {
  const PurchaseOutOfStock(this.items);
  final List<StockIssue> items;
}

final class PurchasePartial extends PurchaseResult {
  const PurchasePartial({
    required this.orderId,
    required this.fulfilled,
    required this.missing,
    required this.note,
  });
  final String? orderId;
  final List<PurchaseLine> fulfilled;
  final List<PurchaseLine> missing;
  final String note;
}

final class PurchaseReviewRequired extends PurchaseResult {
  const PurchaseReviewRequired({required this.priceChanges, required this.oos});
  final List<PriceChange> priceChanges;
  final List<StockIssue> oos;
}
