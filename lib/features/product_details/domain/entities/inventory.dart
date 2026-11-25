import 'package:equatable/equatable.dart';

class Inventory extends Equatable {
  const Inventory({
    required this.productId,
    required this.stock,
    required this.backorderable,
    required this.etaDays,
  });

  final String productId;
  final int stock;
  final bool backorderable;
  final int etaDays;

  @override
  List<Object?> get props => [productId, stock, backorderable, etaDays];
}
