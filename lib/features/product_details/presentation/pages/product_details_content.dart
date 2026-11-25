import 'package:grocermate/core/helpers/shared_functions.dart';
import 'package:grocermate/core/utils/extensions/context_extensions.dart';
import 'package:grocermate/core/widgets/app_card.dart';
import 'package:grocermate/core/widgets/app_network_image.dart';
import 'package:grocermate/core/widgets/text_widgets/app_section_header.dart';
import 'package:grocermate/core/widgets/text_widgets/app_text.dart';
import 'package:grocermate/core/widgets/text_widgets/price_text.dart';
import 'package:grocermate/features/product_details/presentation/bloc/product_details_states.dart';
import 'package:grocermate/features/product_details/presentation/widgets/add_to_cart_widget.dart';
import 'package:grocermate/features/product_details/presentation/widgets/price_history_chart.dart';
import 'package:grocermate/features/products/presentation/widgets/product_card.dart';
import 'package:material_ui/material_ui.dart';

class ProductDetailsContent extends StatefulWidget {
  const ProductDetailsContent({super.key, required this.state});

  final ProductDetailsState state;

  @override
  State<ProductDetailsContent> createState() => _ProductDetailsContentState();
}

class _ProductDetailsContentState extends State<ProductDetailsContent> {
  final _page = PageController();
  int _index = 0;
  int _qty = 1;

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  static const _units = {
    'calories': 'kcal',
    'protein': 'g',
    'fat': 'g',
    'carbs': 'g',
    'fiber': 'g',
    'sugar': 'g',
    'vitaminC': 'mg',
  };

  @override
  Widget build(BuildContext context) {
    final s = widget.state;
    final d = s.details!;
    final p = d.product;
    final stock = s.inventory?.stock ?? p.stock;

    final stockText = stock <= 0
        ? 'Out of stock'
        : stock <= 10
        ? 'Only $stock left'
        : 'In stock';

    final stockBgColor = stock <= 0
        ? context.appColors.errorBg
        : stock <= 10
        ? context.appColors.warningBg
        : context.appColors.successBg;

    final stockTextColor = stock <= 0
        ? context.appColors.error
        : stock <= 10
        ? context.appColors.warning
        : context.appColors.success;

    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              if (s.fromCache)
                AppCard(
                  color: context.appColors.warningBg,
                  child: const AppText(
                    'Showing a saved copy of this product',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              SizedBox(
                height: 280,
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: _page,
                      itemCount: d.images.length,
                      onPageChanged: (i) => setState(() => _index = i),
                      itemBuilder: (_, i) => AppNetworkImage(d.images[i]),
                    ),
                    if (d.images.length > 1)
                      Positioned(
                        bottom: 10,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (var i = 0; i < d.images.length; i++)
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 3,
                                ),
                                width: i == _index ? 18 : 7,
                                height: 7,
                                decoration: BoxDecoration(
                                  color: i == _index
                                      ? context.appColors.primary
                                      : context.appColors.white.withValues(
                                          alpha: 0.7,
                                        ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(p.title, fontSize: 12, fontWeight: FontWeight.w800),
                    getSpaceHeight(context, 4),
                    Row(
                      children: [
                        AppText(p.brand, color: context.appColors.primaryBg),
                        getSpaceHeight(context, 12),
                        Icon(
                          Icons.star_rounded,
                          size: 18,
                          color: context.appColors.warning,
                        ),
                        AppText(p.rating.toStringAsFixed(1)),
                      ],
                    ),
                    getSpaceHeight(context, 12),
                    Row(
                      children: [
                        PriceText(
                          price: p.price,
                          originalPrice: p.originalPrice,
                          large: true,
                        ),
                        if (p.hasDiscount) ...[
                          getSpaceWidth(context, 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: context.appColors.error,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: AppText(
                              '-${p.discountPercent}%',
                              color: context.appColors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                            ),
                          ),
                        ],
                        const Spacer(),
                        Chip(
                          label: AppText(stockText),
                          labelStyle: TextStyle(
                            color: stockTextColor,
                            fontWeight: FontWeight.w700,
                          ),
                          side: BorderSide(color: stockTextColor),
                          backgroundColor: stockBgColor,
                        ),
                      ],
                    ),
                    if (s.inventory != null && stock <= 0)
                      AppText(
                        s.inventory!.backorderable
                            ? 'Available on backorder in about ${s.inventory!.etaDays} days'
                            : 'Not available for backorder',
                      ),

                    const AppSectionHeader(title: 'About this product'),
                    AppText(d.description, height: 1.4),

                    if (d.nutrition.isNotEmpty) ...[
                      const AppSectionHeader(title: 'Nutrition (per serving)'),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final e in d.nutrition.entries)
                            AppCard(
                              child: Column(
                                children: [
                                  AppText(
                                    '${e.value} ${_units[e.key] ?? ''}',
                                    fontWeight: FontWeight.w800,
                                  ),
                                  AppText(e.key, fontSize: 10),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                    const AppSectionHeader(title: 'Allergens'),

                    if (d.allergens.isEmpty)
                      const AppText('No known allergens')
                    else
                      Wrap(
                        spacing: 8,
                        children: [
                          for (final a in d.allergens)
                            Chip(
                              avatar: const Icon(
                                Icons.warning_amber_rounded,
                                size: 18,
                              ),
                              label: Text(a),
                            ),
                        ],
                      ),
                    if (s.history != null && s.history!.prices.length > 1) ...[
                      const AppSectionHeader(title: 'Price history'),
                      PriceHistoryChart(prices: s.history!.prices),
                    ],
                  ],
                ),
              ),
              if (s.related.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: AppText(
                    'You may also like',
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(
                  height: 270,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: s.related.length,
                    separatorBuilder: (_, _) => getSpaceWidth(context, 12),
                    itemBuilder: (_, i) => SizedBox(
                      width: 165,
                      child: ProductCard(product: s.related[i]),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        getSpaceHeight(context, 16),

        AddToCartWidget(
          product: p.copyWith(stock: stock),
          qty: _qty,
          onQty: (q) => setState(() => _qty = q),
        ),
      ],
    );
  }
}
