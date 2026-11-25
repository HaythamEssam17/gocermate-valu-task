import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocermate/core/connectivity/connectivity_states.dart';
import 'package:grocermate/core/utils/enums/network_banner_enum.dart';
import 'package:grocermate/core/widgets/app_flush_bar.dart';
import 'package:grocermate/core/widgets/custom_scaffold.dart';
import 'package:grocermate/core/widgets/main_nav_bar_widgets/main_nav_bar.dart';
import 'package:grocermate/features/cart/presentation/bloc/cart_events.dart';
import 'package:grocermate/features/cart/presentation/bloc/cart_states.dart';
import 'package:grocermate/features/category/presentation/bloc/category_bloc.dart';
import 'package:grocermate/features/category/presentation/bloc/category_event.dart';
import 'package:grocermate/features/offline_sync/presentation/bloc/outbox_states.dart';
import 'package:grocermate/features/products/presentation/bloc/products_bloc.dart';
import 'package:grocermate/features/products/presentation/bloc/products_events.dart';

import '../core/config/flags_repository.dart';
import '../core/connectivity/connectivity_cubit.dart';
import '../core/router/shell_tab_controller.dart';
import '../features/cart/presentation/bloc/cart_bloc.dart';
import '../features/cart/presentation/pages/cart_page.dart';
import '../features/catalog/presentation/bloc/deals_cubit.dart';
import '../features/catalog/presentation/pages/home_page.dart';
import '../features/offline_sync/presentation/bloc/outbox_cubit.dart';
import '../features/offline_sync/presentation/pages/queue_page.dart';
import '../features/search/presentation/pages/search_page.dart';
import 'multi_bloc_provider_page.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late final PageController _pageController;
  late final ShellTabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = context.read<ShellTabController>();
    _pageController = PageController(initialPage: _tabController.value);
    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (_pageController.hasClients &&
        _pageController.page?.round() != _tabController.value) {
      _pageController.animateToPage(
        _tabController.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProviderPage(
      child: MultiBlocListener(
        listeners: [
          BlocListener<CartBloc, CartState>(
            listenWhen: (p, c) =>
                p.messageId != c.messageId && c.message != null,
            listener: (_, s) => AppFlushbar.error(context, s.message!),
          ),
          BlocListener<OutboxCubit, OutboxState>(
            listenWhen: (p, c) => p.noticeId != c.noticeId && c.notice != null,
            listener: (_, s) => AppFlushbar.info(
              context,
              s.notice!,
              title: 'View',
              onAction: () => _tabController.go(3),
            ),
          ),
          BlocListener<ConnectivityCubit, ConnectivityState>(
            listenWhen: (previous, current) =>
                current.banner == NetworkBanner.restored &&
                previous.banner != NetworkBanner.restored,
            listener: (context, _) {
              context.read<ProductsBloc>().add(const ProductsRefreshed());
              context.read<CategoriesBloc>().add(
                const CategoriesRequested(forceRefresh: true),
              );
              context.read<DealsCubit>().load(forceRefresh: true);
              context.read<FlagsRepository>().refresh();
              context.read<CartBloc>().add(const CartStockRefreshRequested());
            },
          ),
        ],
        child: ValueListenableBuilder<int>(
          valueListenable: _tabController,
          builder: (context, index, _) => CustomScaffold(
            padding: EdgeInsets.zero,
            body: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                HomePage(),
                SearchPage(),
                CartPage(),
                QueuePage(),
              ],
            ),
            bottomNavigationBar: MainNavBar(
              selectedIndex: index,
              onDestinationSelected: _tabController.go,
            ),
          ),
        ),
      ),
    );
  }
}
