import 'package:flutter/material.dart';

/// Warna aplikasi yang ikut diinterpolasi ketika ThemeData dianimasikan.
///
/// Beberapa widget memakai warna semantik dari context extension. Menaruh
/// warna tersebut sebagai ThemeExtension mencegah widget berpindah dari
/// palette light ke dark secara mendadak di tengah transisi.
@immutable
class AppThemePalette extends ThemeExtension<AppThemePalette> {
  const AppThemePalette({
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.border,
    required this.borderVariant,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.primaryAction,
    required this.primaryContainer,
  });

  static const light = AppThemePalette(
    background: Color(0xFFFAFCFA),
    surface: Color(0xFFFFFFFF),
    surfaceVariant: Color(0xFFF0F7F3),
    border: Color(0xFFDDE8E2),
    borderVariant: Color(0xFFEEF4F0),
    textPrimary: Color(0xFF0D1F16),
    textSecondary: Color(0xFF4A6355),
    textTertiary: Color(0xFF8FA99A),
    primaryAction: Color(0xFF1A5C38),
    primaryContainer: Color(0xFFD6EDE1),
  );

  static const dark = AppThemePalette(
    background: Color(0xFF0F1A13),
    surface: Color(0xFF1A2B1E),
    surfaceVariant: Color(0xFF1F3324),
    border: Color(0xFF2A3D2F),
    borderVariant: Color(0xFF223328),
    textPrimary: Color(0xFFE2EDE6),
    textSecondary: Color(0xFF9DB8A6),
    textTertiary: Color(0xFF9DB8A6),
    primaryAction: Color(0xFF3D9B65),
    primaryContainer: Color(0xFF0A3D0A),
  );

  final Color background;
  final Color surface;
  final Color surfaceVariant;
  final Color border;
  final Color borderVariant;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color primaryAction;
  final Color primaryContainer;

  @override
  AppThemePalette copyWith({
    Color? background,
    Color? surface,
    Color? surfaceVariant,
    Color? border,
    Color? borderVariant,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? primaryAction,
    Color? primaryContainer,
  }) => AppThemePalette(
    background: background ?? this.background,
    surface: surface ?? this.surface,
    surfaceVariant: surfaceVariant ?? this.surfaceVariant,
    border: border ?? this.border,
    borderVariant: borderVariant ?? this.borderVariant,
    textPrimary: textPrimary ?? this.textPrimary,
    textSecondary: textSecondary ?? this.textSecondary,
    textTertiary: textTertiary ?? this.textTertiary,
    primaryAction: primaryAction ?? this.primaryAction,
    primaryContainer: primaryContainer ?? this.primaryContainer,
  );

  @override
  AppThemePalette lerp(covariant AppThemePalette? other, double t) {
    if (other == null) return this;
    return AppThemePalette(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceVariant: Color.lerp(surfaceVariant, other.surfaceVariant, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderVariant: Color.lerp(borderVariant, other.borderVariant, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      primaryAction: Color.lerp(primaryAction, other.primaryAction, t)!,
      primaryContainer: Color.lerp(
        primaryContainer,
        other.primaryContainer,
        t,
      )!,
    );
  }
}
