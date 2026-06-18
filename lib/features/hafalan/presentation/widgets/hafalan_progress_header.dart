import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/features/hafalan/domain/entities/hafalan_surat.dart';
import 'package:equran_app/features/hafalan/presentation/widgets/hafalan_status_badge.dart';
import 'package:equran_app/features/surat_list/domain/entities/surat.dart';
import 'package:flutter/material.dart';

/// Header progress hafalan — nama Arab, progress bar, persentase.
class HafalanProgressHeader extends StatelessWidget {
  const HafalanProgressHeader({
    required this.surat,
    required this.ayatHafalCount,
    required this.progress,
    required this.persen,
    required this.status,
    super.key,
  });

  final Surat surat;
  final int ayatHafalCount;
  final double progress;
  final String persen;
  final HafalanStatus status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;
    final borderColor = isDark
        ? AppColors.outlineDark
        : AppColors.outlineVariant;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.pagePadding,
        AppDimens.spaceMD,
        AppDimens.pagePadding,
        AppDimens.spaceXS,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(AppDimens.radiusXL),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: isDark ? 0.05 : 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(AppDimens.cardPaddingLG),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info kiri
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nama Arab
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: Text(
                          surat.nama,
                          style: TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 28,
                            color: isDark
                                ? AppColors.primaryLighter
                                : AppColors.primary,
                            height: 1.6,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDimens.spaceXS),
                      Text(
                        surat.namaLatin,
                        style: AppTypography.serifHeadingSmall.copyWith(
                          color: isDark
                              ? AppColors.onSurfaceDark
                              : AppColors.textPrimary,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: AppDimens.spaceXS),
                      Text(
                        '$ayatHafalCount / ${surat.jumlahAyat} ayat',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDark
                              ? AppColors.onSurfaceDarkVariant
                              : AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Status badge + persentase
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    HafalanStatusBadge(status: status),
                    const SizedBox(height: AppDimens.spaceSM),
                    Text(
                      persen,
                      style: AppTypography.serifHeadingSmall.copyWith(
                        color: isDark
                            ? AppColors.primaryLighter
                            : AppColors.primary,
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: AppDimens.spaceMD),

            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(AppDimens.radiusFull),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: isDark
                    ? AppColors.primaryDark
                    : AppColors.primaryContainer,
                valueColor: AlwaysStoppedAnimation<Color>(
                  progress >= 1.0
                      ? AppColors.gold
                      : (isDark ? AppColors.primaryLighter : AppColors.primary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
