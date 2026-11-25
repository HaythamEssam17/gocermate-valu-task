import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grocermate/core/helpers/shared_functions.dart';
import 'package:grocermate/core/router/app_router.dart';
import 'package:grocermate/core/theme/cubit/app_colors_extension.dart';
import 'package:grocermate/core/utils/enums/app_button_type.dart';
import 'package:grocermate/core/utils/extensions/context_extensions.dart';
import 'package:grocermate/core/utils/extensions/date_extensions.dart';
import 'package:grocermate/core/utils/extensions/num_extensions.dart';
import 'package:grocermate/core/widgets/app_card.dart';
import 'package:grocermate/core/widgets/buttons/app_button.dart';
import 'package:grocermate/core/widgets/text_widgets/app_text.dart';
import 'package:grocermate/features/checkout/domain/entities/checkout_args.dart';
import 'package:grocermate/features/offline_sync/domain/entities/outbox_entry.dart';
import 'package:grocermate/features/offline_sync/presentation/bloc/outbox_cubit.dart';
import 'package:grocermate/features/order/domain/entities/order_args.dart';
import 'package:material_ui/material_ui.dart';

class EntryCard extends StatelessWidget {
  const EntryCard({super.key, required this.entry});
  final OutboxEntry entry;

  ({String label, Color color, IconData icon}) _status(
    AppColorsExtension appColors,
  ) => switch (entry.status) {
    OutboxStatus.queued => (
      label: 'Queued',
      color: appColors.primaryBg,
      icon: Icons.schedule_rounded,
    ),
    OutboxStatus.syncing => (
      label: 'Sending...',
      color: appColors.primary,
      icon: Icons.sync_rounded,
    ),
    OutboxStatus.needsReview => (
      label: 'Needs review',
      color: appColors.warning,
      icon: Icons.rule_rounded,
    ),
    OutboxStatus.completed => (
      label: 'Placed',
      color: appColors.success,
      icon: Icons.check_circle_rounded,
    ),
    OutboxStatus.failed => (
      label: 'Failed',
      color: appColors.error,
      icon: Icons.error_rounded,
    ),
  };

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OutboxCubit>();
    final st = _status(context.appColors);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(st.icon, color: st.color),
              getSpaceWidth(context, 8),
              AppText(st.label, color: st.color, fontWeight: FontWeight.w800),
              const Spacer(),
              AppText(
                entry.createdAt.timeAgo(),
                color: context.appColors.background,
                fontSize: 12,
              ),
            ],
          ),
          if (entry.status == OutboxStatus.syncing) ...[
            getSpaceHeight(context, 8),
            const LinearProgressIndicator(),
          ],
          getSpaceHeight(context, 8),
          AppText(
            entry.items.map((i) => '${i.qty} x ${i.title}').join(', '),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          getSpaceHeight(context, 4),
          AppText(
            entry.total != null
                ? 'Total ${entry.total!.formatMoney()}${entry.orderId != null ? '  -  ${entry.orderId}' : ''}'
                : 'About ${entry.estimatedTotal.formatMoney()} before tax & delivery',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          if (entry.note != null) ...[
            getSpaceHeight(context, 4),
            AppText(
              entry.note!,
              color: context.textColors.lightText,
              fontSize: 12,
            ),
          ],
          getSpaceHeight(context, 8),
          Wrap(
            spacing: 8,
            children: [
              if (entry.status == OutboxStatus.needsReview) ...[
                AppButton(
                  text: 'Review',
                  isFullWidth: false,
                  onPressed: () => context.pushNamed(
                    AppRoutes.checkout,
                    extra: CheckoutArgs(resume: entry),
                  ),
                  type: AppButtonType.ghost,
                ),
                getSpaceHeight(context, 8),
              ],
              if (entry.status == OutboxStatus.failed) ...[
                AppButton(
                  text: 'Retry',
                  isFullWidth: false,
                  onPressed: () => cubit.retry(entry),
                  type: AppButtonType.ghost,
                ),
                getSpaceHeight(context, 8),
              ],
              if (entry.status == OutboxStatus.completed &&
                  entry.orderId != null) ...[
                AppButton(
                  text: 'View order',
                  isFullWidth: false,
                  onPressed: () => context.pushNamed(
                    AppRoutes.order,
                    extra: OrderArgs(orderId: entry.orderId!),
                  ),
                  type: AppButtonType.secondary,
                ),
                getSpaceHeight(context, 8),
              ],
              if (entry.status == OutboxStatus.completed)
                AppButton(
                  text: 'Dismiss',
                  isFullWidth: false,
                  onPressed: () => cubit.dismiss(entry.id),
                  type: AppButtonType.secondary,
                )
              else if (entry.status != OutboxStatus.syncing)
                AppButton(
                  text: 'Cancel & restore cart',
                  isFullWidth: false,
                  onPressed: () => cubit.cancel(entry),
                  // type: AppButtonType.secondary,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
