/// Semua route path constants dan URL builder methods.
///
/// Gunakan [AppRoutes] untuk:
/// - Definisi `GoRoute(path: AppRoutes.suratDetail)` di router
/// - Navigasi `context.push(AppRoutes.surat(114))` di widget
abstract final class AppRoutes {
  // ---------------------------------------------------------------------------
  // Path patterns — dipakai di GoRoute(path: ...)
  // ---------------------------------------------------------------------------

  static const String home = '/';
  static const String suratDetail = '/surat/:nomor';
  static const String doaDetail = '/doa/:id';
  static const String settings = '/settings';
  static const String tasbih = '/tasbih';
  static const String tasbihHistory = '/tasbih/history';
  static const String qibla = '/qibla';
  static const String imsakiyah = '/imsakiyah';
  static const String bookmark = '/bookmark';
  static const String doaHarian = '/doa-harian';
  static const String audioStorage = '/audio/storage';
  static const String catatan = '/catatan';
  static const String hafalan = '/hafalan';
  static const String hafalanDetail = '/hafalan/:suratNomor';
  static const String hafalanSetoran = '/hafalan/:suratNomor/setoran';
  static const String statistikShalat = '/statistik-shalat';
  static const String readingStats = '/reading-stats';
  static const String notificationTest = '/notification-test';
  static const String onboarding = '/onboarding';

  // ---------------------------------------------------------------------------
  // Location builders — dipakai di context.push(...) / context.go(...)
  // ---------------------------------------------------------------------------

  /// Navigasi ke halaman detail surat.
  static String surat(int nomor) => '/surat/$nomor';

  /// Navigasi ke halaman detail surat, scroll ke ayat tertentu.
  static String suratWithAyat(int nomor, int ayat) =>
      '/surat/$nomor?ayat=$ayat';

  /// Navigasi ke halaman detail surat dengan autoplay audio.
  static String suratAutoPlay(int nomor) => '/surat/$nomor?autoPlay=true';

  /// Navigasi ke halaman detail doa.
  static String doa(int id) => '/doa/$id';

  /// Navigasi ke halaman detail hafalan surat.
  static String hafalanSurat(int nomor) => '/hafalan/$nomor';

  /// Navigasi ke halaman setoran hafalan surat.
  static String hafalanSetoranSurat(int nomor) => '/hafalan/$nomor/setoran';
}
