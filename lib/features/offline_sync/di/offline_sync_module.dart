import 'package:get_it/get_it.dart';
import 'package:grocermate/features/cart/domain/usecases/restore_to_cart_usecase.dart';
import 'package:grocermate/features/offline_sync/domain/repositories/sync_repository.dart';
import 'package:grocermate/features/offline_sync/domain/usecases/cancel_queue_purchase_usecase.dart';
import 'package:grocermate/features/offline_sync/domain/usecases/complete_outbox_entry_usecase.dart';
import 'package:grocermate/features/offline_sync/domain/usecases/queue_purchase_usecase.dart';
import 'package:grocermate/features/offline_sync/domain/usecases/remove_outbox_entry_usecase.dart';

import '../../../core/config/flags_repository.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/connectivity_service.dart';
import '../../../core/storage/json_store.dart';
import '../../cart/domain/repositories/cart_repository.dart';
import '../data/datasources/outbox_local_data_source.dart';
import '../data/datasources/sync_remote_data_source.dart';
import '../data/repositories/outbox_repository_impl.dart';
import '../data/repositories/sync_repository_impl.dart';
import '../domain/repositories/outbox_repository.dart';
import '../service/sync_manager.dart';
import '../domain/usecases/watch_outbox_usecases.dart';
import '../presentation/bloc/outbox_cubit.dart';

void registerOfflineSyncModule(GetIt g) {
  g
    ..registerLazySingleton(
      () => OutboxLocalDataSource(g<JsonStore>(instanceName: 'user')),
    )
    ..registerLazySingleton<SyncRemoteDataSource>(
      () => SyncRemoteDataSourceImpl(g<ApiClient>()),
    )
    ..registerLazySingleton<OutboxRepository>(
      () => OutboxRepositoryImpl(g<OutboxLocalDataSource>()),
    )
    ..registerLazySingleton<SyncRepository>(
      () => SyncRepositoryImpl(
        g<SyncRemoteDataSource>(),
        g<OutboxLocalDataSource>(),
      ),
    )
    ..registerLazySingleton(() => WatchOutboxUseCase(g()))
    ..registerLazySingleton(
      () => QueuePurchaseUseCase(g<OutboxRepository>(), g<CartRepository>()),
    )
    ..registerLazySingleton(
      () => CancelQueuedPurchaseUseCase(
        g<OutboxRepository>(),
        g<CartRepository>(),
      ),
    )
    ..registerLazySingleton(() => CompleteOutboxEntryUseCase(g()))
    ..registerLazySingleton(() => RemoveOutboxEntryUseCase(g()))
    ..registerLazySingleton(
      () => SyncManager(
        outbox: g(),
        sync: g(),
        restoreToCart: g<RestoreToCartUseCase>(),
        connectivity: g<ConnectivityService>(),
        flags: g<FlagsRepository>(),
      ),
    )
    ..registerLazySingleton(
      () => OutboxCubit(g(), g(), g(), g(), g<OutboxRepository>()),
    );
}
