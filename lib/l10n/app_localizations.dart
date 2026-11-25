import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @lblAppName.
  ///
  /// In en, this message translates to:
  /// **'Grocer Mate'**
  String get lblAppName;

  /// No description provided for @lblLang.
  ///
  /// In en, this message translates to:
  /// **'عربي'**
  String get lblLang;

  /// No description provided for @lblLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get lblLanguage;

  /// No description provided for @lblDefault.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get lblDefault;

  /// No description provided for @lblTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get lblTheme;

  /// No description provided for @lblRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get lblRetry;

  /// No description provided for @lblWrongHappen.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong, please try again later'**
  String get lblWrongHappen;

  /// No description provided for @lblLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get lblLoading;

  /// No description provided for @lblDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get lblDarkMode;

  /// No description provided for @lblLightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lblLightMode;

  /// No description provided for @lblSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get lblSearch;

  /// No description provided for @lblEGP.
  ///
  /// In en, this message translates to:
  /// **'EGP'**
  String get lblEGP;

  /// No description provided for @lblHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get lblHome;

  /// No description provided for @lblCart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get lblCart;

  /// No description provided for @lblServices.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get lblServices;

  /// No description provided for @lblOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get lblOrders;

  /// No description provided for @lblNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get lblNotifications;

  /// No description provided for @youAreOffline.
  ///
  /// In en, this message translates to:
  /// **'You are offline - showing saved data. Cart and orders still work until network restored.'**
  String get youAreOffline;

  /// No description provided for @backOnline.
  ///
  /// In en, this message translates to:
  /// **'Back online - syncing your data'**
  String get backOnline;

  /// No description provided for @willBack.
  ///
  /// In en, this message translates to:
  /// **'We will be right back'**
  String get willBack;

  /// No description provided for @appUnderMaintenance.
  ///
  /// In en, this message translates to:
  /// **'GrocerMate is under maintenance. Please try again in a few minutes.'**
  String get appUnderMaintenance;

  /// No description provided for @checkAgain.
  ///
  /// In en, this message translates to:
  /// **'Check again'**
  String get checkAgain;

  /// No description provided for @orderQueued.
  ///
  /// In en, this message translates to:
  /// **'Order queued. It will be sent when you are back online.'**
  String get orderQueued;

  /// No description provided for @noItemsLeftToOrder.
  ///
  /// In en, this message translates to:
  /// **'No items left to order.'**
  String get noItemsLeftToOrder;

  /// No description provided for @checkout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// No description provided for @reviewQueuedOrder.
  ///
  /// In en, this message translates to:
  /// **'Review queued order'**
  String get reviewQueuedOrder;

  /// No description provided for @orderWillQueued.
  ///
  /// In en, this message translates to:
  /// **'You are offline. Your order will be queued and sent automatically when you reconnect.'**
  String get orderWillQueued;

  /// No description provided for @reconnectToReviewOrder.
  ///
  /// In en, this message translates to:
  /// **'Reconnect to review this order.'**
  String get reconnectToReviewOrder;

  /// No description provided for @orderFailed.
  ///
  /// In en, this message translates to:
  /// **'Order failed.'**
  String get orderFailed;

  /// No description provided for @mockServerTools.
  ///
  /// In en, this message translates to:
  /// **'Mock server tools'**
  String get mockServerTools;

  /// No description provided for @simulateOffline.
  ///
  /// In en, this message translates to:
  /// **'Simulate offline'**
  String get simulateOffline;

  /// No description provided for @behavesExactlyLikeLosingConnection.
  ///
  /// In en, this message translates to:
  /// **'Behaves exactly like losing the connection'**
  String get behavesExactlyLikeLosingConnection;

  /// No description provided for @randomRequestFailures.
  ///
  /// In en, this message translates to:
  /// **'Random request failures'**
  String get randomRequestFailures;

  /// No description provided for @latency.
  ///
  /// In en, this message translates to:
  /// **'Latency'**
  String get latency;

  /// No description provided for @fast.
  ///
  /// In en, this message translates to:
  /// **'Fast'**
  String get fast;

  /// No description provided for @normal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normal;

  /// No description provided for @slow.
  ///
  /// In en, this message translates to:
  /// **'Slow'**
  String get slow;

  /// No description provided for @noDealsForNow.
  ///
  /// In en, this message translates to:
  /// **'No deals for now.'**
  String get noDealsForNow;

  /// No description provided for @dealsOfTheDay.
  ///
  /// In en, this message translates to:
  /// **'Deals of the day'**
  String get dealsOfTheDay;

  /// No description provided for @outOfStock.
  ///
  /// In en, this message translates to:
  /// **'Out of stock.'**
  String get outOfStock;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get items;

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @tax.
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get tax;

  /// No description provided for @delivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get delivery;

  /// No description provided for @free.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get free;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'total'**
  String get total;

  /// No description provided for @addMoreForFreeDelivery.
  ///
  /// In en, this message translates to:
  /// **'Add {count} more for free delivery.'**
  String addMoreForFreeDelivery(double count);

  /// No description provided for @onlyStockLeft.
  ///
  /// In en, this message translates to:
  /// **'Only {stock} left'**
  String onlyStockLeft(int stock);

  /// No description provided for @qty.
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get qty;

  /// No description provided for @moveToCart.
  ///
  /// In en, this message translates to:
  /// **'Move to cart'**
  String get moveToCart;

  /// No description provided for @saveForLater.
  ///
  /// In en, this message translates to:
  /// **'Save for later'**
  String get saveForLater;

  /// No description provided for @cartCount.
  ///
  /// In en, this message translates to:
  /// **'Cart {count}'**
  String cartCount(int count);

  /// No description provided for @selectedCount.
  ///
  /// In en, this message translates to:
  /// **'Selected {count}'**
  String selectedCount(int count);

  /// No description provided for @savedCount.
  ///
  /// In en, this message translates to:
  /// **'Saved {count}'**
  String savedCount(int count);

  /// No description provided for @myCart.
  ///
  /// In en, this message translates to:
  /// **'My cart'**
  String get myCart;

  /// No description provided for @yourCartIsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get yourCartIsEmpty;

  /// No description provided for @addSomeToGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Add some fresh groceries to get started.'**
  String get addSomeToGetStarted;

  /// No description provided for @browseProducts.
  ///
  /// In en, this message translates to:
  /// **'Browse products'**
  String get browseProducts;

  /// No description provided for @nothingSavedForLater.
  ///
  /// In en, this message translates to:
  /// **'Nothing saved for later'**
  String get nothingSavedForLater;

  /// No description provided for @moveItemsToSavedLater.
  ///
  /// In en, this message translates to:
  /// **'Move items here from your cart to buy them another time.'**
  String get moveItemsToSavedLater;

  /// No description provided for @failedToLoadProducts.
  ///
  /// In en, this message translates to:
  /// **'Failed to load products.'**
  String get failedToLoadProducts;

  /// No description provided for @noProducts.
  ///
  /// In en, this message translates to:
  /// **'No products here yet'**
  String get noProducts;

  /// No description provided for @tryAnotherCategory.
  ///
  /// In en, this message translates to:
  /// **'Try another category.'**
  String get tryAnotherCategory;

  /// No description provided for @couldNotRefresh.
  ///
  /// In en, this message translates to:
  /// **'Could not refresh - showing saved products.'**
  String get couldNotRefresh;

  /// No description provided for @youReachedTheEnd.
  ///
  /// In en, this message translates to:
  /// **'You\'ve reached the end'**
  String get youReachedTheEnd;

  /// No description provided for @failedToLoadCategories.
  ///
  /// In en, this message translates to:
  /// **'Failed to load categories - retry'**
  String get failedToLoadCategories;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
