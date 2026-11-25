import 'package:get_it/get_it.dart';

import '../data/ds/remote/order_remote_ds.dart';
import '../data/ds/remote/order_remote_ds_impl.dart';
import '../data/repositories/order_repo_impl.dart';
import '../domain/repositories/order_repository.dart';
import '../domain/usecases/order_usecase.dart';
import '../presentation/bloc/order_cubit.dart';

void registerOrderModule(GetIt sl) {
  // DataSource
  sl.registerLazySingleton<OrderRemoteDataSource>(
    () => OrderRemoteDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<OrderRepository>(() => OrderRepositoryImpl(sl()));

  // UseCase
  sl.registerLazySingleton(() => GetOrderUseCase(sl()));

  // Bloc
  sl.registerLazySingleton(() => OrderCubit(sl(), sl()));
}
