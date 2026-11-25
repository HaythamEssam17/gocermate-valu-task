import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grocermate/core/config/flags_repository.dart';
import 'package:grocermate/core/connectivity/connectivity_cubit.dart';
import 'package:grocermate/core/factories/loading_factory.dart';
import 'package:grocermate/core/helpers/shared_functions.dart';
import 'package:grocermate/core/router/app_router.dart';
import 'package:grocermate/core/utils/enums/check_out_status.dart';
import 'package:grocermate/core/utils/extensions/context_extensions.dart';
import 'package:grocermate/core/utils/extensions/num_extensions.dart';
import 'package:grocermate/core/widgets/app_flush_bar.dart';
import 'package:grocermate/core/widgets/app_network_image.dart';
import 'package:grocermate/core/widgets/buttons/app_button.dart';
import 'package:grocermate/core/widgets/custom_scaffold.dart';
import 'package:grocermate/core/widgets/text_widgets/app_text.dart';
import 'package:grocermate/features/cart/domain/entities/cart_item.dart';
import 'package:grocermate/features/cart/domain/entities/cart_totals.dart';
import 'package:grocermate/features/checkout/domain/entities/checkout_args.dart';
import 'package:grocermate/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:grocermate/features/checkout/presentation/bloc/checkout_events.dart';
import 'package:grocermate/features/checkout/presentation/bloc/checkout_states.dart';
import 'package:grocermate/features/checkout/presentation/widgets/review_sheet.dart';
import 'package:grocermate/features/order/domain/entities/order_args.dart';
import 'package:grocermate/shared/widgets/cart_widgets/cart_summary.dart';
import 'package:material_ui/material_ui.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key, required this.args});
  final CheckoutArgs args;

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool _sheetOpen = false;

  List<CartItem> get _items =>
      widget.args.resume?.items ?? widget.args.items ?? const [];

  Future<void> _listenToCheckoutState(
    BuildContext context,
    CheckoutState s,
  ) async {
    final bloc = context.read<CheckoutBloc>();
    if (_sheetOpen &&
        s.status != CheckoutStatus.review &&
        s.status != CheckoutStatus.submitting) {
      context.pop();
    }

    switch (s.status) {
      case CheckoutStatus.review:
        if (_sheetOpen) return;
        _sheetOpen = true;
        await showReviewSheet(context, bloc);
        _sheetOpen = false;
        if (mounted && bloc.state.status == CheckoutStatus.review) {
          bloc.add(const CheckoutReviewDismissed());
        }
      case CheckoutStatus.success:
      case CheckoutStatus.partial:
        context.pushReplacement(
          AppRoutes.order,
          extra: OrderArgs(
            orderId: s.orderId!,
            partialMissing: s.status == CheckoutStatus.partial
                ? s.missing.length
                : 0,
            fromOutbox: s.outboxEntryId != null,
          ),
        );
      case CheckoutStatus.queued:
        context.pop();
        AppFlushbar.info(context, context.tr.orderQueued);
      case CheckoutStatus.cancelled:
        context.pop();
        AppFlushbar.error(context, context.tr.noItemsLeftToOrder);
      case CheckoutStatus.idle:
      case CheckoutStatus.submitting:
      case CheckoutStatus.failure:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final flags = context.read<FlagsRepository>().current;
    final online = context.select((ConnectivityCubit c) => c.state.isOnline);
    final resume = widget.args.resume;
    final totals = const CartTotalsCalculator().calculate(
      _items,
      taxRate: flags.taxRate,
      deliveryFee: flags.deliveryFee,
      freeDeliveryThreshold: flags.freeDeliveryThreshold,
    );

    return BlocConsumer<CheckoutBloc, CheckoutState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: _listenToCheckoutState,
      builder: (context, state) {
        final submitting = state.status == CheckoutStatus.submitting;

        return CustomScaffold(
          title: resume == null
              ? context.tr.checkout
              : context.tr.reviewQueuedOrder,
          body: Stack(
            children: [
              ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                children: [
                  if (resume != null && resume.note != null)
                    _Notice(
                      icon: Icons.sync_problem_rounded,
                      text: resume.note!,
                      color: context.appColors.error,
                    ),
                  if (!online)
                    _Notice(
                      icon: Icons.cloud_queue_rounded,
                      text: resume == null
                          ? context.tr.orderWillQueued
                          : context.tr.reconnectToReviewOrder,
                      color: context.appColors.warning,
                    ),
                  if (state.status == CheckoutStatus.failure)
                    _Notice(
                      icon: Icons.error_outline_rounded,
                      text: state.failure?.message ?? context.tr.orderFailed,
                      color: context.appColors.error,
                    ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: AppText(
                      'Order summary',
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  for (final i in _items)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          width: 52,
                          height: 52,
                          child: AppNetworkImage(i.image),
                        ),
                      ),
                      title: AppText(
                        i.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: AppText(
                        '${i.qty} x ${i.unitPrice.formatMoney()}',
                      ),
                      trailing: AppText(
                        i.lineTotal.formatMoney(),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  getSpaceHeight(context, 12),
                  CartSummary(totals: totals, flags: flags),
                  getSpaceHeight(context, 12),
                  AppText(
                    'Prices and availability are confirmed when you place the order.',
                    fontSize: 12,
                    color: context.textColors.lightText,
                  ),
                ],
              ),
              if (submitting)
                Positioned.fill(
                  child: ColoredBox(
                    color: Colors.black26,
                    child: Center(
                      child: PlatformLoading.buildLoading(context: context),
                    ),
                  ),
                ),
            ],
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: online
                          ? '${resume == null ? 'Place order' : 'Review & submit'}  -  ${totals.total.formatMoney()}'
                          : 'Queue order  -  ${totals.total.formatMoney()}',
                      onPressed:
                          submitting ||
                              _items.isEmpty ||
                              (!online && resume != null)
                          ? null
                          : () => context.read<CheckoutBloc>().add(
                              CheckoutPlaceRequested(
                                _items,
                                outboxEntryId: resume?.id,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice({required this.icon, required this.text, required this.color});
  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(
      children: [
        Icon(icon),
        getSpaceWidth(context, 12),
        Expanded(child: AppText(text)),
      ],
    ),
  );
}
