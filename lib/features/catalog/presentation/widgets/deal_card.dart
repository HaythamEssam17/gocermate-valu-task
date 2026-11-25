import 'package:go_router/go_router.dart';
import 'package:grocermate/core/helpers/shared_functions.dart';
import 'package:grocermate/core/router/app_router.dart';
import 'package:grocermate/core/utils/extensions/context_extensions.dart';
import 'package:grocermate/core/utils/extensions/date_extensions.dart';
import 'package:grocermate/core/widgets/app_network_image.dart';
import 'package:grocermate/core/widgets/text_widgets/app_text.dart';
import 'package:grocermate/core/widgets/text_widgets/price_text.dart';
import 'package:grocermate/shared/widgets/cart_widgets/add_to_cart_button.dart';
import 'package:grocermate/features/catalog/domain/entities/deal.dart';
import 'package:material_ui/material_ui.dart';

class DealCard extends StatelessWidget {
  const DealCard({super.key, required this.deal});
  final DealEntity deal;

  @override
  Widget build(BuildContext context) {
    final p = deal.dealProduct;

    return SizedBox(
      width: 250,
      child: Material(
        color: context.appColors.background,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.push(AppRoutes.product, extra: p.id),
          child: Row(
            children: [
              SizedBox(
                width: 96,
                height: double.infinity,
                child: AppNetworkImage(p.image),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        p.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w700,
                      ),
                      getSpaceHeight(context, 4),
                      AppText(
                        (deal.endsAt).endsIn(),
                        color: context.appColors.error,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      const Spacer(),

                      PriceText(price: p.price, originalPrice: p.originalPrice),

                      getSpaceHeight(context, 4),
                      Align(
                        alignment: Alignment.centerRight,
                        child: AddToCartButton(product: p),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
