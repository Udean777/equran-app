import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
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
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(AppDimens.spaceMD),
      padding: const EdgeInsets.all(AppDimens.spaceMD),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.menu_book_rounded,
                color: AppColors.onPrimary,
                size: AppDimens.iconLG,
              ),
              const SizedBox(width: AppDimens.spaceMD),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Statistik Membaca',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${stats.totalHariDenganData} hari aktif membaca',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.onPrimary.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
              if (streak > 0) _StreakBadge(streak: streak),
            ],
          ),
          const SizedBox(height: AppDimens.spaceMD),
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  label: 'Total Ayat',
                  value: '${stats.totalAyatRead}',
                  icon: Icons.format_list_numbered_rounded,
                ),
              ),
              _Divider(),
              Expanded(
                child: _StatItem(
                  label: 'Rata-rata/Hari',
                  value: stats.rataRataPerHari.toStringAsFixed(1),
                  icon: Icons.trending_up_rounded,
                ),
              ),
              _Divider(),
              Expanded(
                child: _StatItem(
                  label: 'Juz Dibaca',
                  value: '${_juzDibaca(stats)}',
                  icon: Icons.auto_stories_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  int _juzDibaca(ReadingStats stats) {
    return stats.progressPerJuz.values.where((p) => p > 0).length;
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
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(icon, color: AppColors.onPrimary.withValues(alpha: 0.8), size: 18),
        const SizedBox(height: AppDimens.spaceXS),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            color: AppColors.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.onPrimary.withValues(alpha: 0.7),
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 40,
      color: AppColors.onPrimary.withValues(alpha: 0.2),
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
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.local_fire_department_rounded,
            color: Colors.orange,
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
