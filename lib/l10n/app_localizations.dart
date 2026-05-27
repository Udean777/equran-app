import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

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
    Locale('id'),
    Locale('en'),
    Locale('ar'),
  ];

  /// Judul aplikasi
  ///
  /// In id, this message translates to:
  /// **'eQuran'**
  String get appTitle;

  /// Judul halaman daftar surat
  ///
  /// In id, this message translates to:
  /// **'Daftar Surat'**
  String get suratList;

  /// Placeholder search bar
  ///
  /// In id, this message translates to:
  /// **'Cari surat...'**
  String get searchHint;

  /// Jumlah ayat
  ///
  /// In id, this message translates to:
  /// **'{count} Ayat'**
  String ayatCount(int count);

  /// Nomor surat
  ///
  /// In id, this message translates to:
  /// **'Surat {nomor}'**
  String suratNumber(int nomor);

  /// Label tempat turun Mekah
  ///
  /// In id, this message translates to:
  /// **'Mekah'**
  String get mekah;

  /// Label tempat turun Madinah
  ///
  /// In id, this message translates to:
  /// **'Madinah'**
  String get madinah;

  /// Label tafsir
  ///
  /// In id, this message translates to:
  /// **'Tafsir'**
  String get tafsir;

  /// Tombol lihat tafsir
  ///
  /// In id, this message translates to:
  /// **'Lihat Tafsir'**
  String get lihatTafsir;

  /// Label bookmark
  ///
  /// In id, this message translates to:
  /// **'Bookmark'**
  String get bookmark;

  /// Pesan kosong halaman bookmark
  ///
  /// In id, this message translates to:
  /// **'Belum ada bookmark.\nTandai ayat favoritmu!'**
  String get bookmarkEmpty;

  /// Judul section ayat tersimpan
  ///
  /// In id, this message translates to:
  /// **'Ayat Tersimpan'**
  String get ayatTersimpan;

  /// Judul section doa tersimpan
  ///
  /// In id, this message translates to:
  /// **'Doa Tersimpan'**
  String get doaTersimpan;

  /// Pesan kosong halaman bookmark doa
  ///
  /// In id, this message translates to:
  /// **'Belum ada doa favorit.\nTandai doa favoritmu!'**
  String get doaBookmarkEmpty;

  /// Label terakhir dibaca
  ///
  /// In id, this message translates to:
  /// **'Terakhir Dibaca'**
  String get lastRead;

  /// Label lanjutkan membaca
  ///
  /// In id, this message translates to:
  /// **'Lanjutkan Membaca'**
  String get continueReading;

  /// Label nomor ayat
  ///
  /// In id, this message translates to:
  /// **'Ayat {nomor}'**
  String ayat(int nomor);

  /// Pesan error tidak ada internet
  ///
  /// In id, this message translates to:
  /// **'Tidak ada koneksi internet.'**
  String get errorNoInternet;

  /// Pesan error server
  ///
  /// In id, this message translates to:
  /// **'Terjadi kesalahan pada server.'**
  String get errorServer;

  /// Pesan error tidak diketahui
  ///
  /// In id, this message translates to:
  /// **'Terjadi kesalahan yang tidak diketahui.'**
  String get errorUnknown;

  /// Tombol coba lagi
  ///
  /// In id, this message translates to:
  /// **'Coba Lagi'**
  String get retry;

  /// Pesan kosong hasil pencarian
  ///
  /// In id, this message translates to:
  /// **'Surat tidak ditemukan.\nCoba kata kunci lain.'**
  String get emptySearch;

  /// Label pengaturan
  ///
  /// In id, this message translates to:
  /// **'Pengaturan'**
  String get settings;

  /// Label mode gelap
  ///
  /// In id, this message translates to:
  /// **'Mode Gelap'**
  String get darkMode;

  /// Label mode terang
  ///
  /// In id, this message translates to:
  /// **'Mode Terang'**
  String get lightMode;

  /// Label bahasa
  ///
  /// In id, this message translates to:
  /// **'Bahasa'**
  String get language;

  /// Judul sheet pilih qari
  ///
  /// In id, this message translates to:
  /// **'Pilih Qari'**
  String get pilihQari;

  /// Tombol play audio
  ///
  /// In id, this message translates to:
  /// **'Play'**
  String get play;

  /// Tombol pause audio
  ///
  /// In id, this message translates to:
  /// **'Pause'**
  String get pause;

  /// Tombol stop audio
  ///
  /// In id, this message translates to:
  /// **'Stop'**
  String get stop;

  /// Tooltip tambah bookmark
  ///
  /// In id, this message translates to:
  /// **'Tambah Bookmark'**
  String get tambahBookmark;

  /// Tooltip hapus bookmark
  ///
  /// In id, this message translates to:
  /// **'Hapus Bookmark'**
  String get hapusBookmark;

  /// Label navigasi surat sebelumnya
  ///
  /// In id, this message translates to:
  /// **'Sebelumnya'**
  String get sebelumnya;

  /// Label navigasi surat selanjutnya
  ///
  /// In id, this message translates to:
  /// **'Selanjutnya'**
  String get selanjutnya;

  /// Label pilih bahasa
  ///
  /// In id, this message translates to:
  /// **'Bahasa'**
  String get bahasa;

  /// Nama bahasa Indonesia
  ///
  /// In id, this message translates to:
  /// **'Indonesia'**
  String get indonesia;

  /// Nama bahasa Inggris
  ///
  /// In id, this message translates to:
  /// **'English'**
  String get english;

  /// Nama bahasa Arab
  ///
  /// In id, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// Label tab navigasi surat
  ///
  /// In id, this message translates to:
  /// **'Surat'**
  String get suratNav;

  /// Label tab navigasi doa
  ///
  /// In id, this message translates to:
  /// **'Doa'**
  String get doaNav;

  /// Label tab navigasi bookmark
  ///
  /// In id, this message translates to:
  /// **'Bookmark'**
  String get bookmarkNav;

  /// Label fitur doa
  ///
  /// In id, this message translates to:
  /// **'Doa'**
  String get doa;

  /// Judul halaman daftar doa
  ///
  /// In id, this message translates to:
  /// **'Daftar Doa'**
  String get doaList;

  /// Placeholder search bar doa
  ///
  /// In id, this message translates to:
  /// **'Cari doa...'**
  String get searchDoa;

  /// Judul sheet filter doa
  ///
  /// In id, this message translates to:
  /// **'Filter Doa'**
  String get filterDoa;

  /// Label filter by grup
  ///
  /// In id, this message translates to:
  /// **'Filter by Grup'**
  String get filterByGrup;

  /// Label filter by tag
  ///
  /// In id, this message translates to:
  /// **'Filter by Tag'**
  String get filterByTag;

  /// Label semua doa
  ///
  /// In id, this message translates to:
  /// **'Semua Doa'**
  String get allDoa;

  /// Label teks arab
  ///
  /// In id, this message translates to:
  /// **'Arab'**
  String get arabicText;

  /// Label transliterasi
  ///
  /// In id, this message translates to:
  /// **'Latin'**
  String get transliteration;

  /// Label terjemahan
  ///
  /// In id, this message translates to:
  /// **'Terjemahan'**
  String get translation;

  /// Label tentang
  ///
  /// In id, this message translates to:
  /// **'Tentang'**
  String get about;

  /// Label tag
  ///
  /// In id, this message translates to:
  /// **'Tag'**
  String get tags;

  /// Pesan kosong hasil pencarian doa
  ///
  /// In id, this message translates to:
  /// **'Doa tidak ditemukan.\nCoba kata kunci lain.'**
  String get noDoaFound;

  /// Tombol hapus filter
  ///
  /// In id, this message translates to:
  /// **'Hapus Filter'**
  String get clearFilter;

  /// Label filter aktif
  ///
  /// In id, this message translates to:
  /// **'Filter aktif'**
  String get activeFilter;

  /// Tombol terapkan filter
  ///
  /// In id, this message translates to:
  /// **'Terapkan'**
  String get applyFilter;

  /// Label tab navigasi imsakiyah
  ///
  /// In id, this message translates to:
  /// **'Imsakiyah'**
  String get imsakiyahNav;

  /// Label fitur imsakiyah
  ///
  /// In id, this message translates to:
  /// **'Imsakiyah'**
  String get imsakiyah;

  /// Tombol pilih lokasi
  ///
  /// In id, this message translates to:
  /// **'Pilih Lokasi'**
  String get pilihLokasi;

  /// Tombol ubah lokasi
  ///
  /// In id, this message translates to:
  /// **'Ubah'**
  String get ubahLokasi;

  /// Judul sheet pilih provinsi
  ///
  /// In id, this message translates to:
  /// **'Pilih Provinsi'**
  String get pilihProvinsi;

  /// Placeholder cari provinsi
  ///
  /// In id, this message translates to:
  /// **'Cari provinsi...'**
  String get cariProvinsi;

  /// Placeholder cari kab/kota
  ///
  /// In id, this message translates to:
  /// **'Cari kab/kota...'**
  String get cariKabkota;

  /// Label hari ini
  ///
  /// In id, this message translates to:
  /// **'Hari Ini'**
  String get hariIni;

  /// Label jadwal bulan ini
  ///
  /// In id, this message translates to:
  /// **'Jadwal Bulan Ini'**
  String get jadwalBulanIni;

  /// Pesan gagal memuat data
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat data'**
  String get gagalMemuatData;

  /// Label tab navigasi jadwal shalat
  ///
  /// In id, this message translates to:
  /// **'Shalat'**
  String get jadwalShalatNav;

  /// Label fitur jadwal shalat
  ///
  /// In id, this message translates to:
  /// **'Jadwal Shalat'**
  String get jadwalShalat;

  /// Tooltip navigasi bulan sebelumnya
  ///
  /// In id, this message translates to:
  /// **'Bulan Sebelumnya'**
  String get bulanSebelumnya;

  /// Tooltip navigasi bulan berikutnya
  ///
  /// In id, this message translates to:
  /// **'Bulan Berikutnya'**
  String get bulanBerikutnya;

  /// Label tab navigasi tasbih
  ///
  /// In id, this message translates to:
  /// **'Tasbih'**
  String get tasbihNav;

  /// Label tab navigasi qibla
  ///
  /// In id, this message translates to:
  /// **'Qibla'**
  String get qiblaNav;

  /// Label menu drawer hafalan
  ///
  /// In id, this message translates to:
  /// **'Hafalan Quran'**
  String get hafalanDrawer;

  /// Label menu drawer doa harian
  ///
  /// In id, this message translates to:
  /// **'Doa Harian'**
  String get doaHarianDrawer;

  /// Label menu drawer catatan
  ///
  /// In id, this message translates to:
  /// **'Catatan Saya'**
  String get catatanDrawer;

  /// Label menu drawer statistik baca
  ///
  /// In id, this message translates to:
  /// **'Statistik Baca'**
  String get statistikBacaDrawer;

  /// Label menu drawer statistik shalat
  ///
  /// In id, this message translates to:
  /// **'Statistik Shalat'**
  String get statistikShalatDrawer;

  /// Label menu drawer manajemen audio
  ///
  /// In id, this message translates to:
  /// **'Manajemen Audio'**
  String get manajemenAudioDrawer;

  /// Label menu drawer pengaturan
  ///
  /// In id, this message translates to:
  /// **'Pengaturan'**
  String get pengaturanDrawer;
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
      <String>['ar', 'en', 'id'].contains(locale.languageCode);

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
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
