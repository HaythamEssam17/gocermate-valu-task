import 'package:equatable/equatable.dart';

class StockIssue extends Equatable {
  const StockIssue({required this.productId, required this.available});
  final String productId;
  final int available;

  @override
  List<Object?> get props => [productId, available];
}
