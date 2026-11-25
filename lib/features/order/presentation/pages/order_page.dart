import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocermate/core/helpers/shared_functions.dart';
import 'package:grocermate/core/router/shell_tab_controller.dart';
import 'package:grocermate/core/utils/enums/view_status.dart';
import 'package:grocermate/core/utils/extensions/context_extensions.dart';
import 'package:grocermate/core/utils/extensions/num_extensions.dart';
import 'package:grocermate/core/widgets/buttons/app_button.dart';
import 'package:grocermate/core/widgets/custom_scaffold.dart';
import 'package:grocermate/core/widgets/skeletons/loading_skeleton.dart';
import 'package:grocermate/core/widgets/states_widgets/inline_error.dart';
import 'package:grocermate/core/widgets/text_widgets/app_text.dart';
import 'package:grocermate/features/order/domain/entities/order_args.dart';
import 'package:grocermate/features/order/presentation/bloc/order_cubit.dart';
import 'package:grocermate/features/order/presentation/bloc/order_states.dart';
import 'package:material_ui/material_ui.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key, required this.args});
  final OrderArgs args;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'Order',
      body: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, s) {
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Center(
                child: Container(
                  width: 92,
                  height: 92,
                  decoration: BoxDecoration(
                    color: context.appColors.primaryBg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    size: 52,
                    color: context.appColors.primary,
                  ),
                ),
              ),
              getSpaceHeight(context, 16),
              AppText(
                args.partialMissing > 0
                    ? 'Order placed (partially)'
                    : 'Order placed!',
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w800,
              ),

              getSpaceHeight(context, 4),
              AppText(
                'Order number ${args.orderId}',
                textAlign: TextAlign.center,
                color: context.textColors.lightText,
              ),
              if (args.partialMissing > 0)
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    // color: scheme.tertiaryContainer,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: AppText(
                    '${args.partialMissing} unavailable item(s) were not included. '
                    'They are back in your cart so you can order them later.',
                  ),
                ),
              getSpaceHeight(context, 20),
              if (s.status == ViewStatus.loading ||
                  s.status == ViewStatus.initial)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: LoadingSkeleton(),
                )
              else if (s.status == ViewStatus.failure)
                InlineError(
                  message: 'Could not load the receipt.',
                  onRetry: () => context.read<OrderCubit>().load(args.orderId),
                )
              else ...[
                for (final line in s.order!.items)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: AppText(
                      s.products[line.productId]?.title ?? line.productId,
                    ),
                    subtitle: AppText(
                      '${line.qty} x ${(line.unitPrice).formatMoney()}',
                    ),
                    trailing: AppText(
                      (line.qty * line.unitPrice).formatMoney(),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                const Divider(),
                _row('Subtotal', (s.order!.subtotal).formatMoney()),
                _row('Tax', (s.order!.tax).formatMoney()),
                _row(
                  'Delivery',
                  s.order!.deliveryFee == 0
                      ? 'Free'
                      : (s.order!.deliveryFee).formatMoney(),
                ),
                _row('Total', (s.order!.total).formatMoney(), bold: true),
              ],
              getSpaceHeight(context, 24),
              AppButton(
                text: 'Continue shopping',
                onPressed: () {
                  Navigator.of(context).popUntil((r) => r.isFirst);
                  context.read<ShellTabController>().go(0);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _row(String l, String v, {bool bold = false}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(
      children: [
        Expanded(child: AppText(l, fontWeight: bold ? FontWeight.w800 : null)),
        AppText(
          v,
          fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
          fontSize: bold ? 18 : null,
        ),
      ],
    ),
  );
}
