import 'package:go_router/go_router.dart';
import 'package:grocermate/core/utils/extensions/context_extensions.dart';
import 'package:grocermate/core/widgets/app_card.dart';
import 'package:grocermate/core/widgets/text_widgets/app_text.dart';
import 'package:grocermate/features/products/domain/entities/product_entity.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../shared/widgets/cart_widgets/add_to_cart_button.dart';
import 'product_badges.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});
  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      onTap: () => context.push(AppRoutes.product, extra: product.id),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 4 / 3,
            child: Stack(
              fit: StackFit.expand,
              children: [
                AppNetworkImage(product.image),
                if (product.isOutOfStock)
                  ColoredBox(
                    color: Colors.black54,
                    child: Center(
                      child: AppText(
                        'Out of stock',
                        color: context.appColors.white.withAlpha(240),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                Positioned(
                  left: 8,
                  top: 8,
                  right: 8,
                  child: ProductBadges(product),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
            child: AppText(
              product.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.w700,
              fontSize: 14,
              height: 1.2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 2, 10, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AppText(
                    product.brand,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    fontSize: 12,
                    color: context.textColors.lightText,
                  ),
                ),
                Icon(
                  Icons.star_rounded,
                  size: 14,
                  color: context.appColors.warning,
                ),
                AppText(product.rating.toStringAsFixed(1), fontSize: 12),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(8),
            child: AddToCartButton(product: product),
          ),
        ],
      ),
    );
  }
}
