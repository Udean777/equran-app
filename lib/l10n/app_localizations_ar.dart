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

  @override
  String get suratNav => 'السور';

  @override
  String get doaNav => 'الأدعية';

  @override
  String get bookmarkNav => 'المفضلة';

  @override
  String get doa => 'الأدعية';

  @override
  String get doaList => 'قائمة الأدعية';

  @override
  String get searchDoa => 'ابحث عن دعاء...';

  @override
  String get filterDoa => 'تصفية الأدعية';

  @override
  String get filterByGrup => 'تصفية حسب المجموعة';

  @override
  String get filterByTag => 'تصفية حسب الوسم';

  @override
  String get allDoa => 'جميع الأدعية';

  @override
  String get arabicText => 'عربي';

  @override
  String get transliteration => 'لاتيني';

  @override
  String get translation => 'الترجمة';

  @override
  String get about => 'حول';

  @override
  String get tags => 'الوسوم';

  @override
  String get noDoaFound => 'لم يتم العثور على الدعاء.\nجرب كلمة أخرى.';

  @override
  String get clearFilter => 'مسح التصفية';

  @override
  String get activeFilter => 'تصفية نشطة';

  @override
  String get applyFilter => 'تطبيق';

  @override
  String get imsakiyahNav => 'الإمساكية';

  @override
  String get imsakiyah => 'الإمساكية';

  @override
  String get pilihLokasi => 'اختر الموقع';

  @override
  String get ubahLokasi => 'تغيير';

  @override
  String get pilihProvinsi => 'اختر المحافظة';

  @override
  String get cariProvinsi => 'ابحث عن محافظة...';

  @override
  String get cariKabkota => 'ابحث عن مدينة...';

  @override
  String get hariIni => 'اليوم';

  @override
  String get jadwalBulanIni => 'جدول هذا الشهر';

  @override
  String get gagalMemuatData => 'فشل تحميل البيانات';
}
