import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocermate/core/connectivity/connectivity_cubit.dart';
import 'package:grocermate/core/helpers/shared_functions.dart';
import 'package:grocermate/core/widgets/custom_scaffold.dart';
import 'package:grocermate/core/widgets/states_widgets/app_state_widget.dart';
import 'package:grocermate/features/offline_sync/presentation/bloc/outbox_cubit.dart';
import 'package:grocermate/features/offline_sync/presentation/bloc/outbox_states.dart';
import 'package:grocermate/features/offline_sync/presentation/widgets/entry_card.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class QueuePage extends StatelessWidget {
  const QueuePage({super.key});

  @override
  Widget build(BuildContext context) {
    final online = context.select((ConnectivityCubit c) => c.state.isOnline);

    return CustomScaffold(
      title: 'Orders',
      appBarActions: [
        IconButton(
          tooltip: 'Sync now',
          onPressed: online
              ? () => context.read<OutboxCubit>().syncNow()
              : null,
          icon: const Icon(LucideIcons.refreshCcw),
        ),
      ],
      body: BlocBuilder<OutboxCubit, OutboxState>(
        builder: (context, s) {
          if (s.entries.isEmpty) {
            return const AppStateWidget(
              icon: Icons.receipt_long_outlined,
              title: 'No queued orders',
              message:
                  'Orders you place while offline appear here and are sent automatically '
                  'when your connection returns.',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: s.entries.length,
            separatorBuilder: (_, _) => getSpaceHeight(context, 12),
            itemBuilder: (_, i) => EntryCard(entry: s.entries[i]),
          );
        },
      ),
    );
  }
}
