import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:flutter/material.dart';

/// Card dengan gradient primary hijau, ornamen circle dekoratif, dan shadow.
///
/// Dipakai sebagai container untuk hero/stats card di berbagai feature.
/// Semua styling gradient dan ornamen sudah di-handle — cukup pass [child].
///
/// Contoh:
/// ```dart
/// PrimaryGradientCard(
///   child: Column(
///     children: [
///       _HeaderRow(...),
///       GoldDivider(verticalMargin: 0),
///       StatsRow(items: [...]),
///     ],
///   ),
/// )
/// ```
class PrimaryGradientCard extends StatelessWidget {
  const PrimaryGradientCard({
    required this.child,
    this.ornamentSize = 110.0,
    this.ornamentRight = -20.0,
    this.ornamentTop = -20.0,
    this.ornamentBottom,
    this.ornamentLeft,
    this.padding = const EdgeInsets.all(AppDimens.cardPaddingLG),
    super.key,
  });

  /// Konten utama card.
  final Widget child;

  /// Ukuran diameter ornamen circle dekoratif. Default 110.
  final double ornamentSize;

  /// Posisi horizontal ornamen dari kanan. Default -20 (sedikit keluar card).
  final double? ornamentRight;

  /// Posisi vertikal ornamen dari atas. Default -20 (sedikit keluar card).
  final double? ornamentTop;

  /// Posisi vertikal ornamen dari bawah.
  final double? ornamentBottom;

  /// Posisi horizontal ornamen dari kiri.
  final double? ornamentLeft;

  /// Padding dalam card. Default [AppDimens.cardPaddingLG] di semua sisi.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.pagePadding,
        AppDimens.spaceMD,
        AppDimens.pagePadding,
        AppDimens.spaceXS,
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [AppColors.primaryDark, AppColors.primary]
                : [AppColors.primary, AppColors.primaryLight],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppDimens.radiusXL),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Ornamen circle dekoratif
            Positioned(
              right: ornamentRight,
              top: ornamentTop,
              bottom: ornamentBottom,
              left: ornamentLeft,
              child: Container(
                width: ornamentSize,
                height: ornamentSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.onPrimary.withValues(alpha: 0.05),
                ),
              ),
            ),

            // Konten
            Padding(
              padding: padding,
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
