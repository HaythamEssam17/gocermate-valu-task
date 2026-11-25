import 'package:get_it/get_it.dart';
import 'package:grocermate/features/products/domain/usecases/get_products_by_ids_usecase.dart';
import 'package:grocermate/features/products/domain/usecases/get_products_usecase.dart';

import '../data/ds/remote/products_remote_ds.dart';
import '../data/ds/remote/products_remote_ds_impl.dart';
import '../data/repositories/products_repo_impl.dart';
import '../domain/repositories/products_repository.dart';
import '../presentation/bloc/products_bloc.dart';

void registerProductsModule(GetIt sl) {
  // DataSource
  sl.registerLazySingleton<ProductsRemoteDataSource>(
    () => ProductsRemoteDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<ProductsRepository>(
    () => ProductsRepositoryImpl(sl(), sl(), sl(), sl()),
  );

  // UseCase
  sl.registerLazySingleton(() => GetProductsUseCase(sl()));
  sl.registerLazySingleton(() => GetProductsByIdsUseCase(sl()));

  // Bloc
  sl.registerLazySingleton(() => ProductsBloc(sl()));
}
