import 'package:get_it/get_it.dart';
import 'package:grocermate/features/catalog/data/datasources/local/catalog_local_data_source.dart';
import 'package:grocermate/features/catalog/data/datasources/remote/catalog_remote_data_source.dart';
import 'package:grocermate/features/catalog/data/datasources/remote/catalog_remote_data_source_impl.dart';
import 'package:grocermate/features/catalog/domain/usecases/get_brands_usecase.dart';
import 'package:grocermate/features/products/domain/usecases/get_products_by_ids_usecase.dart';

import '../../../core/cache/caching_fetcher.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/cache_store.dart';
import '../data/repositories/catalog_repository_impl.dart';
import '../domain/repositories/catalog_repository.dart';
import '../domain/usecases/catalog_usecases.dart';
import '../presentation/bloc/deals_cubit.dart';

void registerCatalogModule(GetIt sl) {
  sl
    ..registerLazySingleton<CatalogRemoteDataSource>(
      () => CatalogRemoteDataSourceImpl(sl<ApiClient>()),
    )
    ..registerLazySingleton(() => CatalogLocalDataSource(sl<CacheStore>()))
    ..registerLazySingleton<CatalogRepository>(
      () => CatalogRepositoryImpl(
        sl<CatalogRemoteDataSource>(),
        sl<CatalogLocalDataSource>(),
        sl<CachingFetcher>(),
        sl<GetProductsByIdsUseCase>(),
      ),
    )
    ..registerLazySingleton(() => GetBrandsUseCase(sl()))
    ..registerLazySingleton(() => GetDealsUseCase(sl()))
    ..registerFactory(() => DealsCubit(sl()));
}
