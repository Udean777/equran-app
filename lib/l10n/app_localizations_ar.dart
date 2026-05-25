// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'القرآن الكريم';

  @override
  String get suratList => 'قائمة السور';

  @override
  String get searchHint => 'ابحث عن سورة...';

  @override
  String ayatCount(int count) {
    return '$count آيات';
  }

  @override
  String suratNumber(int nomor) {
    return 'سورة $nomor';
  }

  @override
  String get mekah => 'مكة المكرمة';

  @override
  String get madinah => 'المدينة المنورة';

  @override
  String get tafsir => 'التفسير';

  @override
  String get lihatTafsir => 'عرض التفسير';

  @override
  String get bookmark => 'المفضلة';

  @override
  String get bookmarkEmpty =>
      'لا توجد إشارات مرجعية.\nضع علامة على آياتك المفضلة!';

  @override
  String get ayatTersimpan => 'الآيات المحفوظة';

  @override
  String get lastRead => 'آخر قراءة';

  @override
  String get continueReading => 'متابعة القراءة';

  @override
  String ayat(int nomor) {
    return 'الآية $nomor';
  }

  @override
  String get errorNoInternet => 'لا يوجد اتصال بالإنترنت.';

  @override
  String get errorServer => 'حدث خطأ في الخادم.';

  @override
  String get errorUnknown => 'حدث خطأ غير معروف.';

  @override
  String get retry => 'حاول مجدداً';

  @override
  String get emptySearch => 'لم يتم العثور على السورة.\nجرب كلمة أخرى.';

  @override
  String get settings => 'الإعدادات';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get lightMode => 'الوضع الفاتح';

  @override
  String get language => 'اللغة';

  @override
  String get pilihQari => 'اختر القارئ';

  @override
  String get play => 'تشغيل';

  @override
  String get pause => 'إيقاف مؤقت';

  @override
  String get stop => 'إيقاف';

  @override
  String get tambahBookmark => 'إضافة إشارة مرجعية';

  @override
  String get hapusBookmark => 'حذف الإشارة المرجعية';

  @override
  String get sebelumnya => 'السابق';

  @override
  String get selanjutnya => 'التالي';

  @override
  String get bahasa => 'اللغة';

  @override
  String get indonesia => 'Indonesia';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';
}
