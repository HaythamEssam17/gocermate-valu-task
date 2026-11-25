import 'package:flutter_test/flutter_test.dart';
import 'package:grocermate/core/utils/enums/review_issue_kind.dart';
import 'package:grocermate/core/utils/enums/review_resolution.dart';
import 'package:grocermate/features/cart/domain/entities/cart_item.dart';
import 'package:grocermate/features/checkout/domain/entities/purchase_entites/price_change.dart';
import 'package:grocermate/features/checkout/domain/entities/purchase_entites/purchase_result.dart';
import 'package:grocermate/features/checkout/domain/entities/purchase_entites/stock_issue.dart';
import 'package:grocermate/features/checkout/domain/entities/review_resolver.dart';

CartItem item(String id, double price, int qty) => CartItem(
  productId: id,
  title: id,
  brand: 'b',
  image: '',
  categoryId: 'c',
  unitPrice: price,
  originalPrice: price,
  stock: 10,
  qty: qty,
);

void main() {
  const resolver = ReviewResolver();
  final items = [
    item('milk', 1.29, 2),
    item('apple', 2.49, 1),
    item('bread', 2.79, 1),
  ];

  test('mixed result produces price + stock issues; unavailable item is pre-selected for removal', () {
    final issues = resolver.issuesFor(
      const PurchaseReviewRequired(
        priceChanges: [
          PriceChange(productId: 'milk', oldPrice: 1.29, newPrice: 1.39),
        ],
        oos: [StockIssue(productId: 'bread', available: 0)],
      ),
      items,
    );
    expect(issues.length, 2);
    expect(issues.first.kind, IssueKind.priceChanged);
    expect(issues.first.isResolved, false);
    expect(issues.last.kind, IssueKind.outOfStock);
    expect(issues.last.resolution, Resolution.remove);
  });

  test(
    'partial stock becomes a limitedStock issue with adjust/remove options',
    () {
      final issues = resolver.issuesFor(
        const PurchaseOutOfStock([StockIssue(productId: 'milk', available: 1)]),
        items,
      );
      expect(issues.single.kind, IssueKind.limitedStock);
      expect(issues.single.options, [Resolution.adjustQty, Resolution.remove]);
    },
  );

  test('apply: accepts new price, adjusts qty, removes items and emits cart patches', () {
    var issues = resolver.issuesFor(
      const PurchaseReviewRequired(
        priceChanges: [
          PriceChange(productId: 'milk', oldPrice: 1.29, newPrice: 1.39),
        ],
        oos: [
          StockIssue(productId: 'apple', available: 0),
          StockIssue(productId: 'bread', available: 0),
        ],
      ),
      items,
    );
    issues = [
      for (final i in issues)
        i.kind == IssueKind.priceChanged
            ? i.withResolution(Resolution.acceptPrice)
            : i,
    ];

    final resolved = resolver.apply(items, issues);

    expect(resolved.removedIds, {'apple', 'bread'});
    expect(resolved.items.single.productId, 'milk');
    expect(resolved.items.single.unitPrice, 1.39);
    expect(resolved.patches.single.unitPrice, 1.39);
  });

  test('apply: adjustQty lowers the quantity to what is available', () {
    var issues = resolver.issuesFor(
      const PurchaseOutOfStock([StockIssue(productId: 'milk', available: 1)]),
      items,
    );
    issues = [issues.single.withResolution(Resolution.adjustQty)];
    final resolved = resolver.apply(items, issues);
    expect(resolved.items.firstWhere((i) => i.productId == 'milk').qty, 1);
  });
}
