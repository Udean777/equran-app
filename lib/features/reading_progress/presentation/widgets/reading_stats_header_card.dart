import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/features/reading_progress/domain/entities/reading_history.dart';
import 'package:flutter/material.dart';

/// Header card: total ayat dibaca, rata-rata/hari, streak.
class ReadingStatsHeaderCard extends StatelessWidget {
  const ReadingStatsHeaderCard({
    required this.stats,
    required this.streak,
    super.key,
  });

  final ReadingStats stats;
  final int streak;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
            Positioned(
              right: -20,
              top: -20,
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.onPrimary.withValues(alpha: 0.05),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppDimens.cardPaddingLG),
              child: Column(
                children: [
                  // Header row
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
                          Icons.menu_book_rounded,
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
                              'Statistik Membaca',
                              style: TextStyle(
                                color: AppColors.onPrimary
                                    .withValues(alpha: 0.7),
                                fontSize: 11,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              '${stats.totalHariDenganData} hari aktif',
                              style: AppTypography.serifHeadingSmall.copyWith(
                                color: AppColors.onPrimary,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (streak > 0) _StreakBadge(streak: streak),
                    ],
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
                        label: 'Total Ayat',
                        value: '${stats.totalAyatRead}',
                        icon: Icons.format_list_numbered_rounded,
                      ),
                      _StatDivider(),
                      _StatItem(
                        label: 'Rata-rata/Hari',
                        value: stats.rataRataPerHari.toStringAsFixed(1),
                        icon: Icons.trending_up_rounded,
                      ),
                      _StatDivider(),
                      _StatItem(
                        label: 'Juz Dibaca',
                        value:
                            '${stats.progressPerJuz.values.where((p) => p > 0).length}',
                        icon: Icons.auto_stories_rounded,
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
          Icon(icon, color: AppColors.gold, size: 16),
          const SizedBox(height: AppDimens.spaceXS),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.onPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: AppColors.onPrimary.withValues(alpha: 0.7),
              fontSize: 10,
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
      height: 40,
      color: AppColors.onPrimary.withValues(alpha: 0.15),
    );
  }
}

class _StreakBadge extends StatelessWidget {
  const _StreakBadge({required this.streak});

  final int streak;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceSM,
        vertical: AppDimens.spaceXS,
      ),
      decoration: BoxDecoration(
        color: AppColors.onPrimary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppDimens.radiusMD),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.local_fire_department_rounded,
            color: AppColors.gold,
            size: 18,
          ),
          Text(
            '$streak',
            style: const TextStyle(
              color: AppColors.onPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Text(
            'hari',
            style: TextStyle(
              color: AppColors.onPrimary.withValues(alpha: 0.8),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
