import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/features/hafalan/domain/entities/hafalan_stats.dart';
import 'package:flutter/material.dart';

class HafalanStatsCard extends StatelessWidget {
  const HafalanStatsCard({required this.stats, super.key});

  final HafalanStats stats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final persen = (stats.persentaseQuran * 100).toStringAsFixed(1);

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
            // Ornamen circle
            Positioned(
              right: -20,
              top: -20,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.onPrimary.withValues(alpha: 0.05),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppDimens.cardPaddingLG),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.onPrimary.withValues(alpha: 0.15),
                          borderRadius:
                              BorderRadius.circular(AppDimens.radiusMD),
                          border: Border.all(
                            color: AppColors.gold.withValues(alpha: 0.4),
                          ),
                        ),
                        child: const Icon(
                          Icons.auto_stories_rounded,
                          color: AppColors.onPrimary,
                          size: AppDimens.iconMD,
                        ),
                      ),
                      const SizedBox(width: AppDimens.spaceMD),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Progress Hafalan',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: AppColors.onPrimary
                                    .withValues(alpha: 0.7),
                                letterSpacing: 0.5,
                                fontSize: 10,
                              ),
                            ),
                            Text(
                              '$persen% Al-Quran',
                              style: AppTypography.serifHeadingSmall.copyWith(
                                color: AppColors.onPrimary,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppDimens.spaceMD),

                  // Progress bar
                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(AppDimens.radiusFull),
                    child: LinearProgressIndicator(
                      value: stats.persentaseQuran,
                      minHeight: 6,
                      backgroundColor:
                          AppColors.onPrimary.withValues(alpha: 0.2),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.gold,
                      ),
                    ),
                  ),

                  const SizedBox(height: AppDimens.spaceMD),

                  // Gold divider
                  Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.gold.withValues(alpha: 0),
                          AppColors.gold.withValues(alpha: 0.4),
                          AppColors.gold.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: AppDimens.spaceMD),

                  // Stats row
                  Row(
                    children: [
                      _StatItem(
                        label: 'Surat Hafal',
                        value: stats.totalSuratSelesai.toString(),
                        icon: Icons.check_circle_outline_rounded,
                      ),
                      _StatDivider(),
                      _StatItem(
                        label: 'Sedang Dihafal',
                        value: stats.suratSedangDihafal.toString(),
                        icon: Icons.pending_outlined,
                      ),
                      _StatDivider(),
                      _StatItem(
                        label: "Perlu Muraja'ah",
                        value: stats.suratPerluMurajaah.toString(),
                        icon: Icons.refresh_rounded,
                      ),
                      _StatDivider(),
                      _StatItem(
                        label: 'Total Ayat',
                        value: stats.totalAyatHafal.toString(),
                        icon: Icons.format_list_numbered_rounded,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 14, color: AppColors.gold),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.onPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.onPrimary,
              fontSize: 9,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 36,
      color: AppColors.onPrimary.withValues(alpha: 0.15),
    );
  }
}
