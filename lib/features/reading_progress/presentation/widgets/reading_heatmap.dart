import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/reading_progress/domain/entities/reading_history.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Heatmap aktivitas membaca 90 hari terakhir (GitHub contribution style).
/// Custom GridView — tidak pakai library eksternal.
class ReadingHeatmap extends StatelessWidget {
  const ReadingHeatmap({
    required this.last90Days, super.key,
  });

  final List<ReadingHistory> last90Days;

  static final _dayFormat = DateFormat('E', 'id_ID');

  // Threshold warna berdasarkan jumlah ayat
  static const _thresholds = [0, 5, 15, 30, 50];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (last90Days.isEmpty) return const SizedBox.shrink();

    // Kelompokkan per minggu (7 hari per kolom)
    final weeks = _groupByWeek(last90Days);

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
          Row(
            children: [
              const Icon(
                Icons.grid_view_rounded,
                size: AppDimens.iconSM + 2,
                color: AppColors.primary,
              ),
              const SizedBox(width: AppDimens.spaceSM),
              Text(
                'Aktivitas Membaca (90 Hari)',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceMD),

          // Day labels (Sen, Sel, Rab, ...)
          Row(
            children: [
              const SizedBox(width: 28), // offset untuk label hari
              ...List.generate(7, (i) {
                final day = DateTime(2026, 1, 5 + i); // Senin = 5 Jan 2026
                return SizedBox(
                  width: 14,
                  child: Text(
                    _dayFormat.format(day).substring(0, 1),
                    style: const TextStyle(fontSize: 9),
                    textAlign: TextAlign.center,
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 4),

          // Grid heatmap
          RepaintBoundary(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true, // tampilkan hari terbaru di kanan
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: weeks.map((week) => _WeekColumn(week: week)).toList(),
              ),
            ),
          ),

          const SizedBox(height: AppDimens.spaceSM),

          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text('Sedikit', style: TextStyle(fontSize: 10)),
              const SizedBox(width: AppDimens.spaceXS),
              ..._thresholds.map(
                (t) => Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.only(right: 2),
                  decoration: BoxDecoration(
                    color: _colorForCount(t),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(width: AppDimens.spaceXS),
              const Text('Banyak', style: TextStyle(fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }

  /// Kelompokkan list hari ke dalam minggu-minggu (7 hari per minggu).
  List<List<ReadingHistory>> _groupByWeek(List<ReadingHistory> days) {
    final weeks = <List<ReadingHistory>>[];
    var week = <ReadingHistory>[];

    for (final day in days) {
      week.add(day);
      if (week.length == 7) {
        weeks.add(week);
        week = [];
      }
    }
    if (week.isNotEmpty) weeks.add(week);

    return weeks;
  }

  static Color _colorForCount(int count) {
    if (count == 0) return AppColors.outline.withValues(alpha: 0.4);
    if (count < 5) return AppColors.primary.withValues(alpha: 0.2);
    if (count < 15) return AppColors.primary.withValues(alpha: 0.4);
    if (count < 30) return AppColors.primary.withValues(alpha: 0.65);
    if (count < 50) return AppColors.primary.withValues(alpha: 0.85);
    return AppColors.primary;
  }
}

class _WeekColumn extends StatelessWidget {
  const _WeekColumn({required this.week});

  final List<ReadingHistory> week;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: week.map((day) => _DayCell(history: day)).toList(),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({required this.history});

  final ReadingHistory history;

  static final _tooltipFormat = DateFormat('d MMM yyyy', 'id_ID');

  @override
  Widget build(BuildContext context) {
    final count = history.jumlahAyat;
    final color = ReadingHeatmap._colorForCount(count);
    final date = DateTime.tryParse(history.date);
    final tooltip = date != null
        ? '${_tooltipFormat.format(date)}: $count ayat'
        : '$count ayat';

    return Tooltip(
      message: tooltip,
      child: Container(
        width: 12,
        height: 12,
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
