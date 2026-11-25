import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocermate/core/helpers/shared_functions.dart';
import 'package:grocermate/core/widgets/states_widgets/app_state_widget.dart';
import 'package:grocermate/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:grocermate/features/cart/presentation/bloc/cart_events.dart';
import 'package:grocermate/features/cart/presentation/bloc/cart_states.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

import 'cart_item_tile.dart';

class SavedTab extends StatelessWidget {
  const SavedTab({super.key, required this.state});
  final CartState state;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CartBloc>();
    if (state.saved.isEmpty) {
      return const AppStateWidget(
        icon: LucideIcons.bookBookmark,
        title: '',
        message: '',
      );
    }
    return ListView.separated(
      itemCount: state.saved.length,
      separatorBuilder: (_, _) => getSpaceHeight(context, 12),
      itemBuilder: (_, i) {
        final item = state.saved[i];
        return CartItemTile(
          key: ValueKey('s-${item.productId}'),
          item: item,
          isSaved: true,
          selectionMode: state.selectionMode,
          selected: state.selected.contains(item.productId),
          onToggleSelect: () => bloc.add(CartSelectionToggled(item.productId)),
          onQtyChanged: (_) {},
          onRemove: () =>
              bloc.add(CartItemsRemoved({item.productId}, fromSaved: true)),
          onMove: () =>
              bloc.add(CartItemsMoved({item.productId}, toSaved: false)),
        );
      },
    );
  }
}
