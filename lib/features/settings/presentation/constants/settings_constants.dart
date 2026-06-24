/// Numeric constants dan configuration values untuk settings feature.
abstract final class SettingsConstants {
  // ── Font Size Ranges ──────────────────────────────────────────────
  /// Default ukuran font Arab (px)
  static const double defaultArabicFontSize = 28;

  /// Default ukuran font terjemahan (px)
  static const double defaultTranslationFontSize = 14;

  /// Min ukuran font Arab (px)
  static const double minArabicFontSize = 18;

  /// Max ukuran font Arab (px)
  static const double maxArabicFontSize = 40;

  /// Min ukuran font terjemahan (px)
  static const double minTranslationFontSize = 12;

  /// Max ukuran font terjemahan (px)
  static const double maxTranslationFontSize = 22;

  // ── Notification Settings ─────────────────────────────────────────
  /// Step increment untuk "menit sebelum adzan" slider (menit)
  static const int notifMinutesStep = 5;

  /// Min value untuk "menit sebelum adzan" (0 = tepat saat adzan)
  static const int notifMinutesMin = 0;

  /// Max value untuk "menit sebelum adzan"
  static const int notifMinutesMax = 60;

  // ── UI Sizes ──────────────────────────────────────────────────────
  /// Icon container size (settings tiles)
  static const double iconContainerSize = 36;

  /// Large icon container size (about section)
  static const double iconContainerSizeLarge = 48;

  /// Logo size di brand header
  static const double logoSize = 80;

  /// Badge/dot size (brand header premium indicator)
  static const double badgeSize = 6;

  /// Small container size (theme chips, reminder time icon)
  static const double containerSizeSmall = 28;

  // ── Animation ─────────────────────────────────────────────────────
  /// Duration untuk theme toggle animation (ms)
  static const int themeToggleAnimationMs = 200;

  // ── Typography Sizes (widget-specific, jika tidak ada di AppDimens) ──
  /// Font size untuk subtitle/secondary text
  static const double fontSizeSecondary = 12;

  /// Font size untuk tertiary/caption text
  static const double fontSizeTertiary = 11;

  /// Font size untuk medium text
  static const double fontSizeMedium = 14;

  /// Font size untuk small text
  static const double fontSizeSmall = 13;

  /// Font size untuk extra small text (version badge)
  static const double fontSizeExtraSmall = 10;

  /// Font size untuk large text (brand name)
  static const double fontSizeLarge = 28;

  /// Font size untuk display text
  static const double fontSizeDisplay = 15;
}
