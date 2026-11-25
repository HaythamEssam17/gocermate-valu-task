import 'package:equatable/equatable.dart';
import 'package:grocermate/features/cart/domain/entities/cart_item.dart';
import 'package:grocermate/features/cart/domain/entities/cart_totals.dart';

class CartState extends Equatable {
  const CartState({
    this.cart = const [],
    this.saved = const [],
    this.totals = CartTotals.empty,
    this.qtyById = const {},
    this.selected = const {},
    this.tabIndex = 0,
    this.loaded = false,
    this.message,
    this.messageId = 0,
  });

  final List<CartItem> cart;
  final List<CartItem> saved;
  final CartTotals totals;
  final Map<String, int> qtyById;
  final Set<String> selected;
  final int tabIndex;
  final bool loaded;
  final String? message;
  final int messageId;

  int qtyOf(String id) => qtyById[id] ?? 0;
  int get cartCount => totals.itemCount;
  bool get selectionMode => selected.isNotEmpty;
  List<CartItem> get activeList => tabIndex == 0 ? cart : saved;

  CartState copyWith({
    List<CartItem>? cart,
    List<CartItem>? saved,
    CartTotals? totals,
    Map<String, int>? qtyById,
    Set<String>? selected,
    int? tabIndex,
    bool? loaded,
    String? message,
    int? messageId,
  }) => CartState(
    cart: cart ?? this.cart,
    saved: saved ?? this.saved,
    totals: totals ?? this.totals,
    qtyById: qtyById ?? this.qtyById,
    selected: selected ?? this.selected,
    tabIndex: tabIndex ?? this.tabIndex,
    loaded: loaded ?? this.loaded,
    message: message ?? this.message,
    messageId: messageId ?? this.messageId,
  );

  @override
  List<Object?> get props => [
    cart,
    saved,
    totals,
    selected,
    tabIndex,
    loaded,
    message,
    messageId,
  ];
}
