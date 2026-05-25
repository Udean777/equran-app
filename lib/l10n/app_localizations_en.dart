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
}
