/// Numeric constants dan configuration values untuk statistik_shalat feature.
abstract final class StatistikShalatConstants {
  // ── Date Ranges ──────────────────────────────────────────────────
  /// Jumlah hari untuk statistik overview (30 hari terakhir)
  static const int statsDaysRange = 30;

  /// Jumlah hari untuk weekly chart (7 hari)
  static const int weeklyChartDays = 7;

  // ── Chart Dimensions ─────────────────────────────────────────────
  /// Tinggi bar chart (px)
  static const double chartHeight = 120;

  /// Lebar bar di chart (px)
  static const double chartBarWidth = 4;

  /// Spacing antar bar (px)
  static const double chartBarSpacing = 8;

  // ── Indicator Sizes ──────────────────────────────────────────────
  /// Lebar indicator bar (gold accent)
  static const double indicatorWidth = 3;

  /// Tinggi indicator bar
  static const double indicatorHeight = 16;

  // ── Icon Sizes ───────────────────────────────────────────────────
  /// Icon size untuk legend/status
  static const double iconSizeSmall = 16;

  /// Icon size untuk checklist tiles
  static const double iconSizeMedium = 28;

  /// Icon size untuk detail sheet
  static const double iconSizeLarge = 36;

  // ── Typography ───────────────────────────────────────────────────
  /// Font size untuk section title
  static const double fontSizeTitle = 15;

  /// Font size untuk stat value
  static const double fontSizeStatValue = 18;

  /// Font size untuk label
  static const double fontSizeLabel = 13;

  /// Font size untuk caption
  static const double fontSizeCaption = 11;

  // ── Calendar ─────────────────────────────────────────────────────
  /// Jumlah hari dalam satu minggu
  static const int daysInWeek = 7;

  /// Max weeks to show in calendar
  static const int maxCalendarWeeks = 5;

  /// Jumlah waktu shalat wajib
  static const int totalWaktuShalat = 5;

  // ── Streak ───────────────────────────────────────────────────────
  /// Minimum shalat per hari untuk dihitung streak (1-5)
  static const int minShalatForStreak = 1;
}
