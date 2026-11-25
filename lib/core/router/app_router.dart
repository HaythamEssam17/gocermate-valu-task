import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grocermate/app/app_shell.dart';
import 'package:grocermate/app/maintenance_page.dart';
import 'package:grocermate/core/di/injection.dart';
import 'package:grocermate/features/checkout/domain/entities/checkout_args.dart';
import 'package:grocermate/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:grocermate/features/checkout/presentation/pages/checkout_page.dart';
import 'package:grocermate/features/order/domain/entities/order_args.dart';
import 'package:grocermate/features/order/presentation/bloc/order_cubit.dart';
import 'package:grocermate/features/order/presentation/pages/order_page.dart';
import 'package:grocermate/features/product_details/presentation/bloc/product_details_bloc.dart';
import 'package:grocermate/features/product_details/presentation/bloc/product_details_events.dart';
import 'package:grocermate/features/product_details/presentation/pages/product_details_page.dart';
import 'package:grocermate/features/splash/presentation/pages/splash_page.dart';

class AppRoutes {
  AppRoutes._();

  static const splash = '/splash';
  static const shell = '/';
  static const product = '/product';
  static const checkout = '/checkout';
  static const order = '/order';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        name: splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: shell,
        name: shell,
        builder: (context, state) => const MaintenancePage(child: AppShell()),
      ),
      GoRoute(
        path: product,
        name: product,
        builder: (context, state) {
          final id =
              (state.extra as String?) ?? state.pathParameters['id'] ?? '';
          return BlocProvider(
            create: (_) =>
                sl<ProductDetailsBloc>()..add(ProductDetailsRequested(id)),
            child: ProductDetailsPage(productId: id),
          );
        },
      ),
      GoRoute(
        path: '$product/:id',
        name: '$product/:id',
        builder: (context, state) {
          final id =
              state.pathParameters['id'] ?? (state.extra as String?) ?? '';
          return BlocProvider(
            create: (_) =>
                sl<ProductDetailsBloc>()..add(ProductDetailsRequested(id)),
            child: ProductDetailsPage(productId: id),
          );
        },
      ),
      GoRoute(
        path: checkout,
        name: checkout,
        builder: (context, state) {
          final args = (state.extra as CheckoutArgs?) ?? const CheckoutArgs();
          return BlocProvider(
            create: (_) => sl<CheckoutBloc>(),
            child: CheckoutPage(args: args),
          );
        },
      ),
      GoRoute(
        path: order,
        name: order,
        builder: (context, state) {
          final args =
              (state.extra as OrderArgs?) ?? const OrderArgs(orderId: '');
          return BlocProvider(
            create: (_) => sl<OrderCubit>()..load(args.orderId),
            child: OrderPage(args: args),
          );
        },
      ),
    ],
  );
}
