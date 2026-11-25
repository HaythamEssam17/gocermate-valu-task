import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocermate/core/helpers/shared_functions.dart';
import 'package:grocermate/core/router/shell_tab_controller.dart';
import 'package:grocermate/core/utils/extensions/context_extensions.dart';
import 'package:grocermate/core/widgets/states_widgets/app_state_widget.dart';
import 'package:grocermate/features/cart/domain/entities/cart_item.dart';
import 'package:grocermate/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:grocermate/features/cart/presentation/bloc/cart_events.dart';
import 'package:grocermate/features/cart/presentation/bloc/cart_states.dart';
import 'package:grocermate/shared/widgets/cart_widgets/cart_summary.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/config/flags_repository.dart' show FlagsRepository;
import 'cart_item_tile.dart';
import 'check_out_bar.dart';

class CartTab extends StatelessWidget {
  const CartTab({super.key, required this.state});
  final CartState state;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CartBloc>();

    if (state.cart.isEmpty) {
      return AppStateWidget(
        icon: LucideIcons.shoppingCart,
        title: context.tr.yourCartIsEmpty,
        message: context.tr.addSomeToGetStarted,
        actionLabel: context.tr.browseProducts,
        onAction: () => context.read<ShellTabController>().go(0),
      );
    }
    final flags = context.read<FlagsRepository>().current;
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            children: [
              for (final item in state.cart)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _tile(bloc, item, isSaved: false),
                ),
              getSpaceHeight(context, 8),
              CartSummary(totals: state.totals, flags: flags),
            ],
          ),
        ),

        CheckoutBar(state: state),
      ],
    );
  }

  Widget _tile(CartBloc bloc, CartItem item, {required bool isSaved}) =>
      CartItemTile(
        key: ValueKey('${isSaved ? 's' : 'c'}-${item.productId}'),
        item: item,
        isSaved: isSaved,
        selectionMode: state.selectionMode,
        selected: state.selected.contains(item.productId),
        onToggleSelect: () => bloc.add(CartSelectionToggled(item.productId)),
        onQtyChanged: (q) => bloc.add(CartQtyChanged(item.productId, q)),
        onRemove: () =>
            bloc.add(CartItemsRemoved({item.productId}, fromSaved: isSaved)),
        onMove: () =>
            bloc.add(CartItemsMoved({item.productId}, toSaved: !isSaved)),
      );
}
