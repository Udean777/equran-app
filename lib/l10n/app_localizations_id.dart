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
  String ayatNumber(int number) {
    return 'Ayat $number';
  }

  @override
  String get bookmark => 'Bookmark';

  @override
  String get bookmarkEmpty => 'Belum ada bookmark.\nTandai ayat favoritmu!';

  @override
  String get ayatTersimpan => 'Ayat Tersimpan';

  @override
  String get doaTersimpan => 'Doa Tersimpan';

  @override
  String get doaBookmarkEmpty =>
      'Belum ada doa favorit.\nTandai doa favoritmu!';

  @override
  String get lastRead => 'Terakhir Dibaca';

  @override
  String get continueReading => 'Lanjutkan Membaca';

  @override
  String ayat(int nomor) {
    return 'Ayat $nomor';
  }

  @override
  String ayatFrom(int ayatNomor, int totalAyat) {
    return 'Ayat $ayatNomor dari $totalAyat';
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

  @override
  String get suratNav => 'Surat';

  @override
  String get doaNav => 'Doa';

  @override
  String get bookmarkNav => 'Bookmark';

  @override
  String get doa => 'Doa';

  @override
  String get doaList => 'Daftar Doa';

  @override
  String get searchDoa => 'Cari doa...';

  @override
  String get filterDoa => 'Filter Doa';

  @override
  String get filterByGrup => 'Filter by Grup';

  @override
  String get filterByTag => 'Filter by Tag';

  @override
  String get allDoa => 'Semua Doa';

  @override
  String get arabicText => 'Arab';

  @override
  String get transliteration => 'Latin';

  @override
  String get translation => 'Terjemahan';

  @override
  String get about => 'Tentang';

  @override
  String get tags => 'Tag';

  @override
  String get noDoaFound => 'Doa tidak ditemukan.\nCoba kata kunci lain.';

  @override
  String get clearFilter => 'Hapus Filter';

  @override
  String get activeFilter => 'Filter aktif';

  @override
  String get applyFilter => 'Terapkan';

  @override
  String get imsakiyahNav => 'Imsakiyah';

  @override
  String get imsakiyah => 'Imsakiyah';

  @override
  String get pilihLokasi => 'Pilih Lokasi';

  @override
  String get ubahLokasi => 'Ubah';

  @override
  String get pilihProvinsi => 'Pilih Provinsi';

  @override
  String get cariProvinsi => 'Cari provinsi...';

  @override
  String get cariKabkota => 'Cari kab/kota...';

  @override
  String get hariIni => 'Hari Ini';

  @override
  String get jadwalBulanIni => 'Jadwal Bulan Ini';

  @override
  String get gagalMemuatData => 'Gagal memuat data';

  @override
  String get jadwalShalatNav => 'Shalat';

  @override
  String get jadwalShalat => 'Jadwal Shalat';

  @override
  String get bulanSebelumnya => 'Bulan Sebelumnya';

  @override
  String get bulanBerikutnya => 'Bulan Berikutnya';

  @override
  String get tasbihNav => 'Tasbih';

  @override
  String get qiblaNav => 'Qibla';

  @override
  String get hafalanDrawer => 'Hafalan Quran';

  @override
  String get doaHarianDrawer => 'Doa Harian';

  @override
  String get catatanDrawer => 'Catatan Saya';

  @override
  String get statistikBacaDrawer => 'Statistik Baca';

  @override
  String get statistikShalatDrawer => 'Statistik Shalat';

  @override
  String get manajemenAudioDrawer => 'Manajemen Audio';

  @override
  String get pengaturanDrawer => 'Pengaturan';

  @override
  String get pageNotFound => 'Halaman Tidak Ditemukan';

  @override
  String get pageNotFoundDesc =>
      'Halaman yang Anda cari tidak tersedia\natau telah dipindahkan.';

  @override
  String get backToHome => 'Kembali ke Beranda';

  @override
  String get suratListHeader => 'Daftar Surah';

  @override
  String totalSurat(int count) {
    return '$count Surah';
  }

  @override
  String get suratCompletedEmpty => 'Belum ada surat yang selesai dibaca';

  @override
  String get suratInProgressEmpty => 'Belum ada surat yang sedang dibaca';

  @override
  String filterAll(int count) {
    return 'Semua ($count)';
  }

  @override
  String filterInProgress(int count) {
    return 'Sedang Dibaca ($count)';
  }

  @override
  String filterCompleted(int count) {
    return 'Selesai ($count)';
  }

  @override
  String get filterReadingStatus => 'Filter Status Membaca';

  @override
  String get murajaahToday => 'MURAJA\'AH HARI INI';

  @override
  String get start => 'Mulai';

  @override
  String andMore(int count) {
    return '+$count lainnya';
  }

  @override
  String get tasbihTitle => 'Tasbih & Dzikir';

  @override
  String get tasbihHistory => 'Riwayat';

  @override
  String get tasbihHistoryTitle => 'Riwayat Tasbih';

  @override
  String get tasbihDeleteAllHistory => 'Hapus semua riwayat';

  @override
  String get tasbihEmptyHistory => 'Belum ada riwayat tasbih.';

  @override
  String get tasbihDeleteAllConfirmTitle => 'Hapus Semua Riwayat?';

  @override
  String get tasbihDeleteAllConfirmMessage =>
      'Semua riwayat tasbih akan dihapus permanen.';

  @override
  String get tasbihCompleted => 'Selesai';

  @override
  String get tasbihTarget => 'Target';

  @override
  String get tasbihRemaining => 'Sisa';

  @override
  String get tasbihSelectDzikir => 'Pilih Dzikir';

  @override
  String get tasbihCustomTarget => 'Target custom';

  @override
  String get tasbihCustomTargetHint => 'Contoh: 200';

  @override
  String get tasbihSetButton => 'Set';

  @override
  String get tasbihChangeDzikir => 'Ganti Dzikir';

  @override
  String get tasbihReset => 'Reset';

  @override
  String get tasbihDelete => 'Hapus';
}
