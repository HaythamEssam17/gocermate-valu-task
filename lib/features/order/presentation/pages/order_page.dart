import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocermate/core/router/shell_tab_controller.dart';
import 'package:grocermate/core/utils/enums/view_status.dart';
import 'package:grocermate/core/utils/extensions/num_extensions.dart';
import 'package:grocermate/core/widgets/skeletons/loading_skeleton.dart';
import 'package:grocermate/core/widgets/states_widgets/inline_error.dart';
import 'package:grocermate/features/order/presentation/bloc/order_cubit.dart';
import 'package:grocermate/features/order/presentation/bloc/order_states.dart';

class OrderArgs {
  const OrderArgs({
    required this.orderId,
    this.partialMissing = 0,
    this.fromOutbox = false,
  });
  final String orderId;
  final int partialMissing;
  final bool fromOutbox;
}

class OrderPage extends StatelessWidget {
  const OrderPage({super.key, required this.args});
  final OrderArgs args;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
        ),
      ),
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
                    color: scheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    size: 52,
                    color: scheme.onPrimaryContainer,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                args.partialMissing > 0
                    ? 'Order placed (partially)'
                    : 'Order placed!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Text(
                'Order number ${args.orderId}',
                textAlign: TextAlign.center,
                style: TextStyle(color: scheme.onSurfaceVariant),
              ),
              if (args.partialMissing > 0)
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: scheme.tertiaryContainer,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    '${args.partialMissing} unavailable item(s) were not included. '
                    'They are back in your cart so you can order them later.',
                  ),
                ),
              const SizedBox(height: 20),
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
                    title: Text(
                      s.products[line.productId]?.title ?? line.productId,
                    ),
                    subtitle: Text(
                      '${line.qty} x ${(line.unitPrice).formatMoney()}',
                    ),
                    trailing: Text(
                      (line.qty * line.unitPrice).formatMoney(),
                      style: const TextStyle(fontWeight: FontWeight.w700),
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
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () {
                  Navigator.of(context).popUntil((r) => r.isFirst);
                  context.read<ShellTabController>().go(0);
                },
                child: const Text('Continue shopping'),
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
        Expanded(
          child: Text(
            l,
            style: TextStyle(fontWeight: bold ? FontWeight.w800 : null),
          ),
        ),
        Text(
          v,
          style: TextStyle(
            fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
            fontSize: bold ? 18 : null,
          ),
        ),
      ],
    ),
  );
}
