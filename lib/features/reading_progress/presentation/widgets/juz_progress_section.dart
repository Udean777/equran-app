import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// Progress bar 30 juz Al-Quran.
class JuzProgressSection extends StatelessWidget {
  const JuzProgressSection({required this.progressPerJuz, super.key});

  final Map<int, double> progressPerJuz;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;
    final borderColor = isDark
        ? AppColors.outlineDark
        : AppColors.outlineVariant;
    final juzDibaca = progressPerJuz.values.where((p) => p > 0).length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.pagePadding,
        AppDimens.spaceXS,
        AppDimens.pagePadding,
        AppDimens.spaceXS,
      ),
      child: Container(
        padding: const EdgeInsets.all(AppDimens.cardPaddingLG),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(AppDimens.radiusXL),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: isDark ? 0.04 : 0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 3,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                  ),
                ),
                const SizedBox(width: AppDimens.spaceSM),
                Text(
                  'Progress Per Juz',
                  style: AppTypography.serifHeadingSmall.copyWith(
                    color: isDark
                        ? AppColors.onSurfaceDark
                        : AppColors.textPrimary,
                    fontSize: 15,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.spaceSM,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.primaryDark
                        : AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                  ),
                  child: Text(
                    '$juzDibaca/30 juz',
                    style: TextStyle(
                      color: isDark
                          ? AppColors.primaryLighter
                          : AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppDimens.spaceMD),

            ...List.generate(30, (i) {
              final juz = i + 1;
              final progress = progressPerJuz[juz] ?? 0.0;
              return _JuzRow(juz: juz, progress: progress, isDark: isDark);
            }),
          ],
        ),
      ),
    );
  }
}

class _JuzRow extends StatelessWidget {
  const _JuzRow({
    required this.juz,
    required this.progress,
    required this.isDark,
  });

  final int juz;
  final double progress;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final persen = (progress * 100).toStringAsFixed(0);
    final hasProgress = progress > 0;
    final textColor = hasProgress
        ? (isDark ? AppColors.onSurfaceDark : AppColors.textPrimary)
        : (isDark ? AppColors.onSurfaceDarkVariant : AppColors.textTertiary);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Text(
              'Juz $juz',
              style: TextStyle(
                fontWeight: hasProgress ? FontWeight.w600 : FontWeight.normal,
                color: textColor,
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(width: AppDimens.spaceSM),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppDimens.radiusFull),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 7,
                backgroundColor: isDark
                    ? AppColors.outlineDark
                    : AppColors.outlineVariant,
                valueColor: AlwaysStoppedAnimation<Color>(
                  _colorForProgress(progress),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppDimens.spaceSM),
          SizedBox(
            width: 32,
            child: Text(
              hasProgress ? '$persen%' : '',
              style: TextStyle(
                color: _colorForProgress(progress),
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Color _colorForProgress(double progress) {
    if (progress >= 1.0) return AppColors.gold;
    if (progress >= 0.5) return AppColors.primary;
    if (progress > 0) {
      return AppColors.primary.withValues(alpha: 0.7);
    }
    return AppColors.outline;
  }
}
