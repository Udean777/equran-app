import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/core/widgets/luxury_card.dart';
import 'package:equran_app/features/statistik_shalat/domain/entities/shalat_log.dart';
import 'package:equran_app/features/statistik_shalat/presentation/constants/statistik_shalat_constants.dart';
import 'package:equran_app/features/statistik_shalat/presentation/constants/statistik_shalat_strings.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Bar chart statistik shalat 7 hari terakhir.
class ShalatWeeklyStatsSection extends StatelessWidget {
  const ShalatWeeklyStatsSection({
    required this.dailyStats,
    required this.totalTepatWaktu,
    required this.totalQadha,
    required this.totalTidakShalat,
    required this.persentaseTepatWaktu,
    super.key,
  });

  final List<ShalatDayStats> dailyStats;
  final int totalTepatWaktu;
  final int totalQadha;
  final int totalTidakShalat;
  final double persentaseTepatWaktu;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.pagePadding),
      child: LuxuryCard(
        radius: AppDimens.radiusXL,
        hasShadow: true,
        padding: const EdgeInsets.all(AppDimens.cardPaddingLG),
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
                  StatistikShalatStrings.weeklyStatsTitle,
                  style: AppTypography.serifHeadingSmall.copyWith(
                    color: context.isDark
                        ? AppColors.onSurfaceDark
                        : AppColors.textPrimary,
                    fontSize: 15,
                  ),
                ),
                const Spacer(),
                Text(
                  '${(persentaseTepatWaktu * 100).toStringAsFixed(0)}%',
                  style: AppTypography.serifHeadingSmall.copyWith(
                    color: context.isDark
                        ? AppColors.primaryLighter
                        : AppColors.primary,
                    fontSize: 18,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppDimens.spaceXS),

            Text(
              StatistikShalatStrings.labelTepatWaktu.toLowerCase(),
              style: TextStyle(
                fontSize: 11,
                color: context.isDark
                    ? AppColors.onSurfaceDarkVariant
                    : AppColors.textTertiary,
              ),
            ),

            const SizedBox(height: AppDimens.spaceMD),

            // Summary chips
            Row(
              children: [
                _SummaryChip(
                  label: '$totalTepatWaktu',
                  sublabel: StatistikShalatStrings.labelTepatWaktu,
                  color: AppColors.success,
                  isDark: context.isDark,
                ),
                const SizedBox(width: AppDimens.spaceSM),
                _SummaryChip(
                  label: '$totalQadha',
                  sublabel: StatistikShalatStrings.labelQadha,
                  color: AppColors.warning,
                  isDark: context.isDark,
                ),
                const SizedBox(width: AppDimens.spaceSM),
                _SummaryChip(
                  label: '$totalTidakShalat',
                  sublabel: StatistikShalatStrings.labelTidakShalat,
                  color: AppColors.error,
                  isDark: context.isDark,
                ),
              ],
            ),

            if (dailyStats.isNotEmpty) ...[
              const SizedBox(height: AppDimens.spaceMD),
              Container(
                height: 1,
                color: context.isDark
                    ? AppColors.outlineDark
                    : AppColors.outlineVariant,
              ),
              const SizedBox(height: AppDimens.spaceMD),
              _BarChart(dailyStats: dailyStats, isDark: context.isDark),
            ],
          ],
        ),
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({
    required this.label,
    required this.sublabel,
    required this.color,
    required this.isDark,
  });

  final String label;
  final String sublabel;
  final Color color;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spaceSM,
          vertical: AppDimens.spaceXS,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: isDark ? 0.12 : 0.08),
          borderRadius: BorderRadius.circular(AppDimens.radiusMD),
          border: Border.all(
            color: color.withValues(alpha: 0.25),
          ),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: color,
              ),
            ),
            Text(
              sublabel,
              style: TextStyle(
                fontSize: 10,
                color: isDark
                    ? AppColors.onSurfaceDarkVariant
                    : AppColors.textTertiary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _BarChart extends StatelessWidget {
  const _BarChart({required this.dailyStats, required this.isDark});

  final List<ShalatDayStats> dailyStats;
  final bool isDark;

  static final _dayFormat = DateFormat('E', 'id_ID');

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: dailyStats.map((day) {
          final date = DateTime.tryParse(day.date);
          final dayLabel = date != null ? _dayFormat.format(date) : '';
          return _Bar(dayStats: day, dayLabel: dayLabel, isDark: isDark);
        }).toList(),
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({
    required this.dayStats,
    required this.dayLabel,
    required this.isDark,
  });

  final ShalatDayStats dayStats;
  final String dayLabel;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    const maxHeight = 72.0;
    const barWidth = 28.0;

    final tepatWaktu = dayStats.jumlahTepatWaktu;
    final qadha = dayStats.jumlahQadha;
    final total = tepatWaktu + qadha;

    final tepatHeight =
        (tepatWaktu / StatistikShalatConstants.totalWaktuShalat) * maxHeight;
    final qadhHeight =
        (qadha / StatistikShalatConstants.totalWaktuShalat) * maxHeight;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (total > 0)
          Text(
            '$total',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.onSurfaceDark : AppColors.textPrimary,
            ),
          ),
        const SizedBox(height: 2),
        SizedBox(
          width: barWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (qadhHeight > 0)
                Container(
                  height: qadhHeight,
                  decoration: BoxDecoration(
                    color: AppColors.warning,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(
                        tepatHeight == 0 ? AppDimens.radiusSM : 0,
                      ),
                      topRight: Radius.circular(
                        tepatHeight == 0 ? AppDimens.radiusSM : 0,
                      ),
                    ),
                  ),
                ),
              if (tepatHeight > 0)
                Container(
                  height: tepatHeight,
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(
                        qadhHeight == 0 ? AppDimens.radiusSM : 0,
                      ),
                      topRight: Radius.circular(
                        qadhHeight == 0 ? AppDimens.radiusSM : 0,
                      ),
                    ),
                  ),
                ),
              if (total == 0)
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.outlineDark
                        : AppColors.outlineVariant,
                    borderRadius: BorderRadius.circular(AppDimens.radiusSM),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppDimens.spaceXS),
        Text(
          dayLabel,
          style: TextStyle(
            fontSize: 10,
            color: isDark
                ? AppColors.onSurfaceDarkVariant
                : AppColors.textTertiary,
          ),
        ),
      ],
    );
  }
}
