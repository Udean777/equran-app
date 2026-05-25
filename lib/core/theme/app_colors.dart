import 'package:flutter/material.dart';

abstract final class AppColors {
  // Primary — Hijau Islami
  static const Color primary = Color(0xFF1B5E20);
  static const Color primaryDark = Color(0xFF0A3D0A);
  static const Color onPrimary = Color(0xFFFFFFFF);

  // Secondary — Emas
  static const Color secondary = Color(0xFFD4A017);
  static const Color onSecondary = Color(0xFF000000);

  // Background & Surface — Light
  static const Color background = Color(0xFFF5F5F0);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF1C1B1F);
  static const Color outline = Color(0xFFE0E0E0);

  // Background & Surface — Dark
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color onSurfaceDark = Color(0xFFE6E1E5);
  static const Color outlineDark = Color(0xFF2C2C2C);

  // Semantic
  static const Color error = Color(0xFFB00020);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFF57F17);

  // Quran specific
  static const Color mekahBadge = Color(0xFFFFF3E0);
  static const Color mekahBadgeText = Color(0xFFE65100);
  static const Color madinahBadge = Color(0xFFE8F5E9);
  static const Color madinahBadgeText = Color(0xFF1B5E20);
  static const Color ayatNumberBg = Color(0xFF1B5E20);
  static const Color ayatNumberText = Color(0xFFFFFFFF);
}
