import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocermate/core/config/flags_repository.dart';
import 'package:grocermate/core/connectivity/connectivity_cubit.dart';
import 'package:grocermate/core/di/injection.dart';
import 'package:grocermate/core/localization/cubit/locale_cubit.dart';
import 'package:grocermate/core/router/shell_tab_controller.dart';
import 'package:grocermate/core/theme/cubit/theme_cubit.dart';
import 'package:grocermate/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:grocermate/features/catalog/presentation/bloc/deals_cubit.dart';
import 'package:grocermate/features/category/presentation/bloc/category_bloc.dart';
import 'package:grocermate/features/category/presentation/bloc/category_event.dart';
import 'package:grocermate/features/offline_sync/presentation/bloc/outbox_cubit.dart';
import 'package:grocermate/features/products/presentation/bloc/products_bloc.dart';
import 'package:grocermate/features/products/presentation/bloc/products_events.dart';
import 'package:grocermate/features/search/presentation/bloc/search/search_bloc.dart';
import 'package:grocermate/features/search/presentation/bloc/search/search_events.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

class MultiBlocProviderPage extends StatelessWidget {
  const MultiBlocProviderPage({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        RepositoryProvider<FlagsRepository>.value(value: sl<FlagsRepository>()),
        ChangeNotifierProvider<ShellTabController>.value(
          value: sl<ShellTabController>(),
        ),

        BlocProvider(create: (_) => sl<ThemeCubit>()),
        BlocProvider(create: (_) => sl<LocaleCubit>()),

        BlocProvider<ConnectivityCubit>.value(value: sl<ConnectivityCubit>()),
        BlocProvider<CartBloc>.value(value: sl<CartBloc>()),

        BlocProvider<OutboxCubit>.value(value: sl<OutboxCubit>()),

        BlocProvider(
          create: (_) => sl<CategoriesBloc>()..add(const CategoriesRequested()),
        ),
        BlocProvider(
          create: (_) => sl<ProductsBloc>()..add(const ProductsStarted()),
        ),
        BlocProvider(create: (_) => sl<DealsCubit>()..load()),
        BlocProvider(
          create: (_) => sl<SearchBloc>()..add(const SearchStarted()),
        ),
      ],
      child: child,
    );
  }
}
