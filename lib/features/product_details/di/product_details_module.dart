import 'package:get_it/get_it.dart';
import 'package:grocermate/features/product_details/data/datasources/product_details_remote_data_source_impl.dart';
import 'package:grocermate/features/product_details/domain/usecases/get_inventory_usecase.dart';
import 'package:grocermate/features/product_details/domain/usecases/get_price_history_usecase.dart';

import '../../../core/cache/caching_fetcher.dart';
import '../../../core/network/api_client.dart';
import '../data/datasources/product_details_remote_data_source.dart';
import '../data/repositories/product_details_repository_impl.dart';
import '../domain/repositories/product_details_repository.dart';
import '../domain/usecases/get_product_details_usecases.dart';
import '../presentation/bloc/product_details_bloc.dart';

void registerProductDetailsModule(GetIt sl) {
  sl
    ..registerLazySingleton<ProductDetailsRemoteDataSource>(
      () => ProductDetailsRemoteDataSourceImpl(sl<ApiClient>()),
    )
    ..registerLazySingleton<ProductDetailsRepository>(
      () => ProductDetailsRepositoryImpl(
        sl<ProductDetailsRemoteDataSource>(),
        sl<CachingFetcher>(),
      ),
    )
    ..registerLazySingleton(() => GetProductDetailsUseCase(sl()))
    ..registerLazySingleton(() => GetInventoryUseCase(sl()))
    ..registerLazySingleton(() => GetPriceHistoryUseCase(sl()))
    ..registerFactory(() => ProductDetailsBloc(sl(), sl(), sl(), sl()));
}
