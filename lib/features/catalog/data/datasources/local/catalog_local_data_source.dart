import 'package:grocermate/features/products/data/models/product_model.dart';
import 'package:grocermate/features/products/domain/entities/product_entity.dart';
import 'package:grocermate/features/products/domain/entities/products_query.dart';

import '../../../../../core/storage/cache_store.dart';
import '../../../../products/domain/entities/paged_products.dart';

class CatalogLocalDataSource {
  CatalogLocalDataSource(this._cache);
  final CacheStore _cache;

  static const _key = 'index:products';

  Map<String, ProductModel> _read() {
    final data = _cache.get(_key)?.data;
    final result = <String, ProductModel>{};
    if (data is Map) {
      for (final e in data.entries) {
        try {
          result[e.key as String] = ProductModel.fromJson(
            Map<String, dynamic>.from(e.value as Map),
          );
        } catch (_) {
          /* skip corrupted rows */
        }
      }
    }
    return result;
  }

  List<ProductModel> allProducts() => _read().values.toList();

  List<ProductModel> byIds(List<String> ids) {
    final all = _read();
    return [
      for (final id in ids)
        if (all[id] != null) all[id]!,
    ];
  }

  Future<void> upsert(Iterable<ProductEntity> products) async {
    final all = _read();
    for (final p in products) {
      all[p.id] = ProductModel.fromEntity(p);
    }
    await _cache.put(_key, {
      for (final e in all.entries) e.key: e.value.toJson(),
    });
  }

  /// Same semantics as the server: filter, sort by popularity, paginate.
  PagedProducts query(ProductsQuery q) {
    final search = (q.search ?? '').trim().toLowerCase();
    final list =
        allProducts().where((p) {
          if (q.categoryId != null && p.categoryId != q.categoryId) {
            return false;
          }
          if (q.brand != null && p.brand != q.brand) return false;
          if (search.isNotEmpty &&
              !'${p.title} ${p.brand}'.toLowerCase().contains(search)) {
            return false;
          }
          return true;
        }).toList()..sort((a, b) {
          final byRating = b.rating.compareTo(a.rating);
          return byRating != 0 ? byRating : a.id.compareTo(b.id);
        });
    final start = (q.page - 1) * q.pageSize;
    return PagedProducts(
      items: list.skip(start).take(q.pageSize).toList(),
      page: q.page,
      pageSize: q.pageSize,
      total: list.length,
    );
  }

  int get count => _read().length;

  List<String> titles() => allProducts().map((p) => p.title).toList();
}
