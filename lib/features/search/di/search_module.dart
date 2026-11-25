import 'package:get_it/get_it.dart';
import 'package:grocermate/core/config/flags_repository.dart';
import 'package:grocermate/core/network/api_client.dart';
import 'package:grocermate/core/network/connectivity_service.dart';
import 'package:grocermate/core/storage/json_store.dart';
import 'package:grocermate/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:grocermate/features/catalog/domain/usecases/get_brands_usecase.dart';
import 'package:grocermate/features/search/data/datasources/recent_searches_local_data_source.dart';
import 'package:grocermate/features/search/data/datasources/search_remote_data_source.dart';
import 'package:grocermate/features/search/data/repositories/search_repository_impl.dart';
import 'package:grocermate/features/search/domain/repositories/search_repository.dart';
import 'package:grocermate/features/search/domain/usecases/clear_recent_searches_usecase.dart';
import 'package:grocermate/features/search/domain/usecases/get_recent_searches_usecase.dart';
import 'package:grocermate/features/search/domain/usecases/get_suggestions_usecases.dart';
import 'package:grocermate/features/search/domain/usecases/save_recent_search_usecase.dart';
import 'package:grocermate/features/search/presentation/bloc/brands/brands_cubit.dart';
import 'package:grocermate/features/search/presentation/bloc/search/search_bloc.dart';

void registerSearchModule(GetIt sl) {
  sl
    ..registerLazySingleton<SearchRemoteDataSource>(
      () => SearchRemoteDataSourceImpl(sl<ApiClient>()),
    )
    ..registerLazySingleton(
      () => RecentSearchesLocalDataSource(sl<JsonStore>(instanceName: 'user')),
    )
    ..registerLazySingleton<SearchRepository>(
      () => SearchRepositoryImpl(
        sl<SearchRemoteDataSource>(),
        sl<RecentSearchesLocalDataSource>(),
        sl<CatalogRepository>(),
        sl<ConnectivityService>(),
      ),
    )
    ..registerLazySingleton(() => GetSuggestionsUseCase(sl()))
    ..registerLazySingleton(() => GetRecentSearchesUseCase(sl()))
    ..registerLazySingleton(() => SaveRecentSearchUseCase(sl()))
    ..registerLazySingleton(() => ClearRecentSearchesUseCase(sl()))
    ..registerFactory(() => BrandsCubit(sl<GetBrandsUseCase>()))
    ..registerFactory(
      () => SearchBloc(
        getProducts: sl(),
        getSuggestions: sl(),
        getRecents: sl(),
        saveRecent: sl(),
        clearRecents: sl(),
        debounce: Duration(
          milliseconds: sl<FlagsRepository>().current.searchDebounceMs,
        ),
      ),
    );
}
