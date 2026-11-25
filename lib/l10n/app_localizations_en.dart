// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get lblAppName => 'Grocer Mate';

  @override
  String get lblLang => 'عربي';

  @override
  String get lblLanguage => 'Language';

  @override
  String get lblDefault => 'Default';

  @override
  String get lblTheme => 'Theme';

  @override
  String get lblRetry => 'Retry';

  @override
  String get lblWrongHappen => 'Something went wrong, please try again later';

  @override
  String get lblLoading => 'Loading...';

  @override
  String get lblDarkMode => 'Dark Mode';

  @override
  String get lblLightMode => 'Light Mode';

  @override
  String get lblSearch => 'Search';

  @override
  String get lblEGP => 'EGP';

  @override
  String get lblHome => 'Home';

  @override
  String get lblCart => 'Cart';

  @override
  String get lblServices => 'Services';

  @override
  String get lblOrders => 'Orders';

  @override
  String get lblNotifications => 'Notifications';

  @override
  String get youAreOffline =>
      'You are offline - showing saved data. Cart and orders still work until network restored.';

  @override
  String get backOnline => 'Back online - syncing your data';

  @override
  String get willBack => 'We will be right back';

  @override
  String get appUnderMaintenance =>
      'GrocerMate is under maintenance. Please try again in a few minutes.';

  @override
  String get checkAgain => 'Check again';

  @override
  String get orderQueued =>
      'Order queued. It will be sent when you are back online.';

  @override
  String get noItemsLeftToOrder => 'No items left to order.';

  @override
  String get checkout => 'Checkout';

  @override
  String get reviewQueuedOrder => 'Review queued order';

  @override
  String get orderWillQueued =>
      'You are offline. Your order will be queued and sent automatically when you reconnect.';

  @override
  String get reconnectToReviewOrder => 'Reconnect to review this order.';

  @override
  String get orderFailed => 'Order failed.';

  @override
  String get mockServerTools => 'Mock server tools';

  @override
  String get simulateOffline => 'Simulate offline';

  @override
  String get behavesExactlyLikeLosingConnection =>
      'Behaves exactly like losing the connection';

  @override
  String get randomRequestFailures => 'Random request failures';

  @override
  String get latency => 'Latency';

  @override
  String get fast => 'Fast';

  @override
  String get normal => 'Normal';

  @override
  String get slow => 'Slow';

  @override
  String get noDealsForNow => 'No deals for now.';

  @override
  String get dealsOfTheDay => 'Deals of the day';

  @override
  String get outOfStock => 'Out of stock.';

  @override
  String get items => 'Items';

  @override
  String get discount => 'Discount';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get tax => 'Tax';

  @override
  String get delivery => 'Delivery';

  @override
  String get free => 'Free';

  @override
  String get total => 'total';

  @override
  String addMoreForFreeDelivery(double count) {
    return 'Add $count more for free delivery.';
  }

  @override
  String onlyStockLeft(int stock) {
    return 'Only $stock left';
  }

  @override
  String get qty => 'Qty';

  @override
  String get moveToCart => 'Move to cart';

  @override
  String get saveForLater => 'Save for later';

  @override
  String cartCount(int count) {
    return 'Cart $count';
  }

  @override
  String selectedCount(int count) {
    return 'Selected $count';
  }

  @override
  String savedCount(int count) {
    return 'Saved $count';
  }

  @override
  String get myCart => 'My cart';

  @override
  String get yourCartIsEmpty => 'Your cart is empty';

  @override
  String get addSomeToGetStarted => 'Add some fresh groceries to get started.';

  @override
  String get browseProducts => 'Browse products';

  @override
  String get nothingSavedForLater => 'Nothing saved for later';

  @override
  String get moveItemsToSavedLater =>
      'Move items here from your cart to buy them another time.';

  @override
  String get failedToLoadProducts => 'Failed to load products.';

  @override
  String get noProducts => 'No products here yet';

  @override
  String get tryAnotherCategory => 'Try another category.';

  @override
  String get couldNotRefresh => 'Could not refresh - showing saved products.';

  @override
  String get youReachedTheEnd => 'You\'ve reached the end';

  @override
  String get failedToLoadCategories => 'Failed to load categories - retry';

  @override
  String get all => 'All';
}
