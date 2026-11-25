import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocermate/core/utils/extensions/context_extensions.dart';
import 'package:grocermate/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:grocermate/features/cart/presentation/bloc/cart_states.dart';
import 'package:grocermate/features/offline_sync/presentation/bloc/outbox_cubit.dart';
import 'package:grocermate/features/offline_sync/presentation/bloc/outbox_states.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

import 'nav_item.dart';

class MainNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const MainNavBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      decoration: BoxDecoration(
        color: colors.card,
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              NavItem(
                icon: LucideIcons.store,
                label: context.tr.lblHome,
                isActive: selectedIndex == 0,
                onTap: () => onDestinationSelected(0),
              ),
              NavItem(
                icon: LucideIcons.search,
                label: context.tr.lblSearch,
                isActive: selectedIndex == 1,
                onTap: () => onDestinationSelected(1),
              ),
              BlocSelector<CartBloc, CartState, int>(
                selector: (s) => s.cartCount,
                builder: (context, cartCount) => NavItem(
                  icon: LucideIcons.shoppingCart,
                  label: context.tr.lblCart,
                  isActive: selectedIndex == 2,
                  badgeCount: cartCount,
                  onTap: () => onDestinationSelected(2),
                ),
              ),
              BlocSelector<OutboxCubit, OutboxState, int>(
                selector: (s) => s.attentionCount,
                builder: (context, attentionCount) => NavItem(
                  icon: LucideIcons.receiptText,
                  label: context.tr.lblOrders,
                  isActive: selectedIndex == 3,
                  badgeCount: attentionCount,
                  onTap: () => onDestinationSelected(3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
