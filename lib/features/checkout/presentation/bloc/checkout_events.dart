import 'package:grocermate/core/utils/enums/review_resolution.dart';
import 'package:grocermate/features/cart/domain/entities/cart_item.dart';

sealed class CheckoutEvent {
  const CheckoutEvent();
}

class CheckoutPlaceRequested extends CheckoutEvent {
  const CheckoutPlaceRequested(this.items, {this.outboxEntryId});
  final List<CartItem> items;
  final String? outboxEntryId;
}

class CheckoutIssueResolved extends CheckoutEvent {
  const CheckoutIssueResolved(this.issueKey, this.resolution);
  final String issueKey;
  final Resolution resolution;
}

class CheckoutResubmitted extends CheckoutEvent {
  const CheckoutResubmitted();
}

class CheckoutReviewDismissed extends CheckoutEvent {
  const CheckoutReviewDismissed();
}
