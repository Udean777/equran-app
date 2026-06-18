import 'package:equran_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Gaya desain template premium untuk berbagi ayat.
enum ShareTemplateStyle {
  classicEmerald(
    displayName: 'Emerald',
    backgroundColors: [Color(0xFF0D3320), Color(0xFF1A5C38), Color(0xFF0F4028)],
    stops: [0.0, 0.5, 1.0],
    shadowColor: Color(0x661A5C38),
    topBorderColors: [
      Colors.transparent,
      AppColors.gold,
      AppColors.goldLight,
      AppColors.gold,
      Colors.transparent,
    ],
    bottomBorderColor: Color(0x80C9A84C),
    bigCircleColor: Color(0x0AFFFFFF),
    smallCircleColor: Color(0x0FC9A84C),
    bottomCircleColor: Color(0x08FFFFFF),
    arabicTextColor: Colors.white,
    translationTextColor: Color(0xE0FFFFFF),
    brandingTextColor: Color(0xB3FFFFFF),
    brandingIconColor: Color(0xCCC9A84C),
    badgeBgColor: Color(0x26C9A84C),
    badgeBorderColor: Color(0x66C9A84C),
    badgeTextColor: Color(0xFFC9A84C),
    dividerCircleColor: Color(0xFFC9A84C),
    dividerLineColors: [Colors.transparent, Color(0x99C9A84C)],
    sourceBgColor: Color(0x14FFFFFF),
    sourceBorderColor: Color(0x40C9A84C),
    sourceTextColor: Color(0xFFE8C97A),
  ),
  royalIndigo(
    displayName: 'Indigo',
    backgroundColors: [Color(0xFF0C091A), Color(0xFF1B153D), Color(0xFF0F0B24)],
    stops: [0.0, 0.5, 1.0],
    shadowColor: Color(0x661B153D),
    topBorderColors: [
      Colors.transparent,
      Color(0xFFD6C5F0),
      Color(0xFFF4D9E8),
      Color(0xFFD6C5F0),
      Colors.transparent,
    ],
    bottomBorderColor: Color(0x80D6C5F0),
    bigCircleColor: Color(0x0D8A6ED6),
    smallCircleColor: Color(0x14FFB7B2),
    bottomCircleColor: Color(0x0A8A6ED6),
    arabicTextColor: Colors.white,
    translationTextColor: Color(0xE6FFFFFF),
    brandingTextColor: Color(0xB3FFFFFF),
    brandingIconColor: Color(0xCCFFB7B2),
    badgeBgColor: Color(0x338A6ED6),
    badgeBorderColor: Color(0x808A6ED6),
    badgeTextColor: Color(0xFFD6C5F0),
    dividerCircleColor: Color(0xFFFFB7B2),
    dividerLineColors: [Colors.transparent, Color(0x998A6ED6)],
    sourceBgColor: Color(0x10FFFFFF),
    sourceBorderColor: Color(0x4D8A6ED6),
    sourceTextColor: Color(0xFFD6C5F0),
  ),
  warmSand(
    displayName: 'Sand',
    backgroundColors: [Color(0xFFFAF7F2), Color(0xFFF2ECE0), Color(0xFFE5DDD0)],
    stops: [0.0, 0.5, 1.0],
    shadowColor: Color(0x268C7E6C),
    topBorderColors: [
      Colors.transparent,
      Color(0xFFC88261),
      Color(0xFFDF9E7E),
      Color(0xFFC88261),
      Colors.transparent,
    ],
    bottomBorderColor: Color(0x40C88261),
    bigCircleColor: Color(0x0AC88261),
    smallCircleColor: Color(0x0C7E9285),
    bottomCircleColor: Color(0x08C88261),
    arabicTextColor: Color(0xFF2C2520),
    translationTextColor: Color(0xFF4A3E38),
    brandingTextColor: Color(0xCC4A3E38),
    brandingIconColor: Color(0xCCC88261),
    badgeBgColor: Color(0x1AC88261),
    badgeBorderColor: Color(0x4DC88261),
    badgeTextColor: Color(0xFF9E5C3D),
    dividerCircleColor: Color(0xFFC88261),
    dividerLineColors: [Colors.transparent, Color(0x99C88261)],
    sourceBgColor: Color(0x0DC88261),
    sourceBorderColor: Color(0x40C88261),
    sourceTextColor: Color(0xFF9E5C3D),
  ),
  minimalistCharcoal(
    displayName: 'Charcoal',
    backgroundColors: [Color(0xFF121212), Color(0xFF1E1E1E), Color(0xFF161616)],
    stops: [0.0, 0.5, 1.0],
    shadowColor: Color(0x80000000),
    topBorderColors: [
      Colors.transparent,
      Color(0xFFB0B3B8),
      Color(0xFFE1E2E6),
      Color(0xFFB0B3B8),
      Colors.transparent,
    ],
    bottomBorderColor: Color(0x40B0B3B8),
    bigCircleColor: Color(0x05FFFFFF),
    smallCircleColor: Color(0x0AFFFFFF),
    bottomCircleColor: Color(0x03FFFFFF),
    arabicTextColor: Colors.white,
    translationTextColor: Color(0xD9FFFFFF),
    brandingTextColor: Color(0xB3FFFFFF),
    brandingIconColor: Color(0xCCE1E2E6),
    badgeBgColor: Color(0x14FFFFFF),
    badgeBorderColor: Color(0x4DFFFFFF),
    badgeTextColor: Color(0xFFE1E2E6),
    dividerCircleColor: Color(0xFFE1E2E6),
    dividerLineColors: [Colors.transparent, Color(0x80B0B3B8)],
    sourceBgColor: Color(0x0DFFFFFF),
    sourceBorderColor: Color(0x33FFFFFF),
    sourceTextColor: Color(0xFFE1E2E6),
  ),
  sacredTeal(
    displayName: 'Teal',
    backgroundColors: [Color(0xFF0A2E2F), Color(0xFF144D4E), Color(0xFF0F3A3B)],
    stops: [0.0, 0.5, 1.0],
    shadowColor: Color(0x66144D4E),
    topBorderColors: [
      Colors.transparent,
      Color(0xFFE0C070),
      Color(0xFFFADAA3),
      Color(0xFFE0C070),
      Colors.transparent,
    ],
    bottomBorderColor: Color(0x80E0C070),
    bigCircleColor: Color(0x0D4CA5A7),
    smallCircleColor: Color(0x14E0C070),
    bottomCircleColor: Color(0x0A4CA5A7),
    arabicTextColor: Colors.white,
    translationTextColor: Color(0xE6FFFFFF),
    brandingTextColor: Color(0xB3FFFFFF),
    brandingIconColor: Color(0xCCE0C070),
    badgeBgColor: Color(0x26E0C070),
    badgeBorderColor: Color(0x66E0C070),
    badgeTextColor: Color(0xFFFADAA3),
    dividerCircleColor: Color(0xFFE0C070),
    dividerLineColors: [Colors.transparent, Color(0x99E0C070)],
    sourceBgColor: Color(0x14FFFFFF),
    sourceBorderColor: Color(0x40E0C070),
    sourceTextColor: Color(0xFFFADAA3),
  );

  const ShareTemplateStyle({
    required this.displayName,
    required this.backgroundColors,
    required this.stops,
    required this.shadowColor,
    required this.topBorderColors,
    required this.bottomBorderColor,
    required this.bigCircleColor,
    required this.smallCircleColor,
    required this.bottomCircleColor,
    required this.arabicTextColor,
    required this.translationTextColor,
    required this.brandingTextColor,
    required this.brandingIconColor,
    required this.badgeBgColor,
    required this.badgeBorderColor,
    required this.badgeTextColor,
    required this.dividerCircleColor,
    required this.dividerLineColors,
    required this.sourceBgColor,
    required this.sourceBorderColor,
    required this.sourceTextColor,
  });

  final String displayName;
  final List<Color> backgroundColors;
  final List<double> stops;
  final Color shadowColor;
  final List<Color> topBorderColors;
  final Color bottomBorderColor;
  final Color bigCircleColor;
  final Color smallCircleColor;
  final Color bottomCircleColor;
  final Color arabicTextColor;
  final Color translationTextColor;
  final Color brandingTextColor;
  final Color brandingIconColor;
  final Color badgeBgColor;
  final Color badgeBorderColor;
  final Color badgeTextColor;
  final Color dividerCircleColor;
  final List<Color> dividerLineColors;
  final Color sourceBgColor;
  final Color sourceBorderColor;
  final Color sourceTextColor;
}
