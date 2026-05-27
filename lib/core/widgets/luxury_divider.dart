import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:flutter/material.dart';

/// Divider tipis outline — dipakai di antara item dalam card / settings.
///
/// Otomatis menyesuaikan warna berdasarkan theme (light/dark).
///
/// Contoh:
/// ```dart
/// LuxuryCard(
///   child: Column(
///     children: [
///       LuxuryListTile(...),
///       LuxuryDivider(),
///       LuxuryListTile(...),
///     ],
///   ),
/// )
/// ```
class LuxuryDivider extends StatelessWidget {
  const LuxuryDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: AppDimens.cardPadding),
      color: isDark ? AppColors.outlineDark : AppColors.outlineVariant,
    );
  }
}

/// Divider gradient gold — dipakai sebagai pemisah dekoratif dalam card konten.
///
/// Mendukung orientasi horizontal (default) dan vertikal.
///
/// Contoh horizontal:
/// ```dart
/// Column(
///   children: [
///     Text(arabicText),
///     GoldDivider(),
///     Text(translation),
///   ],
/// )
/// ```
///
/// Contoh vertikal:
/// ```dart
/// Row(
///   children: [
///     _InfoItem(...),
///     GoldDivider.vertical(height: 48),
///     _InfoItem(...),
///   ],
/// )
/// ```
class GoldDivider extends StatelessWidget {
  /// Divider horizontal dengan margin vertikal opsional.
  const GoldDivider({
    this.verticalMargin = AppDimens.spaceSM,
    super.key,
  }) : _axis = Axis.horizontal,
       _size = null;

  /// Divider vertikal dengan tinggi tertentu.
  const GoldDivider.vertical({
    required double height,
    super.key,
  }) : _axis = Axis.vertical,
       _size = height,
       verticalMargin = 0;

  final Axis _axis;

  /// Tinggi divider vertikal (hanya dipakai saat [_axis] == [Axis.vertical]).
  final double? _size;

  /// Margin vertikal di atas dan bawah divider horizontal.
  final double verticalMargin;

  @override
  Widget build(BuildContext context) {
    if (_axis == Axis.vertical) {
      return Container(
        width: 1,
        height: _size,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.gold.withValues(alpha: 0),
              AppColors.gold.withValues(alpha: 0.4),
              AppColors.gold.withValues(alpha: 0),
            ],
          ),
        ),
      );
    }

    return Container(
      height: 1,
      margin: EdgeInsets.symmetric(vertical: verticalMargin),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.gold.withValues(alpha: 0),
            AppColors.gold.withValues(alpha: 0.3),
            AppColors.gold.withValues(alpha: 0),
          ],
        ),
      ),
    );
  }
}
