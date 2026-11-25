import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:grocermate/core/localization/cubit/locale_cubit.dart';
import 'package:grocermate/core/theme/cubit/theme_cubit.dart';
import 'package:grocermate/features/cart/presentation/bloc/cart_events.dart';
import 'package:grocermate/features/category/di/category_module.dart';
import 'package:grocermate/features/offline_sync/service/sync_manager.dart';
import 'package:grocermate/features/order/di/order_module.dart';
import 'package:grocermate/features/products/di/products_module.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../features/cart/di/cart_module.dart';
import '../../features/cart/presentation/bloc/cart_bloc.dart';
import '../../features/catalog/di/catalog_module.dart';
import '../../features/checkout/di/checkout_module.dart';
import '../../features/offline_sync/di/offline_sync_module.dart';
import '../../features/offline_sync/presentation/bloc/outbox_cubit.dart';
import '../../features/product_details/di/product_details_module.dart';
import '../../features/search/di/search_module.dart';
import '../cache/caching_fetcher.dart';
import '../config/flags_repository.dart';
import '../connectivity/connectivity_cubit.dart';
import '../network/api_client.dart';
import '../network/connectivity_service.dart';
import '../network/mock_api_client.dart';
import '../network/mock_server_config.dart';
import '../router/shell_tab_controller.dart';
import '../storage/cache_store.dart';
import '../storage/json_store.dart';

final GetIt sl = GetIt.instance;

Future<void> configureDependencies() async {
  await Hive.initFlutter();
  final cacheBox = await Hive.openBox<String>('cache');
  final userBox = await Hive.openBox<String>('user');

  final config = MockServerConfig();
  final connectivity = ConnectivityService(Connectivity(), config);
  await connectivity.init();

  sl
    ..registerSingleton<MockServerConfig>(config)
    ..registerSingleton<JsonStore>(
      HiveJsonStore(cacheBox),
      instanceName: 'cache',
    )
    ..registerSingleton<JsonStore>(HiveJsonStore(userBox), instanceName: 'user')
    ..registerSingleton<ConnectivityService>(connectivity)
    ..registerSingleton<CacheStore>(
      CacheStore(sl<JsonStore>(instanceName: 'cache')),
    )
    ..registerSingleton<MockApiClient>(MockApiClient(config))
    ..registerSingleton<ApiClient>(sl<MockApiClient>())
    ..registerSingleton<CachingFetcher>(
      CachingFetcher(sl<CacheStore>(), sl<ConnectivityService>()),
    )
    ..registerSingleton<FlagsRepository>(
      FlagsRepository(
        sl<ApiClient>(),
        sl<CacheStore>(),
        sl<ConnectivityService>(),
      ),
    )
    ..registerSingleton<ConnectivityCubit>(ConnectivityCubit(connectivity))
    ..registerSingleton<ShellTabController>(ShellTabController())
    ..registerFactory<ThemeCubit>(ThemeCubit.new)
    ..registerFactory<LocaleCubit>(LocaleCubit.new);

  await sl<FlagsRepository>().load();

  registerCategoryModule(sl);
  registerProductsModule(sl);
  registerCatalogModule(sl);
  registerProductDetailsModule(sl);
  registerSearchModule(sl);
  registerCartModule(sl);
  registerCheckoutModule(sl);
  registerOrderModule(sl);
  registerOfflineSyncModule(sl);

  sl<CartBloc>().add(const CartStarted());
  sl<OutboxCubit>();
  sl<SyncManager>().start();
}
