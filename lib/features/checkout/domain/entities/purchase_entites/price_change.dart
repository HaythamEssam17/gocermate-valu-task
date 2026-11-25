import 'package:equatable/equatable.dart';

class PriceChange extends Equatable {
  const PriceChange({
    required this.productId,
    required this.oldPrice,
    required this.newPrice,
  });
  final String productId;
  final double oldPrice;
  final double newPrice;

  @override
  List<Object?> get props => [productId, oldPrice, newPrice];
}
