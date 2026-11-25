import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocermate/core/config/flags_repository.dart';
import 'package:grocermate/core/helpers/shared_functions.dart';
import 'package:grocermate/core/utils/extensions/context_extensions.dart';
import 'package:grocermate/core/widgets/states_widgets/app_state_widget.dart';
import 'package:grocermate/core/widgets/text_widgets/app_text.dart';
import 'package:grocermate/features/catalog/presentation/bloc/deals_cubit.dart';
import 'package:grocermate/features/catalog/presentation/bloc/deals_states.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'deal_card.dart';

class DealsSection extends StatelessWidget {
  const DealsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final flags = context.read<FlagsRepository>();
    return ValueListenableBuilder(
      valueListenable: flags.listenable,
      builder: (context, f, _) {
        if (!f.showDeals) return const SizedBox.shrink();

        return BlocBuilder<DealsCubit, DealsState>(
          builder: (context, state) {
            if (state.deals.isEmpty) {
              return AppStateWidget(
                icon: LucideIcons.databaseX,
                title: context.tr.noDealsForNow,
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Row(
                    spacing: 8,
                    children: [
                      Icon(LucideIcons.flame, color: context.appColors.primary),

                      AppText(
                        context.tr.dealsOfTheDay,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 196,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: state.deals.length,
                    separatorBuilder: (_, _) => getSpaceWidth(context, 12),
                    itemBuilder: (_, i) => DealCard(deal: state.deals[i]),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
