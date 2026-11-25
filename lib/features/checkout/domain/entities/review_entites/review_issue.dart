import 'package:equatable/equatable.dart';
import 'package:grocermate/core/utils/enums/review_issue_kind.dart';
import 'package:grocermate/core/utils/enums/review_resolution.dart';

class ReviewIssue extends Equatable {
  const ReviewIssue({
    required this.productId,
    required this.title,
    required this.image,
    required this.kind,
    required this.requestedQty,
    this.oldPrice,
    this.newPrice,
    this.available,
    this.resolution = Resolution.none,
  });

  final String productId;
  final String title;
  final String image;
  final IssueKind kind;
  final int requestedQty;
  final double? oldPrice;
  final double? newPrice;
  final int? available;
  final Resolution resolution;

  String get key => '$productId:${kind.name}';
  bool get isResolved => resolution != Resolution.none;

  List<Resolution> get options => switch (kind) {
    IssueKind.priceChanged => const [Resolution.acceptPrice, Resolution.remove],
    IssueKind.outOfStock => const [Resolution.remove],
    IssueKind.limitedStock => const [Resolution.adjustQty, Resolution.remove],
  };

  ReviewIssue withResolution(Resolution r) => ReviewIssue(
    productId: productId,
    title: title,
    image: image,
    kind: kind,
    requestedQty: requestedQty,
    oldPrice: oldPrice,
    newPrice: newPrice,
    available: available,
    resolution: r,
  );

  @override
  List<Object?> get props => [
    productId,
    title,
    image,
    kind,
    requestedQty,
    oldPrice,
    newPrice,
    available,
    resolution,
  ];
}
