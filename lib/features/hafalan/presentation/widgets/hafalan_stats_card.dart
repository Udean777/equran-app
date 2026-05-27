import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/core/widgets/luxury_divider.dart';
import 'package:equran_app/core/widgets/primary_gradient_card.dart';
import 'package:equran_app/core/widgets/stats_row.dart';
import 'package:equran_app/features/hafalan/domain/entities/hafalan_stats.dart';
import 'package:flutter/material.dart';

class HafalanStatsCard extends StatelessWidget {
  const HafalanStatsCard({required this.stats, super.key});

  final HafalanStats stats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final persen = (stats.persentaseQuran * 100).toStringAsFixed(1);

    return PrimaryGradientCard(
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
                  borderRadius: BorderRadius.circular(AppDimens.radiusMD),
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
                        color: AppColors.onPrimary.withValues(alpha: 0.7),
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
            borderRadius: BorderRadius.circular(AppDimens.radiusFull),
            child: LinearProgressIndicator(
              value: stats.persentaseQuran,
              minHeight: 6,
              backgroundColor: AppColors.onPrimary.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
            ),
          ),

          const SizedBox(height: AppDimens.spaceMD),
          const GoldDivider(verticalMargin: 0),
          const SizedBox(height: AppDimens.spaceMD),

          // Stats row
          StatsRow(
            items: [
              StatRowItem(
                label: 'Surat Hafal',
                value: stats.totalSuratSelesai.toString(),
                icon: Icons.check_circle_outline_rounded,
              ),
              StatRowItem(
                label: 'Sedang Dihafal',
                value: stats.suratSedangDihafal.toString(),
                icon: Icons.pending_outlined,
              ),
              StatRowItem(
                label: "Perlu Muraja'ah",
                value: stats.suratPerluMurajaah.toString(),
                icon: Icons.refresh_rounded,
              ),
              StatRowItem(
                label: 'Total Ayat',
                value: stats.totalAyatHafal.toString(),
                icon: Icons.format_list_numbered_rounded,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
