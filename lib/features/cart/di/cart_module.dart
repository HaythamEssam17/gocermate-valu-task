import 'package:get_it/get_it.dart';
import 'package:grocermate/core/config/flags_repository.dart';
import 'package:grocermate/core/network/api_client.dart';
import 'package:grocermate/core/network/connectivity_service.dart';
import 'package:grocermate/core/storage/json_store.dart';
import 'package:grocermate/features/cart/data/datasources/local/cart_local_data_source.dart';
import 'package:grocermate/features/cart/data/datasources/remote/cart_remote_data_source.dart';
import 'package:grocermate/features/cart/data/datasources/remote/cart_remote_data_source_impl.dart';
import 'package:grocermate/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:grocermate/features/cart/domain/repositories/cart_repository.dart';
import 'package:grocermate/features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:grocermate/features/cart/domain/usecases/apply_cart_patches_usecase.dart';
import 'package:grocermate/features/cart/domain/usecases/move_items_usecase.dart';
import 'package:grocermate/features/cart/domain/usecases/refresh_cart_stock_usecases.dart';
import 'package:grocermate/features/cart/domain/usecases/remove_items_usecase.dart';
import 'package:grocermate/features/cart/domain/usecases/restore_to_cart_usecase.dart';
import 'package:grocermate/features/cart/domain/usecases/update_quantity_usecase.dart';
import 'package:grocermate/features/cart/domain/usecases/watch_cart_usecase.dart';
import 'package:grocermate/features/cart/presentation/bloc/cart_bloc.dart';

void registerCartModule(GetIt sl) {
  sl
    ..registerLazySingleton(
      () => CartLocalDataSource(sl<JsonStore>(instanceName: 'user')),
    )
    ..registerLazySingleton<CartRemoteDataSource>(
      () => CartRemoteDataSourceImpl(sl<ApiClient>()),
    )
    ..registerLazySingleton<CartRepository>(
      () => CartRepositoryImpl(
        sl<CartLocalDataSource>(),
        sl<CartRemoteDataSource>(),
        sl<ConnectivityService>(),
      ),
    )
    ..registerLazySingleton(() => WatchCartUseCase(sl()))
    ..registerLazySingleton(() => AddToCartUseCase(sl()))
    ..registerLazySingleton(() => UpdateQuantityUseCase(sl()))
    ..registerLazySingleton(() => RemoveItemsUseCase(sl()))
    ..registerLazySingleton(() => MoveItemsUseCase(sl()))
    ..registerLazySingleton(() => ApplyCartPatchesUseCase(sl()))
    ..registerLazySingleton(() => RestoreToCartUseCase(sl()))
    ..registerLazySingleton(() => RefreshCartStockUseCase(sl()))
    ..registerLazySingleton(
      () => CartBloc(
        watchCart: sl(),
        addToCart: sl(),
        updateQuantity: sl(),
        removeItems: sl(),
        moveItems: sl(),
        refreshStock: sl(),
        flags: sl<FlagsRepository>(),
      ),
    );
}
