import 'package:equatable/equatable.dart';

class AppFlags extends Equatable {
  final bool showDeals;
  final bool enablePriceRevalidation;
  final double taxRate;
  final String currency;
  final double deliveryFee;
  final double freeDeliveryThreshold;
  final int searchDebounceMs;
  final bool enableSavedForLater;
  final bool maintenanceMode;

  const AppFlags({
    this.showDeals = true,
    this.enablePriceRevalidation = true,
    this.taxRate = 0.05,
    this.currency = 'EGP',
    this.deliveryFee = 1.0,
    this.freeDeliveryThreshold = 25.0,
    this.searchDebounceMs = 1000,
    this.enableSavedForLater = true,
    this.maintenanceMode = false,
  });

  factory AppFlags.fromJson(Map<String, dynamic> j) => AppFlags(
    showDeals: j['show_deals'] as bool? ?? true,
    enablePriceRevalidation: j['enable_price_revalidation'] as bool? ?? true,
    taxRate: (j['tax_rate'] as num?)?.toDouble() ?? 0.05,
    currency: j['currency'] as String? ?? 'EGP',
    deliveryFee: (j['delivery_fee'] as num?)?.toDouble() ?? 1.0,
    freeDeliveryThreshold:
        (j['free_delivery_threshold'] as num?)?.toDouble() ?? 25.0,
    searchDebounceMs: (j['search_debounce_ms'] as num?)?.toInt() ?? 1000,
    enableSavedForLater: j['enable_saved_for_later'] as bool? ?? true,
    maintenanceMode: j['maintenance_mode'] as bool? ?? false,
  );

  @override
  List<Object?> get props => [
    showDeals,
    enablePriceRevalidation,
    taxRate,
    currency,
    deliveryFee,
    freeDeliveryThreshold,
    searchDebounceMs,
    enableSavedForLater,
    maintenanceMode,
  ];
}
