import 'package:go_router/go_router.dart';
import 'package:grocermate/core/helpers/shared_functions.dart';
import 'package:grocermate/core/router/app_router.dart';
import 'package:grocermate/core/utils/extensions/context_extensions.dart';
import 'package:grocermate/core/utils/extensions/num_extensions.dart';
import 'package:grocermate/core/widgets/app_card.dart';
import 'package:grocermate/core/widgets/buttons/app_button.dart';
import 'package:grocermate/core/widgets/text_widgets/app_text.dart';
import 'package:grocermate/features/cart/presentation/bloc/cart_states.dart';
import 'package:grocermate/features/checkout/domain/entities/checkout_args.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

class CheckoutBar extends StatelessWidget {
  const CheckoutBar({super.key, required this.state});
  final CartState state;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                context.tr.total,
                color: context.appColors.surface5,
                fontSize: 12,
              ),
              AppText(
                (state.totals.total).formatMoney(),
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ],
          ),
          getSpaceWidth(context, 20),
          Expanded(
            child: AppButton(
              text: context.tr.checkout,
              onPressed: state.selectionMode
                  ? null
                  : () => context.push(
                      AppRoutes.checkout,
                      extra: CheckoutArgs(items: state.cart),
                    ),
              icon: LucideIcons.circlePoundSterling,
            ),
          ),
        ],
      ),
    );
  }
}
