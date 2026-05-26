import 'package:flutter/material.dart';

abstract final class AppColors {
  // ---------------------------------------------------------------------------
  // Primary — Forest Green
  // ---------------------------------------------------------------------------
  static const Color primary = Color(0xFF1A5C38);
  static const Color primaryLight = Color(0xFF2D7A4F);
  static const Color primaryLighter = Color(0xFF3D9B65);
  static const Color primaryContainer = Color(0xFFD6EDE1);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFF0D3320);

  // Dark mode primary
  static const Color primaryDark = Color(0xFF0A3D0A);
  static const Color primaryDarkLight = Color(0xFF1B5E20);

  // ---------------------------------------------------------------------------
  // Gold Accent — Luxury
  // ---------------------------------------------------------------------------
  static const Color gold = Color(0xFFC9A84C);
  static const Color goldLight = Color(0xFFE8C97A);
  static const Color goldLighter = Color(0xFFF5E4A8);
  static const Color goldDark = Color(0xFFA07830);
  static const Color onGold = Color(0xFF3A2800);

  // ---------------------------------------------------------------------------
  // Background & Surface — Light (Luxury Warm White)
  // ---------------------------------------------------------------------------
  static const Color background = Color(0xFFFAFCFA);
  static const Color backgroundSecondary = Color(0xFFF2F7F4);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF0F7F3);
  static const Color surfaceTint = Color(0xFFE8F5EE);
  static const Color onSurface = Color(0xFF0D1F16);
  static const Color onSurfaceVariant = Color(0xFF4A6355);
  static const Color outline = Color(0xFFDDE8E2);
  static const Color outlineVariant = Color(0xFFEEF4F0);

  // ---------------------------------------------------------------------------
  // Background & Surface — Dark
  // ---------------------------------------------------------------------------
  static const Color backgroundDark = Color(0xFF0F1A13);
  static const Color backgroundDarkSecondary = Color(0xFF141F17);
  static const Color surfaceDark = Color(0xFF1A2B1E);
  static const Color surfaceDarkVariant = Color(0xFF1F3324);
  static const Color onSurfaceDark = Color(0xFFE2EDE6);
  static const Color onSurfaceDarkVariant = Color(0xFF9DB8A6);
  static const Color outlineDark = Color(0xFF2A3D2F);
  static const Color outlineDarkVariant = Color(0xFF223328);

  // ---------------------------------------------------------------------------
  // Text Hierarchy — Light
  // ---------------------------------------------------------------------------
  static const Color textPrimary = Color(0xFF0D1F16);
  static const Color textSecondary = Color(0xFF4A6355);
  static const Color textTertiary = Color(0xFF8FA99A);
  static const Color textDisabled = Color(0xFFBDD0C6);

  // ---------------------------------------------------------------------------
  // Semantic
  // ---------------------------------------------------------------------------
  static const Color error = Color(0xFFB00020);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color success = Color(0xFF1A5C38);
  static const Color successContainer = Color(0xFFD6EDE1);
  static const Color warning = Color(0xFFF57F17);
  static const Color warningContainer = Color(0xFFFFEDD0);

  // ---------------------------------------------------------------------------
  // Quran Specific
  // ---------------------------------------------------------------------------
  static const Color mekahBadge = Color(0xFFFFF3E0);
  static const Color mekahBadgeText = Color(0xFFE65100);
  static const Color madinahBadge = Color(0xFFE8F5E9);
  static const Color madinahBadgeText = Color(0xFF1A5C38);
  static const Color ayatNumberBg = Color(0xFF1A5C38);
  static const Color ayatNumberText = Color(0xFFFFFFFF);
  static const Color ayatDivider = Color(0xFFDDE8E2);

  // ---------------------------------------------------------------------------
  // Shimmer
  // ---------------------------------------------------------------------------
  static const Color shimmerBase = Color(0xFFEEF4F0);
  static const Color shimmerHighlight = Color(0xFFF8FBF9);
}
