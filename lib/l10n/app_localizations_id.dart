// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'eQuran';

  @override
  String get suratList => 'Daftar Surat';

  @override
  String get searchHint => 'Cari surat...';

  @override
  String ayatCount(int count) {
    return '$count Ayat';
  }

  @override
  String suratNumber(int nomor) {
    return 'Surat $nomor';
  }

  @override
  String get mekah => 'Mekah';

  @override
  String get madinah => 'Madinah';

  @override
  String get tafsir => 'Tafsir';

  @override
  String get lihatTafsir => 'Lihat Tafsir';

  @override
  String get bookmark => 'Bookmark';

  @override
  String get bookmarkEmpty => 'Belum ada bookmark.\nTandai ayat favoritmu!';

  @override
  String get ayatTersimpan => 'Ayat Tersimpan';

  @override
  String get lastRead => 'Terakhir Dibaca';

  @override
  String get continueReading => 'Lanjutkan Membaca';

  @override
  String ayat(int nomor) {
    return 'Ayat $nomor';
  }

  @override
  String get errorNoInternet => 'Tidak ada koneksi internet.';

  @override
  String get errorServer => 'Terjadi kesalahan pada server.';

  @override
  String get errorUnknown => 'Terjadi kesalahan yang tidak diketahui.';

  @override
  String get retry => 'Coba Lagi';

  @override
  String get emptySearch => 'Surat tidak ditemukan.\nCoba kata kunci lain.';

  @override
  String get settings => 'Pengaturan';

  @override
  String get darkMode => 'Mode Gelap';

  @override
  String get lightMode => 'Mode Terang';

  @override
  String get language => 'Bahasa';

  @override
  String get pilihQari => 'Pilih Qari';

  @override
  String get play => 'Play';

  @override
  String get pause => 'Pause';

  @override
  String get stop => 'Stop';

  @override
  String get tambahBookmark => 'Tambah Bookmark';

  @override
  String get hapusBookmark => 'Hapus Bookmark';

  @override
  String get sebelumnya => 'Sebelumnya';

  @override
  String get selanjutnya => 'Selanjutnya';

  @override
  String get bahasa => 'Bahasa';

  @override
  String get indonesia => 'Indonesia';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';
}
