import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocermate/core/config/flags_repository.dart';
import 'package:grocermate/core/helpers/shared_functions.dart';
import 'package:grocermate/core/utils/extensions/context_extensions.dart';
import 'package:grocermate/core/widgets/custom_scaffold.dart';
import 'package:grocermate/core/widgets/skeletons/loading_skeleton.dart';
import 'package:grocermate/core/widgets/text_widgets/app_text.dart';
import 'package:grocermate/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:grocermate/features/cart/presentation/bloc/cart_events.dart';
import 'package:grocermate/features/cart/presentation/bloc/cart_states.dart';
import 'package:grocermate/features/cart/presentation/widgets/cart_tab.dart';
import 'package:grocermate/features/cart/presentation/widgets/saved_tab.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage>
    with SingleTickerProviderStateMixin {
  late final bool _savedEnabled;
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _savedEnabled = context.read<FlagsRepository>().current.enableSavedForLater;

    _tabs = TabController(length: _savedEnabled ? 2 : 1, vsync: this)
      ..addListener(() {
        if (!_tabs.indexIsChanging) {
          context.read<CartBloc>().add(CartTabChanged(_tabs.index));
        }
      });
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Column(
        children: [
          SizedBox(
            height: kToolbarHeight,
            child: BlocBuilder<CartBloc, CartState>(
              buildWhen: (p, c) =>
                  p.selected != c.selected ||
                  p.cart.length != c.cart.length ||
                  p.saved.length != c.saved.length ||
                  p.tabIndex != c.tabIndex,
              builder: (context, s) => _buildAppBar(context, s),
            ),
          ),
          getSpaceHeight(context, 16),
          Expanded(
            child: BlocBuilder<CartBloc, CartState>(
              builder: (context, s) {
                if (!s.loaded) return const LoadingSkeleton();
                return TabBarView(
                  controller: _tabs,
                  children: [
                    CartTab(state: s),
                    if (_savedEnabled) SavedTab(state: s),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, CartState s) {
    final bloc = context.read<CartBloc>();
    final tabs = _savedEnabled
        ? TabBar(
            controller: _tabs,
            tabs: [
              Tab(text: context.tr.cartCount(s.cart.length)),
              Tab(text: context.tr.savedCount(s.cart.length)),
            ],
            dividerHeight: 0,
          )
        : null;
    if (s.selectionMode) {
      final toSaved = s.tabIndex == 0;

      return Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => bloc.add(const CartSelectionCleared()),
          ),
          Expanded(child: AppText(context.tr.selectedCount(s.selected.length))),
          ...[
            IconButton(
              icon: const Icon(LucideIcons.listChecks),
              onPressed: () => bloc.add(const CartSelectAll()),
            ),
            if (_savedEnabled) ...[
              IconButton(
                icon: Icon(
                  toSaved
                      ? LucideIcons.bookmarkPlus
                      : LucideIcons.shoppingCartPlus,
                ),
                onPressed: () =>
                    bloc.add(CartItemsMoved(s.selected, toSaved: toSaved)),
              ),
              getSpaceWidth(context, 8),
            ],
            IconButton(
              icon: const Icon(LucideIcons.trash),
              onPressed: () =>
                  bloc.add(CartItemsRemoved(s.selected, fromSaved: !toSaved)),
            ),
          ],
        ],
      );
    }
    return tabs ?? const SizedBox.shrink();
  }
}
