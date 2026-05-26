// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'eQuran';

  @override
  String get suratList => 'Surah List';

  @override
  String get searchHint => 'Search surah...';

  @override
  String ayatCount(int count) {
    return '$count Verses';
  }

  @override
  String suratNumber(int nomor) {
    return 'Surah $nomor';
  }

  @override
  String get mekah => 'Makkah';

  @override
  String get madinah => 'Madinah';

  @override
  String get tafsir => 'Tafsir';

  @override
  String get lihatTafsir => 'View Tafsir';

  @override
  String get bookmark => 'Bookmark';

  @override
  String get bookmarkEmpty => 'No bookmarks yet.\nMark your favorite verses!';

  @override
  String get ayatTersimpan => 'Saved Verses';

  @override
  String get doaTersimpan => 'Saved Duas';

  @override
  String get doaBookmarkEmpty =>
      'No favorite duas yet.\nMark your favorite duas!';

  @override
  String get lastRead => 'Last Read';

  @override
  String get continueReading => 'Continue Reading';

  @override
  String ayat(int nomor) {
    return 'Verse $nomor';
  }

  @override
  String get errorNoInternet => 'No internet connection.';

  @override
  String get errorServer => 'A server error occurred.';

  @override
  String get errorUnknown => 'An unknown error occurred.';

  @override
  String get retry => 'Try Again';

  @override
  String get emptySearch => 'Surah not found.\nTry another keyword.';

  @override
  String get settings => 'Settings';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get language => 'Language';

  @override
  String get pilihQari => 'Select Qari';

  @override
  String get play => 'Play';

  @override
  String get pause => 'Pause';

  @override
  String get stop => 'Stop';

  @override
  String get tambahBookmark => 'Add Bookmark';

  @override
  String get hapusBookmark => 'Remove Bookmark';

  @override
  String get sebelumnya => 'Previous';

  @override
  String get selanjutnya => 'Next';

  @override
  String get bahasa => 'Language';

  @override
  String get indonesia => 'Indonesia';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get suratNav => 'Surah';

  @override
  String get doaNav => 'Dua';

  @override
  String get bookmarkNav => 'Bookmark';

  @override
  String get doa => 'Dua';

  @override
  String get doaList => 'Dua List';

  @override
  String get searchDoa => 'Search dua...';

  @override
  String get filterDoa => 'Filter Dua';

  @override
  String get filterByGrup => 'Filter by Group';

  @override
  String get filterByTag => 'Filter by Tag';

  @override
  String get allDoa => 'All Dua';

  @override
  String get arabicText => 'Arabic';

  @override
  String get transliteration => 'Latin';

  @override
  String get translation => 'Translation';

  @override
  String get about => 'About';

  @override
  String get tags => 'Tags';

  @override
  String get noDoaFound => 'Dua not found.\nTry another keyword.';

  @override
  String get clearFilter => 'Clear Filter';

  @override
  String get activeFilter => 'Active filter';

  @override
  String get applyFilter => 'Apply';

  @override
  String get imsakiyahNav => 'Imsakiyah';

  @override
  String get imsakiyah => 'Imsakiyah';

  @override
  String get pilihLokasi => 'Select Location';

  @override
  String get ubahLokasi => 'Change';

  @override
  String get pilihProvinsi => 'Select Province';

  @override
  String get cariProvinsi => 'Search province...';

  @override
  String get cariKabkota => 'Search city/regency...';

  @override
  String get hariIni => 'Today';

  @override
  String get jadwalBulanIni => 'This Month\'s Schedule';

  @override
  String get gagalMemuatData => 'Failed to load data';

  @override
  String get jadwalShalatNav => 'Prayer';

  @override
  String get jadwalShalat => 'Prayer Times';

  @override
  String get bulanSebelumnya => 'Previous Month';

  @override
  String get bulanBerikutnya => 'Next Month';
}
