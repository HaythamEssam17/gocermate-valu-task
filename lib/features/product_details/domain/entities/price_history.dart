import 'package:equatable/equatable.dart';

class PriceHistory extends Equatable {
  const PriceHistory(this.productId, this.prices);
  final String productId;
  final List<double> prices;

  @override
  List<Object?> get props => [productId, prices];
}
