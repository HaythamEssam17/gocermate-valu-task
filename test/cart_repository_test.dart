import 'package:flutter_test/flutter_test.dart';
import 'package:grocermate/core/network/connectivity_service.dart';
import 'package:grocermate/core/network/result.dart';
import 'package:grocermate/core/storage/json_store.dart';
import 'package:grocermate/features/cart/data/datasources/local/cart_local_data_source.dart';
import 'package:grocermate/features/cart/data/datasources/remote/cart_remote_data_source.dart';
import 'package:grocermate/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:grocermate/features/cart/domain/entities/cart_snapshot.dart';
import 'package:grocermate/features/products/domain/entities/product_entity.dart';
import 'package:mocktail/mocktail.dart';

class _Remote extends Mock implements CartRemoteDataSource {}

class _Connectivity extends Mock implements ConnectivityService {}

ProductEntity product(String id, {int stock = 5, double price = 2.0}) =>
    ProductEntity(
      id: id,
      title: id,
      brand: 'b',
      price: price,
      originalPrice: price,
      stock: stock,
      image: '',
      badges: const [],
      categoryId: 'c',
      rating: 4,
    );

void main() {
  late JsonStore store;
  late CartRepositoryImpl repo;

  setUp(() {
    store = InMemoryJsonStore();
    final connectivity = _Connectivity();
    when(() => connectivity.isOnline).thenReturn(false);
    repo = CartRepositoryImpl(
      CartLocalDataSource(store),
      _Remote(),
      connectivity,
    );
  });

  test('add item updates quantity and emits snapshot', () async {
    final expectFirst = expectLater(
      repo.watch(),
      emits(
        predicate<CartSnapshot>(
          (s) => s.cart.length == 1 && s.cart.single.qty == 2,
        ),
      ),
    );
    expect(await repo.add(product('a'), qty: 2), CartOutcome.added);
    await expectFirst;
  });

  test('add more of existing item merges qty up to stock limit', () async {
    await repo.add(product('a', stock: 5), qty: 3);
    expect(
      await repo.add(product('a', stock: 5), qty: 4),
      CartOutcome.clampedToStock,
    );
    final s = await repo.watch().first;
    expect(s.cart.single.qty, 5);
  });

  test('add item with 0 stock returns outOfStock', () async {
    expect(await repo.add(product('a', stock: 0)), CartOutcome.outOfStock);
    final s = await repo.watch().first;
    expect(s.cart, isEmpty);
  });

  test(
    'setQty to 0 removes the item and cannot exceed stock when increasing',
    () async {
      await repo.add(product('a', stock: 2), qty: 2);
      expect(await repo.setQty('a', 3), CartOutcome.clampedToStock);
      await repo.setQty('a', 0);
      expect((await repo.watch().first).cart, isEmpty);
    },
  );

  test('refreshStock fails with OfflineFailure while offline', () async {
    expect(await repo.refreshStock(), isA<Failed<void>>());
  });
}
