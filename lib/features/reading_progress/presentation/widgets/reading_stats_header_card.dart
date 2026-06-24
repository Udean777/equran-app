import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/core/widgets/luxury_divider.dart';
import 'package:equran_app/core/widgets/primary_gradient_card.dart';
import 'package:equran_app/core/widgets/stats_row.dart';
import 'package:equran_app/core/widgets/streak_badge.dart';
import 'package:equran_app/features/reading_progress/domain/entities/reading_history.dart';
import 'package:equran_app/features/reading_progress/presentation/constants/reading_progress_strings.dart';
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
    return PrimaryGradientCard(
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
                  borderRadius: BorderRadius.circular(AppDimens.radiusMD),
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
                      ReadingProgressStrings.headerTitle,
                      style: TextStyle(
                        color: AppColors.onPrimary.withValues(alpha: 0.7),
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
              if (streak > 0)
                StreakBadge(
                  streak: streak,
                  variant: StreakBadgeVariant.onPrimary,
                  showLabel: false,
                ),
            ],
          ),

          const SizedBox(height: AppDimens.spaceMD),
          const GoldDivider(verticalMargin: 0),
          const SizedBox(height: AppDimens.spaceMD),

          // Stats row
          StatsRow(
            items: [
              StatRowItem(
                label: ReadingProgressStrings.totalAyat,
                value: '${stats.totalAyatRead}',
                icon: Icons.format_list_numbered_rounded,
              ),
              StatRowItem(
                label: ReadingProgressStrings.rataRataPerHari,
                value: stats.rataRataPerHari.toStringAsFixed(1),
                icon: Icons.trending_up_rounded,
              ),
              StatRowItem(
                label: ReadingProgressStrings.juzDibaca,
                value:
                    '${stats.progressPerJuz.values.where((p) => p > 0).length}',
                icon: Icons.auto_stories_rounded,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
