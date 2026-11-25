import 'package:equatable/equatable.dart';
import 'package:grocermate/core/error/failure.dart';
import 'package:grocermate/core/utils/enums/check_out_status.dart';
import 'package:grocermate/features/cart/domain/entities/cart_item.dart';
import 'package:grocermate/features/checkout/domain/entities/review_entites/review_issue.dart';

class CheckoutState extends Equatable {
  const CheckoutState({
    this.status = CheckoutStatus.idle,
    this.items = const [],
    this.issues = const [],
    this.orderId,
    this.total,
    this.missing = const [],
    this.failure,
    this.outboxEntryId,
    this.idempotencyKey,
  });

  static const _keep = Object();

  final CheckoutStatus status;
  final List<CartItem> items;
  final List<ReviewIssue> issues;
  final String? orderId;
  final double? total;
  final List<CartItem> missing;
  final Failure? failure;
  final String? outboxEntryId;
  final String? idempotencyKey;

  bool get allResolved => issues.every((i) => i.isResolved);

  CheckoutState copyWith({
    CheckoutStatus? status,
    List<CartItem>? items,
    List<ReviewIssue>? issues,
    String? orderId,
    double? total,
    List<CartItem>? missing,
    Object? failure = _keep,
    String? outboxEntryId,
    String? idempotencyKey,
  }) => CheckoutState(
    status: status ?? this.status,
    items: items ?? this.items,
    issues: issues ?? this.issues,
    orderId: orderId ?? this.orderId,
    total: total ?? this.total,
    missing: missing ?? this.missing,
    failure: identical(failure, _keep) ? this.failure : failure as Failure?,
    outboxEntryId: outboxEntryId ?? this.outboxEntryId,
    idempotencyKey: idempotencyKey ?? this.idempotencyKey,
  );

  @override
  List<Object?> get props => [
    status,
    items,
    issues,
    orderId,
    total,
    missing,
    failure,
    outboxEntryId,
    idempotencyKey,
  ];
}
