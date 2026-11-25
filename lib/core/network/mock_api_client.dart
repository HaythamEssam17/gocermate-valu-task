import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:grocermate/core/utils/enums/purchase_scenario.dart';
import 'package:grocermate/core/utils/extensions/num_extensions.dart';

import '../error/exceptions.dart';
import '../utils/suggestions.dart';
import 'api_client.dart';
import 'mock_server_config.dart';

class MockApiClient implements ApiClient {
  MockApiClient(this._config, {AssetBundle? bundle, Random? random})
    : _bundle = bundle ?? rootBundle,
      _random = random ?? Random();

  final MockServerConfig _config;
  final AssetBundle _bundle;
  final Random _random;
  Future<void>? _loading;

  late List<Map<String, dynamic>> _categories;
  late List<Map<String, dynamic>> _products;
  late Map<String, dynamic> _brands;
  late Map<String, dynamic> _flags;
  late Map<String, dynamic> _priceHistory;
  late List<Map<String, dynamic>> _dealItems;
  final Map<String, double> _dealPrices = {};

  final Map<String, double> _priceOverrides = {};
  final Map<String, int> _stockOverrides = {};
  final Map<String, Map<String, dynamic>> _orders = {};
  final Map<String, Map<String, dynamic>> _idempotent = {};
  int _orderSeq = 7101;
  int _version = 42;

  void resetState() {
    _priceOverrides.clear();
    _stockOverrides.clear();
    _orders.clear();
    _idempotent.clear();
    _orderSeq = 7101;
    _version = 42;
  }

  @override
  Future<dynamic> get(String path, {Map<String, dynamic>? query}) async {
    await _simulateNetwork();
    await _ensureLoaded();
    return _roundTrip(_handle('GET', path, query ?? const {}, null));
  }

  @override
  Future<dynamic> post(String path, {Object? body}) async {
    await _simulateNetwork();
    await _ensureLoaded();
    return _roundTrip(_handle('POST', path, const {}, body));
  }

  dynamic _roundTrip(dynamic v) => jsonDecode(jsonEncode(v));

  Future<void> _simulateNetwork() async {
    if (_config.simulateOffline) {
      throw const NetworkException('No internet connection (simulated).');
    }
    final span = max(0, _config.maxLatencyMs - _config.minLatencyMs);
    final ms = _config.minLatencyMs + (span == 0 ? 0 : _random.nextInt(span));
    await Future<void>.delayed(Duration(milliseconds: ms));
    if (_config.simulateOffline) {
      throw const NetworkException('Connection lost (simulated).');
    }
    if (_config.failureRate > 0 && _random.nextDouble() < _config.failureRate) {
      throw _random.nextBool()
          ? const NetworkException('Connection lost (simulated).')
          : const ApiException(
              503,
              'Service temporarily unavailable (simulated).',
            );
    }
  }

  Future<void> _ensureLoaded() => _loading ??= _load();

  Future<void> _load() async {
    Future<dynamic> read(String name) async =>
        jsonDecode(await _bundle.loadString('assets/mock/$name.json'));

    _categories = ((await read('categories')) as List)
        .cast<Map<String, dynamic>>();
    _products = ((await read('products')) as List).cast<Map<String, dynamic>>();
    _brands = (await read('brands')) as Map<String, dynamic>;
    _flags = (await read('flags')) as Map<String, dynamic>;
    _priceHistory = (await read('price_history')) as Map<String, dynamic>;
    final deals = (await read('deals')) as Map<String, dynamic>;
    _dealItems = (deals['items'] as List).cast<Map<String, dynamic>>();
    for (final d in _dealItems) {
      _dealPrices[d['productId'] as String] = (d['dealPrice'] as num)
          .toDouble();
    }
  }

  dynamic _handle(
    String method,
    String path,
    Map<String, dynamic> q,
    Object? body,
  ) {
    final segments = Uri.parse(path).pathSegments;
    final route = segments.isEmpty ? '' : segments.first;
    final arg = segments.length > 1 ? segments[1] : null;
    switch ('$method $route') {
      case 'GET categories':
        return _categories;
      case 'GET brands':
        final id = q['categoryId'] as String?;
        return id == null ? _brands : {id: _brands[id] ?? <String>[]};
      case 'GET products':
        return _productsPage(q);
      case 'GET product':
        return _detail(arg);
      case 'GET price-history':
        return _history(arg);
      case 'GET inventory':
        return _inventory(arg);
      case 'GET stock-check':
        return _stockCheck(q);
      case 'GET flags':
        return _flags;
      case 'GET suggest':
        final text = '${q['q'] ?? ''}';
        return {
          'q': text.toLowerCase(),
          'suggestions': buildSearchSuggestions(
            _products.map((p) => p['title'] as String),
            text,
          ),
        };
      case 'GET deals-of-day':
        return _deals();
      case 'GET orders':
        final order = _orders[arg];
        if (order == null) throw const ApiException(404, 'Order not found');
        return order;
      case 'POST purchase':
        return _purchase(Map<String, dynamic>.from(body! as Map));
      case 'POST sync':
        return _sync(Map<String, dynamic>.from(body! as Map));
      default:
        throw ApiException(404, 'No route for $method $path');
    }
  }

  Map<String, dynamic>? _find(String? id) {
    for (final p in _products) {
      if (p['id'] == id) return p;
    }
    return null;
  }

  double _price(Map<String, dynamic> p) =>
      _priceOverrides[p['id']] ??
      _dealPrices[p['id']] ??
      (p['price'] as num).toDouble();

  int _stock(Map<String, dynamic> p) =>
      _stockOverrides[p['id']] ?? (p['stock'] as num).toInt();

  List<String> _badges(Map<String, dynamic> p) {
    final base = (p['badges'] as List)
        .cast<String>()
        .where((b) => b != 'deal' && b != 'oos' && b != 'limited')
        .toList();
    final price = _price(p);
    final stock = _stock(p);
    return [
      if (price < (p['originalPrice'] as num)) 'deal',
      ...base,
      if (stock == 0) 'oos' else if (stock <= 10) 'limited',
    ];
  }

  Map<String, dynamic> _listView(Map<String, dynamic> p) => {
    'id': p['id'],
    'title': p['title'],
    'brand': p['brand'],
    'price': _price(p),
    'originalPrice': p['originalPrice'],
    'stock': _stock(p),
    'image': p['image'],
    'badges': _badges(p),
    'categoryId': p['categoryId'],
    'rating': p['rating'],
  };

  Map<String, dynamic> _detail(String? id) {
    final p = _find(id);
    if (p == null) throw const ApiException(404, 'Product not found');
    return {
      ..._listView(p),
      'images': p['images'],
      'description': p['description'],
      'nutrition': p['nutrition'],
      'allergens': p['allergens'],
      'related': p['related'],
    };
  }

  Map<String, dynamic> _productsPage(Map<String, dynamic> q) {
    final ids = '${q['ids'] ?? ''}'
        .split(',')
        .where((e) => e.isNotEmpty)
        .toSet();
    final category = '${q['category'] ?? ''}';
    final brand = '${q['brand'] ?? ''}';
    final search = '${q['search'] ?? ''}'.trim().toLowerCase();
    final page = max(1, int.tryParse('${q['page']}') ?? 1);
    final size = max(1, int.tryParse('${q['pageSize']}') ?? 10);

    final list =
        _products.where((p) {
          if (ids.isNotEmpty && !ids.contains(p['id'])) return false;
          if (category.isNotEmpty && p['categoryId'] != category) return false;
          if (brand.isNotEmpty && p['brand'] != brand) return false;
          if (search.isNotEmpty) {
            final hay = '${p['title']} ${p['brand']}'.toLowerCase();
            if (!hay.contains(search)) return false;
          }
          return true;
        }).toList()..sort((a, b) {
          final byRating = (b['rating'] as num).compareTo(a['rating'] as num);
          return byRating != 0
              ? byRating
              : (a['id'] as String).compareTo(b['id'] as String);
        });

    return {
      'data': list.skip((page - 1) * size).take(size).map(_listView).toList(),
      'page': page,
      'pageSize': size,
      'total': list.length,
      'sort': 'popularity_desc',
    };
  }

  Map<String, dynamic> _history(String? id) {
    final p = _find(id);
    if (p == null) throw const ApiException(404, 'Product not found');
    final history = ((_priceHistory[id] as List?) ?? [p['price']])
        .map((e) => (e as num).toDouble())
        .toList();
    final current = _price(p);
    if (history.isEmpty || history.last != current) history.add(current);
    return {'productId': id, 'history': history};
  }

  Map<String, dynamic> _inventory(String? id) {
    final p = _find(id);
    if (p == null) throw const ApiException(404, 'Product not found');
    final stock = _stock(p);
    return {
      'productId': id,
      'stock': stock,
      'backorderable': (p['backorderable'] as bool?) ?? false,
      'etaDays': stock == 0 ? 3 : 0,
    };
  }

  Map<String, dynamic> _stockCheck(Map<String, dynamic> q) {
    final ids = '${q['ids'] ?? ''}'.split(',').where((e) => e.isNotEmpty);
    return {
      'stocks': [
        for (final id in ids)
          if (_find(id) != null) {'productId': id, 'stock': _stock(_find(id)!)},
      ],
      'timestamp': DateTime.now().toUtc().toIso8601String(),
    };
  }

  Map<String, dynamic> _deals() {
    final now = DateTime.now();
    return {
      'date': now.toIso8601String().substring(0, 10),
      'items': [
        for (final d in _dealItems)
          {
            'productId': d['productId'],
            'dealPrice': d['dealPrice'],
            'endsAt': now
                .add(Duration(hours: (d['endsInHours'] as num).toInt()))
                .toUtc()
                .toIso8601String(),
          },
      ],
    };
  }

  ({double tax, double delivery, double total}) _totals(double subtotal) {
    final rate = (_flags['taxRate'] as num).toDouble();
    final fee = (_flags['deliveryFee'] as num).toDouble();
    final threshold = (_flags['freeDeliveryThreshold'] as num).toDouble();
    final tax = (subtotal * rate).roundAmountToDouble();
    final delivery = subtotal >= threshold ? 0.0 : fee;
    return (
      tax: tax,
      delivery: delivery,
      total: (subtotal + tax + delivery).roundAmountToDouble(),
    );
  }

  void _bumpPrice(String id, double delta) {
    final p = _find(id);
    if (p == null) return;
    _priceOverrides[id] = max(0.25, (_price(p) + delta).roundAmountToDouble());
  }

  void _applyScenario(PurchaseScenario s, List<Map<String, dynamic>> items) {
    if (items.isEmpty) return;
    final first = items.first['productId'] as String;
    switch (s) {
      case PurchaseScenario.auto:
      case PurchaseScenario.success:
        break;
      case PurchaseScenario.priceChanged:
        _bumpPrice(first, 0.10);
        if (items.length > 1) {
          _bumpPrice(items[1]['productId'] as String, -0.20);
        }
      case PurchaseScenario.outOfStock:
        _stockOverrides[first] = 0;
        for (final it in items.skip(1)) {
          final qty = (it['qty'] as num).toInt();
          if (qty > 1) {
            _stockOverrides[it['productId'] as String] = qty - 1;
            break;
          }
        }
      case PurchaseScenario.partial:
        _stockOverrides[first] = 0;
      case PurchaseScenario.reviewRequired:
        _bumpPrice(first, 0.10);
        if (items.length > 1) {
          _stockOverrides[items[1]['productId'] as String] = 0;
        }
    }
  }

  Map<String, dynamic> _createOrder(List<Map<String, dynamic>> items) {
    final lines = <Map<String, dynamic>>[];
    var subtotal = 0.0;
    for (final it in items) {
      final p = _find(it['productId'] as String)!;
      final qty = (it['qty'] as num).toInt();
      final price = _price(p);
      lines.add({'productId': p['id'], 'qty': qty, 'unitPrice': price});
      subtotal += price * qty;
      _stockOverrides[p['id'] as String] = _stock(p) - qty;
    }
    subtotal = (subtotal).roundAmountToDouble();
    final t = _totals(subtotal);
    final id = 'o_${_orderSeq++}';
    final order = <String, dynamic>{
      'orderId': id,
      'status': 'placed',
      'createdAt': DateTime.now().toUtc().toIso8601String(),
      'currency': _flags['currency'],
      'items': lines,
      'subtotal': subtotal,
      'tax': t.tax,
      'deliveryFee': t.delivery,
      'total': t.total,
    };
    _orders[id] = order;
    return order;
  }

  Map<String, dynamic> _purchase(Map<String, dynamic> body, {String? key}) {
    final idemKey = key ?? body['idempotencyKey'] as String?;
    if (idemKey != null && _idempotent.containsKey(idemKey)) {
      return _idempotent[idemKey]!;
    }

    final items = (body['items'] as List)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
    final scenario = _config.takeScenario();
    _applyScenario(scenario, items);

    final priceChanges = <Map<String, dynamic>>[];
    final oos = <Map<String, dynamic>>[];
    for (final it in items) {
      final id = it['productId'] as String;
      final p = _find(id);
      if (p == null) throw ApiException(404, 'Unknown product $id');
      final qty = (it['qty'] as num).toInt();
      final current = _price(p);
      final expected = it['expectedPrice'] as num?;
      if (expected != null && (expected.toDouble() - current).abs() > 0.0001) {
        priceChanges.add({
          'productId': id,
          'oldPrice': expected,
          'newPrice': current,
        });
      }
      final stock = _stock(p);
      if (stock < qty) oos.add({'productId': id, 'available': stock});
    }

    Map<String, dynamic> response;
    if (priceChanges.isNotEmpty && oos.isNotEmpty) {
      response = {
        'status': 'review_required',
        'priceChanges': priceChanges,
        'oos': oos,
      };
    } else if (priceChanges.isNotEmpty) {
      response = {'status': 'price_changed', 'changes': priceChanges};
    } else if (oos.isNotEmpty) {
      final missingIds = oos.map((o) => o['productId']).toSet();
      final fulfilled = items
          .where((i) => !missingIds.contains(i['productId']))
          .toList();
      if (scenario == PurchaseScenario.partial && fulfilled.isNotEmpty) {
        final order = _createOrder(fulfilled);
        response = {
          'status': 'partial',
          'orderId': order['orderId'],
          'fulfilled': [
            for (final i in fulfilled)
              {'productId': i['productId'], 'qty': i['qty']},
          ],
          'missing': [
            for (final i in items.where(
              (i) => missingIds.contains(i['productId']),
            ))
              {'productId': i['productId'], 'qty': i['qty']},
          ],
          'note': 'You can place the missing item again later.',
        };
      } else {
        response = {'status': 'out_of_stock', 'items': oos};
      }
    } else {
      final order = _createOrder(items);
      response = {
        'status': 'success',
        'orderId': order['orderId'],
        'finalTotal': order['total'],
      };
    }

    final status = response['status'];
    if (idemKey != null && (status == 'success' || status == 'partial')) {
      _idempotent[idemKey] = response;
    }
    return response;
  }

  Map<String, dynamic> _sync(Map<String, dynamic> body) {
    final results = <Map<String, dynamic>>[];
    for (final m in (body['mutations'] as List).cast<Map>()) {
      if (m['op'] == 'purchase') {
        final payload = Map<String, dynamic>.from(m['payload'] as Map);
        final key = m['idempotencyKey'] as String?;
        results.add({
          'idempotencyKey': key,
          'purchase': _purchase(payload, key: key),
        });
      }
    }
    _version++;
    return {'status': 'ok', 'newVersion': _version, 'results': results};
  }
}
