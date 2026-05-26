import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/statistik_shalat/domain/entities/shalat_log.dart';
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
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceMD,
        vertical: AppDimens.spaceSM,
      ),
      padding: const EdgeInsets.all(AppDimens.spaceMD),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppDimens.radiusMD),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Icon(
                Icons.bar_chart_rounded,
                size: AppDimens.iconSM + 2,
                color: AppColors.primary,
              ),
              const SizedBox(width: AppDimens.spaceSM),
              Text(
                'Statistik 7 Hari Terakhir',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceMD),

          // Summary chips
          Row(
            children: [
              _SummaryChip(
                label: '$totalTepatWaktu',
                sublabel: 'Tepat Waktu',
                color: AppColors.success,
              ),
              const SizedBox(width: AppDimens.spaceSM),
              _SummaryChip(
                label: '$totalQadha',
                sublabel: 'Qadha',
                color: AppColors.warning,
              ),
              const SizedBox(width: AppDimens.spaceSM),
              _SummaryChip(
                label: '$totalTidakShalat',
                sublabel: 'Tidak Shalat',
                color: AppColors.error,
              ),
              const Spacer(),
              // Persentase
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${(persentaseTepatWaktu * 100).toStringAsFixed(0)}%',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    'tepat waktu',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceMD),

          // Bar chart
          if (dailyStats.isNotEmpty) _BarChart(dailyStats: dailyStats),
        ],
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({
    required this.label,
    required this.sublabel,
    required this.color,
  });

  final String label;
  final String sublabel;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceSM,
        vertical: AppDimens.spaceXS,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimens.radiusSM),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            sublabel,
            style: const TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _BarChart extends StatelessWidget {
  const _BarChart({required this.dailyStats});

  final List<ShalatDayStats> dailyStats;

  static final _dayFormat = DateFormat('E', 'id_ID');

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: dailyStats.map((day) {
          final date = DateTime.tryParse(day.date);
          final dayLabel = date != null ? _dayFormat.format(date) : '';
          return _Bar(dayStats: day, dayLabel: dayLabel);
        }).toList(),
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.dayStats, required this.dayLabel});

  final ShalatDayStats dayStats;
  final String dayLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const maxHeight = 72.0;
    const barWidth = 28.0;

    final tepatWaktu = dayStats.jumlahTepatWaktu;
    final qadha = dayStats.jumlahQadha;
    final total = tepatWaktu + qadha;

    final tepatHeight = (tepatWaktu / 5) * maxHeight;
    final qadhHeight = (qadha / 5) * maxHeight;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Jumlah shalat label
        if (total > 0)
          Text(
            '$total',
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          ),
        const SizedBox(height: 2),
        // Bar stacked
        SizedBox(
          width: barWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Qadha (atas)
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
              // Tepat waktu (bawah)
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
              // Empty bar jika tidak ada data
              if (total == 0)
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppDimens.radiusSM),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppDimens.spaceXS),
        // Hari label
        Text(
          dayLabel,
          style: const TextStyle(fontSize: 10),
        ),
      ],
    );
  }
}
