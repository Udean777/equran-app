import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/cubit/quran_font_cubit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppTypography {
  static const String _fontFamily = 'Roboto';
  static const String _arabicFontFamily = 'Amiri';

  // ---------------------------------------------------------------------------
  // Serif heading — Playfair Display (luxury editorial)
  // ---------------------------------------------------------------------------

  static TextStyle get serifDisplayLarge => GoogleFonts.playfairDisplay(
    fontSize: 40,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static TextStyle get serifDisplayMedium => GoogleFonts.playfairDisplay(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.25,
    color: AppColors.textPrimary,
    height: 1.25,
  );

  static TextStyle get serifHeadingLarge => GoogleFonts.playfairDisplay(
    fontSize: 26,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static TextStyle get serifHeadingMedium => GoogleFonts.playfairDisplay(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.35,
  );

  static TextStyle get serifHeadingSmall => GoogleFonts.playfairDisplay(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  // ---------------------------------------------------------------------------
  // Base text theme — Roboto
  // ---------------------------------------------------------------------------

  static TextTheme get textTheme => const TextTheme(
    displayLarge: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 57,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.25,
    ),
    displayMedium: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 45,
      fontWeight: FontWeight.w400,
    ),
    displaySmall: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 36,
      fontWeight: FontWeight.w400,
    ),
    headlineLarge: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 32,
      fontWeight: FontWeight.w600,
    ),
    headlineMedium: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 28,
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 24,
      fontWeight: FontWeight.w600,
    ),
    titleLarge: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 22,
      fontWeight: FontWeight.w500,
    ),
    titleMedium: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
    ),
    titleSmall: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
    ),
    bodyLarge: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
    ),
    bodyMedium: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
    ),
    bodySmall: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
    ),
    labelLarge: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
    ),
    labelMedium: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
    ),
    labelSmall: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
    ),
  );

  // ---------------------------------------------------------------------------
  // Arabic styles — Amiri
  // ---------------------------------------------------------------------------

  /// Style khusus teks Arab menggunakan font Amiri.
  static const TextStyle arabicLarge = TextStyle(
    fontFamily: _arabicFontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w400,
    height: 2,
  );

  static const TextStyle arabicMedium = TextStyle(
    fontFamily: _arabicFontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w400,
    height: 2,
  );

  static const TextStyle arabicSmall = TextStyle(
    fontFamily: _arabicFontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 2,
  );

  // ---------------------------------------------------------------------------
  // Dynamic styles — menggunakan preferensi dari QuranFontCubit
  // ---------------------------------------------------------------------------

  /// Style teks Arab dinamis berdasarkan [QuranFontState].
  static TextStyle arabicDynamic(QuranFontState fontState) => TextStyle(
    fontFamily: fontState.arabicFontFamily,
    fontSize: fontState.arabicFontSize,
    fontWeight: FontWeight.w400,
    height: 2,
  );

  /// Style teks terjemahan & latin dinamis berdasarkan [QuranFontState].
  static TextStyle translationDynamic(QuranFontState fontState) => TextStyle(
    fontFamily: _fontFamily,
    fontSize: fontState.translationFontSize,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );
}
