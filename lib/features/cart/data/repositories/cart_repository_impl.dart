import 'dart:async';
import 'dart:math' as math;

import 'package:grocermate/core/error/failure.dart';
import 'package:grocermate/core/network/connectivity_service.dart';
import 'package:grocermate/core/network/result.dart';
import 'package:grocermate/core/utils/guard.dart';
import 'package:grocermate/features/cart/data/datasources/local/cart_local_data_source.dart';
import 'package:grocermate/features/cart/data/datasources/remote/cart_remote_data_source.dart';
import 'package:grocermate/features/cart/domain/entities/cart_item.dart';
import 'package:grocermate/features/cart/domain/entities/cart_item_patch.dart';
import 'package:grocermate/features/cart/domain/entities/cart_snapshot.dart';
import 'package:grocermate/features/cart/domain/repositories/cart_repository.dart';
import 'package:grocermate/features/products/domain/entities/product_entity.dart';

class CartRepositoryImpl implements CartRepository {
  CartRepositoryImpl(this._local, this._remote, this._connectivity) {
    _snapshot = _local.read();
  }

  final CartLocalDataSource _local;
  final CartRemoteDataSource _remote;
  final ConnectivityService _connectivity;
  final _controller = StreamController<CartSnapshot>.broadcast();
  late CartSnapshot _snapshot;

  @override
  Stream<CartSnapshot> watch() async* {
    yield _snapshot;
    yield* _controller.stream;
  }

  Future<void> _commit(CartSnapshot next) async {
    _snapshot = next;
    _controller.add(next);
    await _local.write(next);
  }

  List<CartItem> _merge(List<CartItem> list, CartItem item) {
    final out = [...list];
    final i = out.indexWhere((e) => e.productId == item.productId);
    if (i < 0) {
      out.add(item);
    } else {
      final max = item.stock > 0 ? item.stock : out[i].qty + item.qty;
      out[i] = out[i].copyWith(
        qty: math.min(out[i].qty + item.qty, max),
        stock: item.stock,
        unitPrice: item.unitPrice,
        originalPrice: item.originalPrice,
      );
    }
    return out;
  }

  @override
  Future<CartOutcome> add(ProductEntity product, {int qty = 1}) async {
    if (product.isOutOfStock) return CartOutcome.outOfStock;
    final existing = _snapshot.cart
        .where((e) => e.productId == product.id)
        .firstOrNull;
    final wanted = (existing?.qty ?? 0) + qty;
    final clamped = wanted > product.stock;
    final item = CartItem.fromProduct(
      product,
      qty: math.min(qty, product.stock),
    );
    final cart = existing == null
        ? [..._snapshot.cart, item]
        : _snapshot.cart
              .map(
                (e) => e.productId == product.id
                    ? e.copyWith(
                        qty: math.min(wanted, product.stock),
                        stock: product.stock,
                        unitPrice: product.price,
                        originalPrice: product.originalPrice,
                      )
                    : e,
              )
              .toList();
    await _commit(CartSnapshot(cart: cart, saved: _snapshot.saved));
    return clamped ? CartOutcome.clampedToStock : CartOutcome.added;
  }

  @override
  Future<CartOutcome> setQty(String productId, int qty) async {
    final item = _snapshot.cart
        .where((e) => e.productId == productId)
        .firstOrNull;
    if (item == null) return CartOutcome.added;
    if (qty <= 0) {
      await remove({productId});
      return CartOutcome.added;
    }
    if (qty > item.qty && qty > item.stock) return CartOutcome.clampedToStock;
    final cart = _snapshot.cart
        .map((e) => e.productId == productId ? e.copyWith(qty: qty) : e)
        .toList();
    await _commit(CartSnapshot(cart: cart, saved: _snapshot.saved));
    return CartOutcome.added;
  }

  @override
  Future<void> remove(Set<String> ids, {bool fromSaved = false}) {
    bool keep(CartItem i) => !ids.contains(i.productId);
    return _commit(
      fromSaved
          ? CartSnapshot(
              cart: _snapshot.cart,
              saved: _snapshot.saved.where(keep).toList(),
            )
          : CartSnapshot(
              cart: _snapshot.cart.where(keep).toList(),
              saved: _snapshot.saved,
            ),
    );
  }

  @override
  Future<void> move(Set<String> ids, {required bool toSaved}) {
    final from = toSaved ? _snapshot.cart : _snapshot.saved;
    var to = toSaved ? _snapshot.saved : _snapshot.cart;
    final moving = from.where((i) => ids.contains(i.productId)).toList();
    if (moving.isEmpty) return Future.value();
    for (final item in moving) {
      to = _merge(to, item);
    }
    final rest = from.where((i) => !ids.contains(i.productId)).toList();
    return _commit(
      toSaved
          ? CartSnapshot(cart: rest, saved: to)
          : CartSnapshot(cart: to, saved: rest),
    );
  }

  @override
  Future<void> applyPatches(List<CartItemPatch> patches) {
    if (patches.isEmpty) return Future.value();
    final byId = {for (final p in patches) p.productId: p};
    CartItem apply(CartItem i) {
      final p = byId[i.productId];
      return p == null
          ? i
          : i.copyWith(unitPrice: p.unitPrice, stock: p.stock, qty: p.qty);
    }

    return _commit(
      CartSnapshot(
        cart: _snapshot.cart.map(apply).toList(),
        saved: _snapshot.saved.map(apply).toList(),
      ),
    );
  }

  @override
  Future<void> restore(List<CartItem> items) {
    var cart = _snapshot.cart;
    for (final i in items) {
      cart = _merge(cart, i);
    }
    return _commit(CartSnapshot(cart: cart, saved: _snapshot.saved));
  }

  @override
  Future<Result<void>> refreshStock() async {
    if (!_connectivity.isOnline) return const Failed<void>(OfflineFailure());
    final ids = {
      ..._snapshot.cart,
      ..._snapshot.saved,
    }.map((e) => e.productId).toSet();
    if (ids.isEmpty) return const Success(null);
    return guard(() async {
      final stocks = await _remote.stockCheck(ids.toList());
      await applyPatches([
        for (final e in stocks.entries) CartItemPatch(e.key, stock: e.value),
      ]);
    });
  }
}
