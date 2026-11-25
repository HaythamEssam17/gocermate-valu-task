import 'package:get_it/get_it.dart';
import 'package:grocermate/features/cart/domain/usecases/apply_cart_patches_usecase.dart';
import 'package:grocermate/features/cart/domain/usecases/remove_items_usecase.dart';
import 'package:grocermate/features/cart/domain/usecases/restore_to_cart_usecase.dart';
import 'package:grocermate/features/checkout/data/datasources/checkout_remote_data_source_impl.dart';
import 'package:grocermate/features/checkout/domain/entities/review_resolver.dart';
import 'package:grocermate/features/offline_sync/domain/usecases/complete_outbox_entry_usecase.dart';
import 'package:grocermate/features/offline_sync/domain/usecases/queue_purchase_usecase.dart';

import '../../../core/config/flags_repository.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/connectivity_service.dart';
import '../data/datasources/checkout_remote_data_source.dart';
import '../data/repositories/checkout_repository_impl.dart';
import '../domain/repositories/checkout_repository.dart';
import '../domain/usecases/checkout_usecases.dart';
import '../presentation/bloc/checkout_bloc.dart';

void registerCheckoutModule(GetIt g) {
  g
    ..registerLazySingleton<CheckoutRemoteDataSource>(
      () => CheckoutRemoteDataSourceImpl(g<ApiClient>()),
    )
    ..registerLazySingleton<CheckoutRepository>(
      () => CheckoutRepositoryImpl(g<CheckoutRemoteDataSource>()),
    )
    ..registerLazySingleton(
      () => PlaceOrderUseCase(g<CheckoutRepository>(), g<FlagsRepository>()),
    )
    ..registerLazySingleton(() => const ReviewResolver())
    ..registerFactory(
      () => CheckoutBloc(
        placeOrder: g(),
        resolver: g(),
        applyPatches: g<ApplyCartPatchesUseCase>(),
        removeItems: g<RemoveItemsUseCase>(),
        restoreToCart: g<RestoreToCartUseCase>(),
        queuePurchase: g<QueuePurchaseUseCase>(),
        completeOutbox: g<CompleteOutboxEntryUseCase>(),
        connectivity: g<ConnectivityService>(),
      ),
    );
}
