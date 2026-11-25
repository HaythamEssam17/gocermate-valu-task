import 'package:grocermate/features/checkout/domain/entities/purchase_entites/price_change.dart';
import 'package:grocermate/features/checkout/domain/entities/purchase_entites/purchase_line.dart';
import 'package:grocermate/features/checkout/domain/entities/purchase_entites/purchase_request.dart';
import 'package:grocermate/features/checkout/domain/entities/purchase_entites/purchase_result.dart';
import 'package:grocermate/features/checkout/domain/entities/purchase_entites/stock_issue.dart';

class PurchaseModels {
  const PurchaseModels._();

  static Map<String, dynamic> requestToJson(PurchaseRequest r) => {
    'items': [
      for (final l in r.lines)
        {
          'productId': l.productId,
          'qty': l.qty,
          if (l.expectedPrice != null) 'expectedPrice': l.expectedPrice,
        },
    ],
    'currency': r.currency,
    if (r.idempotencyKey != null) 'idempotencyKey': r.idempotencyKey,
  };

  static List<PriceChange> _changes(dynamic raw) => (raw as List)
      .map((e) => Map<String, dynamic>.from(e as Map))
      .map(
        (e) => PriceChange(
          productId: e['productId'] as String,
          oldPrice: (e['oldPrice'] as num).toDouble(),
          newPrice: (e['newPrice'] as num).toDouble(),
        ),
      )
      .toList();

  static List<StockIssue> _stock(dynamic raw) => (raw as List)
      .map((e) => Map<String, dynamic>.from(e as Map))
      .map(
        (e) => StockIssue(
          productId: e['productId'] as String,
          available: (e['available'] as num).toInt(),
        ),
      )
      .toList();

  static List<PurchaseLine> _lines(dynamic raw) => (raw as List)
      .map((e) => Map<String, dynamic>.from(e as Map))
      .map(
        (e) => PurchaseLine(
          productId: e['productId'] as String,
          qty: (e['qty'] as num).toInt(),
        ),
      )
      .toList();

  static PurchaseResult resultFromJson(Map<String, dynamic> j) {
    switch (j['status']) {
      case 'success':
        return PurchaseSuccess(
          orderId: j['orderId'] as String,
          finalTotal: (j['finalTotal'] as num).toDouble(),
        );
      case 'price_changed':
        return PurchasePriceChanged(_changes(j['changes']));
      case 'out_of_stock':
        return PurchaseOutOfStock(_stock(j['items']));
      case 'partial':
        return PurchasePartial(
          orderId: j['orderId'] as String?,
          fulfilled: _lines(j['fulfilled']),
          missing: _lines(j['missing']),
          note: (j['note'] as String?) ?? '',
        );
      case 'review_required':
        return PurchaseReviewRequired(
          priceChanges: _changes(j['priceChanges'] ?? const []),
          oos: _stock(j['oos'] ?? const []),
        );
      default:
        throw FormatException('Unknown purchase status: ${j['status']}');
    }
  }
}
