import 'package:grocermate/core/utils/enums/review_issue_kind.dart';
import 'package:grocermate/core/utils/enums/review_resolution.dart';
import 'package:grocermate/features/cart/domain/entities/cart_item.dart';
import 'package:grocermate/features/cart/domain/entities/cart_item_patch.dart';
import 'package:grocermate/features/order/domain/entities/resolved_order.dart';

import 'purchase_entites/price_change.dart';
import 'purchase_entites/purchase_result.dart';
import 'purchase_entites/stock_issue.dart';
import 'review_entites/review_issue.dart';

class ReviewResolver {
  const ReviewResolver();

  List<ReviewIssue> issuesFor(PurchaseResult result, List<CartItem> items) {
    final byId = {for (final i in items) i.productId: i};
    final priceDiffs = switch (result) {
      PurchasePriceChanged(:final changes) => changes,
      PurchaseReviewRequired(:final priceChanges) => priceChanges,
      _ => const <PriceChange>[],
    };
    final stockIssues = switch (result) {
      PurchaseOutOfStock(:final items) => items,
      PurchaseReviewRequired(:final oos) => oos,
      _ => const <StockIssue>[],
    };

    final issues = <ReviewIssue>[];
    for (final c in priceDiffs) {
      final item = byId[c.productId];
      if (item == null) continue;
      issues.add(
        ReviewIssue(
          productId: c.productId,
          title: item.title,
          image: item.image,
          kind: IssueKind.priceChanged,
          requestedQty: item.qty,
          oldPrice: c.oldPrice,
          newPrice: c.newPrice,
        ),
      );
    }
    for (final s in stockIssues) {
      final item = byId[s.productId];
      if (item == null) continue;
      final gone = s.available <= 0;
      issues.add(
        ReviewIssue(
          productId: s.productId,
          title: item.title,
          image: item.image,
          kind: gone ? IssueKind.outOfStock : IssueKind.limitedStock,
          requestedQty: item.qty,
          available: s.available,
          // An unavailable item can only be removed: pre-select it.
          resolution: gone ? Resolution.remove : Resolution.none,
        ),
      );
    }
    return issues;
  }

  ResolvedOrder apply(List<CartItem> items, List<ReviewIssue> issues) {
    final removed = <String>{};
    final patches = <CartItemPatch>[];
    final out = <CartItem>[];
    for (final item in items) {
      final mine = issues.where((i) => i.productId == item.productId).toList();
      if (mine.any((i) => i.resolution == Resolution.remove)) {
        removed.add(item.productId);
        continue;
      }
      var updated = item;
      for (final i in mine) {
        switch (i.resolution) {
          case Resolution.acceptPrice:
            updated = updated.copyWith(unitPrice: i.newPrice);
          case Resolution.adjustQty:
            updated = updated.copyWith(qty: i.available, stock: i.available);
          case Resolution.remove:
          case Resolution.none:
            break;
        }
      }
      if (updated != item) {
        patches.add(
          CartItemPatch(
            item.productId,
            unitPrice: updated.unitPrice,
            qty: updated.qty,
            stock: updated.stock,
          ),
        );
      }
      out.add(updated);
    }
    return ResolvedOrder(items: out, patches: patches, removedIds: removed);
  }
}
