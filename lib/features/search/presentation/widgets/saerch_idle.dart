import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocermate/core/widgets/buttons/app_button.dart';
import 'package:grocermate/core/widgets/states_widgets/app_state_widget.dart';
import 'package:grocermate/core/widgets/text_widgets/app_text.dart';
import 'package:grocermate/features/search/presentation/bloc/search/search_bloc.dart';
import 'package:grocermate/features/search/presentation/bloc/search/search_events.dart';
import 'package:grocermate/features/search/presentation/bloc/search/search_states.dart';
import 'package:material_ui/material_ui.dart';

class SearchIdle extends StatelessWidget {
  const SearchIdle({super.key, required this.state, required this.onPick});
  final SearchState state;
  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) {
    if (state.recents.isEmpty) {
      return const AppStateWidget(
        icon: Icons.manage_search_rounded,
        title: 'Find your groceries',
        message:
            'Search by product name or use filters for category and brand.',
      );
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: AppText(
                  'Recent searches',
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              AppButton(
                text: 'Clear',
                onPressed: () => context.read<SearchBloc>().add(
                  const SearchRecentsCleared(),
                ),
                isFullWidth: false,
              ),
            ],
          ),
          for (final r in state.recents)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.history_rounded),
              title: AppText(r),
              trailing: const Icon(Icons.north_west_rounded, size: 18),
              onTap: () => onPick(r),
            ),
        ],
      ),
    );
  }
}
