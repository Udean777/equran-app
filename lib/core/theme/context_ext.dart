import 'package:equran_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

extension BuildContextThemeExt on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  ThemeData get theme => Theme.of(this);

  ColorScheme get colorScheme => theme.colorScheme;

  Color get surfaceColor => isDark ? AppColors.surfaceDark : AppColors.surface;

  Color get surfaceVariantColor =>
      isDark ? AppColors.surfaceDarkVariant : AppColors.surfaceVariant;

  Color get borderColor => isDark ? AppColors.outlineDark : AppColors.outline;

  Color get borderVariantColor =>
      isDark ? AppColors.outlineDarkVariant : AppColors.outlineVariant;

  Color get textPrimaryColor =>
      isDark ? AppColors.onSurfaceDark : AppColors.textPrimary;

  Color get textSecondaryColor =>
      isDark ? AppColors.onSurfaceDarkVariant : AppColors.textSecondary;

  Color get scaffoldBackgroundColor =>
      isDark ? AppColors.backgroundDark : AppColors.background;

  Color get primaryActionColor =>
      isDark ? AppColors.primaryLighter : AppColors.primary;

  Color get primaryContainerColor =>
      isDark ? AppColors.primaryDark : AppColors.primaryContainer;

  Color get textTertiaryColor =>
      isDark ? AppColors.onSurfaceDarkVariant : AppColors.textTertiary;

  Color get borderSubtleColor =>
      isDark ? AppColors.outlineDark : AppColors.outlineVariant;
}
