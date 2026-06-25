// Semua string constants untuk settings feature.
abstract final class SettingsStrings {
  // Page title
  static const pageTitle = 'Pengaturan';

  // Section headers
  static const sectionDisplay = 'Tampilan';
  static const sectionNotifications = 'Notifikasi';
  static const sectionDeveloper = 'Developer';
  static const sectionDataSource = 'Sumber Data';

  // Display settings
  static const themeLabel = 'Tema Tampilan';
  static const themeLight = 'Terang';
  static const themeDark = 'Gelap';
  static const themeLightActive = 'Mode Terang aktif';
  static const themeDarkActive = 'Mode Gelap aktif';

  static const fontSettingsTitle = 'Tampilan Teks';
  static const fontSettingsSubtitle = 'Ukuran & jenis font Arab';
  static const fontArabicLabel = 'Font Arab';
  static const fontAmiri = 'Amiri';
  static const fontUthmani = 'Uthmani';
  static const fontAmiriActive = 'Font Amiri digunakan';
  static const fontUthmaniActive = 'Font Uthmani digunakan';
  static const previewArabic = 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ';
  static const previewTranslation =
      'Dengan nama Allah Yang Maha Pengasih, Maha Penyayang.';
  static const fontArabicSizeLabel = 'Ukuran Teks Arab';
  static const fontTranslationSizeLabel = 'Ukuran Terjemahan';
  static const fontResetButton = 'Reset ke Default';
  static const fontResetSuccess = 'Tampilan teks direset ke default';

  static String fontArabicSizeValue(int size) => 'Ukuran teks Arab: ${size}px';
  static String fontTranslationSizeValue(int size) =>
      'Ukuran terjemahan: ${size}px';
  static String fontSizeDisplay(int size) => '${size}px';

  // Language settings
  static const languageChangedId = 'Bahasa diubah ke Indonesia';
  static const languageChangedEn = 'Language changed to English';
  static const languageChangedAr = 'تم تغيير اللغة إلى العربية';

  // Quran reminder
  static const quranReminderTitle = 'Reminder Baca Quran';
  static const quranReminderToggle = 'Aktifkan Reminder';
  static const quranReminderSubtitle = 'Pengingat harian membaca Al-Quran';
  static const quranReminderActive = 'Reminder Quran aktif';
  static const quranReminderInactive = 'Reminder Quran dimatikan';
  static const quranReminderTimeLabel = 'Jam Reminder';
  static String quranReminderTimeValue(String time) =>
      'Setiap hari pukul $time';
  static String quranReminderTimeChanged(String hh, String mm) =>
      'Reminder diset pukul $hh:$mm';

  // Shalat notifications
  static const shalatNotifTitle = 'Notifikasi Waktu Shalat';
  static const shalatNotifSubuh = 'Subuh';
  static const shalatNotifDzuhur = 'Dzuhur';
  static const shalatNotifAshar = 'Ashar';
  static const shalatNotifMaghrib = 'Maghrib';
  static const shalatNotifIsya = 'Isya';
  static const shalatNotifMinutesBeforeLabel = 'Menit Sebelum Adzan';
  static const shalatNotifExactTime = 'Notifikasi tepat saat adzan';
  static String shalatNotifMinutesSubtitle(int minutes) =>
      '$minutes menit sebelum';

  static String shalatNotifActive(String prayer) => 'Notifikasi $prayer aktif';
  static String shalatNotifInactive(String prayer) =>
      'Notifikasi $prayer dimatikan';
  static String shalatNotifMinutesBefore(int minutes) => minutes == 0
      ? 'Notifikasi tepat saat adzan'
      : 'Notifikasi $minutes menit sebelum adzan';

  // Brand
  static const brandName = 'eQuran';
  static const brandTagline = 'Teman Ibadah Sehari-hari';
  static const brandVersion = 'v1.0.0 (Official Release)';

  // About / Data sources
  static const aboutDataSourceTitle = 'Sumber Data';
  static const aboutDataSourceSubtitle = 'Data Al-Quran & Audio Pendukung';
  static const aboutEquranAPI = 'API Al-Quran';
  static const aboutEquranURL = 'https://equran.id';
  static const aboutKemenagTranslation = 'Terjemahan Kemenag RI';
  static const aboutKemenagURL = 'https://quran.kemenag.go.id';
  static const aboutMyQuranAPI = 'Jadwal Shalat MyQuran';
  static const aboutMyQuranURL = 'https://api.myquran.com';
  static const aboutAdzanAudio = 'Audio Adzan (IslamDownload)';
  static const aboutAdzanURL =
      'https://islamdownload.net/123801-download-suara-adzan.html';
  static const aboutAdzanDomain = 'islamdownload.net';

  // Reset All
  static const resetAllButton = 'Reset Semua Pengaturan';
  static const resetAllDialogTitle = 'Reset Pengaturan';
  static const resetAllDialogMessage =
      'Apakah Anda yakin ingin mereset semua pengaturan (Tema, Font, Bahasa, dsb) ke default?';
  static const resetAllSuccess = 'Semua pengaturan berhasil direset';
}
