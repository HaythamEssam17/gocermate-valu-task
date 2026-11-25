// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get lblAppName => 'Grocer Mate';

  @override
  String get lblLang => 'English';

  @override
  String get lblLanguage => 'اللغة';

  @override
  String get lblDefault => 'الافتراضية';

  @override
  String get lblTheme => 'المظهر';

  @override
  String get lblRetry => 'حاول مرة اخري';

  @override
  String get lblWrongHappen => 'حدث خطأ ما، الرجاء المحاولة في وقت لاحق';

  @override
  String get lblLoading => 'تحميل...';

  @override
  String get lblDarkMode => 'الوضع الداكن';

  @override
  String get lblLightMode => 'الوضع المضيء';

  @override
  String get lblSearch => 'بحث';

  @override
  String get lblEGP => 'ج.م';

  @override
  String get lblHome => 'الرئيسية';

  @override
  String get lblCart => 'السلة';

  @override
  String get lblServices => 'الخدمات';

  @override
  String get lblOrders => 'الطلبات';

  @override
  String get lblNotifications => 'الإشعارات';

  @override
  String get youAreOffline =>
      'أنت غير متصل - تظهر البيانات المحفوظة. السلة والطلبات لا تزال تعمل حتي عودة الإتصال.';

  @override
  String get backOnline => 'تمت الاتصال بالإنترنت - جاري مزامنة بياناتك';

  @override
  String get willBack => 'سيتم العودة لاحقا';

  @override
  String get appUnderMaintenance =>
      'GrocerMate قيد الصيانة. يرجى المحاولة مجدداً بعد بضع دقائق.';

  @override
  String get checkAgain => 'تحقق مجددًا';

  @override
  String get orderQueued =>
      'تم اضافة الطلب في قائمة الانتظار. سيتم إرساله عند عودتك للاتصال بالإنترنت.';

  @override
  String get noItemsLeftToOrder => 'لا يوجد عناصر للطلب.';

  @override
  String get checkout => 'الدفع';

  @override
  String get reviewQueuedOrder => 'مراجعة الطلب في قائمة الانتظار';

  @override
  String get orderWillQueued =>
      'أنت غير متصل. سيتم وضع طلبك في قائمة الانتظار وإرساله تلقائيًا عند إعادة الاتصال.';

  @override
  String get reconnectToReviewOrder => 'أعد الاتصال لمراجعة هذا الطلب.';

  @override
  String get orderFailed => 'فشل الطلب.';

  @override
  String get mockServerTools => 'محاكاة أدوات الخادم';

  @override
  String get simulateOffline => 'المحاكاة دون اتصال بالإنترنت';

  @override
  String get behavesExactlyLikeLosingConnection => '';

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
  String get noDealsForNow => 'لا توجد عروض في الوقت الحالي.';

  @override
  String get dealsOfTheDay => 'عروض اليوم';

  @override
  String get outOfStock => 'غير متوفر في المخزن.';

  @override
  String get items => 'العناصر';

  @override
  String get discount => 'الخصم';

  @override
  String get subtotal => 'المجموع';

  @override
  String get tax => 'الضريبة';

  @override
  String get delivery => 'التوصيل';

  @override
  String get free => 'مجاني';

  @override
  String get total => 'الإجمالي';

  @override
  String addMoreForFreeDelivery(double count) {
    return 'أضف $count منتجًا إضافيًا للحصول على التوصيل المجاني.';
  }

  @override
  String onlyStockLeft(int stock) {
    return 'متبقي $stock فقط';
  }

  @override
  String get qty => 'الكمية';

  @override
  String get moveToCart => 'إضافة إلى السلة';

  @override
  String get saveForLater => 'حفظ لوقت لاحق';

  @override
  String cartCount(int count) {
    return 'السلة $count';
  }

  @override
  String selectedCount(int count) {
    return 'تم اختيار $count';
  }

  @override
  String savedCount(int count) {
    return 'تم حفظ $count';
  }

  @override
  String get myCart => 'السلة';

  @override
  String get yourCartIsEmpty => 'السلة فارغة';

  @override
  String get addSomeToGetStarted => 'أضف بعض المواد الغذائية الطازجة لتبدأ.';

  @override
  String get browseProducts => 'تصفح المنتجات';

  @override
  String get nothingSavedForLater => 'لا يوجد ما تم حفظه للاطلاع عليه لاحقًا';

  @override
  String get moveItemsToSavedLater =>
      'انقل المنتجات من سلة التسوق إلى هنا لشرائها في وقت لاحق.';

  @override
  String get failedToLoadProducts => 'فشل في تحميل المنتجات';

  @override
  String get noProducts => 'لا توجد منتجات هنا حتى الآن';

  @override
  String get tryAnotherCategory => 'جرب فئة أخرى.';

  @override
  String get couldNotRefresh => 'تعذر التحديث - يتم عرض المنتجات المحفوظة.';

  @override
  String get youReachedTheEnd => 'لقد وصلت إلى النهاية';

  @override
  String get failedToLoadCategories => 'فشل تحميل التصنيفات - إعادة المحاولة';

  @override
  String get all => 'الكل';
}
