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
  String ayatNumber(int number) {
    return 'آية $number';
  }

  @override
  String get bookmark => 'المفضلة';

  @override
  String get bookmarkEmpty =>
      'لا توجد إشارات مرجعية.\nضع علامة على آياتك المفضلة!';

  @override
  String get ayatTersimpan => 'الآيات المحفوظة';

  @override
  String get doaTersimpan => 'الأدعية المحفوظة';

  @override
  String get doaBookmarkEmpty =>
      'لا توجد أدعية مفضلة بعد.\nضع علامة على أدعيتك المفضلة!';

  @override
  String get lastRead => 'آخر قراءة';

  @override
  String get continueReading => 'متابعة القراءة';

  @override
  String ayat(int nomor) {
    return 'الآية $nomor';
  }

  @override
  String ayatFrom(int ayatNomor, int totalAyat) {
    return 'الآية $ayatNomor من $totalAyat';
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

  @override
  String get jadwalShalatNav => 'الصلاة';

  @override
  String get jadwalShalat => 'مواقيت الصلاة';

  @override
  String get bulanSebelumnya => 'الشهر السابق';

  @override
  String get bulanBerikutnya => 'الشهر التالي';

  @override
  String get tasbihNav => 'التسبيح';

  @override
  String get qiblaNav => 'القبلة';

  @override
  String get hafalanDrawer => 'حفظ القرآن';

  @override
  String get doaHarianDrawer => 'الأدعية اليومية';

  @override
  String get catatanDrawer => 'ملاحظاتي';

  @override
  String get statistikBacaDrawer => 'إحصائيات القراءة';

  @override
  String get statistikShalatDrawer => 'إحصائيات الصلاة';

  @override
  String get manajemenAudioDrawer => 'إدارة الصوت';

  @override
  String get pengaturanDrawer => 'الإعدادات';

  @override
  String get pageNotFound => 'الصفحة غير موجودة';

  @override
  String get pageNotFoundDesc =>
      'الصفحة التي تبحث عنها غير متوفرة\nأو تم نقلها.';

  @override
  String get backToHome => 'العودة إلى الصفحة الرئيسية';

  @override
  String get suratListHeader => 'قائمة السور';

  @override
  String totalSurat(int count) {
    return '$count سورة';
  }

  @override
  String get suratCompletedEmpty => 'لا توجد سور مكتملة بعد';

  @override
  String get suratInProgressEmpty => 'لا توجد سور قيد القراءة';

  @override
  String filterAll(int count) {
    return 'الكل ($count)';
  }

  @override
  String filterInProgress(int count) {
    return 'قيد القراءة ($count)';
  }

  @override
  String filterCompleted(int count) {
    return 'مكتملة ($count)';
  }

  @override
  String get filterReadingStatus => 'تصفية حالة القراءة';

  @override
  String get murajaahToday => 'مراجعة اليوم';

  @override
  String get start => 'ابدأ';

  @override
  String andMore(int count) {
    return '+$count أخرى';
  }

  @override
  String get tasbihTitle => 'تسبيح وذكر';

  @override
  String get tasbihHistory => 'التاريخ';

  @override
  String get tasbihHistoryTitle => 'تاريخ التسبيح';

  @override
  String get tasbihDeleteAllHistory => 'حذف كل التاريخ';

  @override
  String get tasbihEmptyHistory => 'لا يوجد تاريخ تسبيح بعد.';

  @override
  String get tasbihDeleteAllConfirmTitle => 'حذف كل التاريخ؟';

  @override
  String get tasbihDeleteAllConfirmMessage =>
      'سيتم حذف كل تاريخ التسبيح بشكل دائم.';

  @override
  String get tasbihCompleted => 'مكتمل';

  @override
  String get tasbihTarget => 'الهدف';

  @override
  String get tasbihRemaining => 'المتبقي';

  @override
  String get tasbihSelectDzikir => 'اختر الذكر';

  @override
  String get tasbihCustomTarget => 'هدف مخصص';

  @override
  String get tasbihCustomTargetHint => 'مثال: 200';

  @override
  String get tasbihSetButton => 'تعيين';

  @override
  String get tasbihChangeDzikir => 'تغيير الذكر';

  @override
  String get tasbihReset => 'إعادة ضبط';

  @override
  String get tasbihDelete => 'حذف';

  @override
  String get riwayatRekapShalatDrawer => 'تاريخ ملخص الصلاة';
}
