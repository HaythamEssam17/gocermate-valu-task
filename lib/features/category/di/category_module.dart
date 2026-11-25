import 'package:get_it/get_it.dart';
import 'package:grocermate/features/category/domain/usecases/get_categories_usecase.dart';

import '../data/ds/remote/category_remote_ds.dart';
import '../data/ds/remote/category_remote_ds_impl.dart';
import '../data/repositories/category_repo_impl.dart';
import '../domain/repositories/category_repository.dart';
import '../presentation/bloc/category_bloc.dart';

void registerCategoryModule(GetIt sl) {
  // DataSource
  sl.registerLazySingleton<CategoryRemoteDataSource>(
    () => CategoryRemoteDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(sl(), sl()),
  );

  // UseCase
  sl.registerLazySingleton(() => GetCategoriesUseCase(sl()));

  // Bloc
  sl.registerLazySingleton(() => CategoriesBloc(sl()));
}
