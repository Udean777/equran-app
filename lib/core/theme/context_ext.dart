import 'package:equran_app/core/theme/app_theme_palette.dart';
import 'package:flutter/material.dart';

extension BuildContextThemeExt on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  ThemeData get theme => Theme.of(this);

  ColorScheme get colorScheme => theme.colorScheme;

  AppThemePalette get _palette =>
      theme.extension<AppThemePalette>() ??
      (isDark ? AppThemePalette.dark : AppThemePalette.light);

  Color get surfaceColor => _palette.surface;

  Color get surfaceVariantColor => _palette.surfaceVariant;

  Color get borderColor => _palette.border;

  Color get borderVariantColor => _palette.borderVariant;

  Color get textPrimaryColor => _palette.textPrimary;

  Color get textSecondaryColor => _palette.textSecondary;

  Color get scaffoldBackgroundColor => _palette.background;

  Color get primaryActionColor => _palette.primaryAction;

  Color get primaryContainerColor => _palette.primaryContainer;

  Color get textTertiaryColor => _palette.textTertiary;

  Color get borderSubtleColor => _palette.borderVariant;
}
