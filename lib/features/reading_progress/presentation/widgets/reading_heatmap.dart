import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/features/reading_progress/domain/entities/reading_history.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Heatmap aktivitas membaca 90 hari terakhir (GitHub contribution style).
class ReadingHeatmap extends StatelessWidget {
  const ReadingHeatmap({required this.last90Days, super.key});

  final List<ReadingHistory> last90Days;

  static final _dayFormat = DateFormat('E', 'id_ID');
  static const _thresholds = [0, 5, 15, 30, 50];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;
    final borderColor =
        isDark ? AppColors.outlineDark : AppColors.outlineVariant;

    if (last90Days.isEmpty) return const SizedBox.shrink();

    final weeks = _groupByWeek(last90Days);

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
              color:
                  AppColors.primary.withValues(alpha: isDark ? 0.04 : 0.06),
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
                    borderRadius:
                        BorderRadius.circular(AppDimens.radiusFull),
                  ),
                ),
                const SizedBox(width: AppDimens.spaceSM),
                Text(
                  'Aktivitas Membaca (90 Hari)',
                  style: AppTypography.serifHeadingSmall.copyWith(
                    color: isDark
                        ? AppColors.onSurfaceDark
                        : AppColors.textPrimary,
                    fontSize: 15,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppDimens.spaceMD),

            // Day labels
            Row(
              children: [
                const SizedBox(width: 28),
                ...List.generate(7, (i) {
                  final day = DateTime(2026, 1, 5 + i);
                  return SizedBox(
                    width: 14,
                    child: Text(
                      _dayFormat.format(day).substring(0, 1),
                      style: TextStyle(
                        fontSize: 9,
                        color: isDark
                            ? AppColors.onSurfaceDarkVariant
                            : AppColors.textTertiary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }),
              ],
            ),
            const SizedBox(height: 4),

            // Grid
            RepaintBoundary(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                reverse: true,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: weeks
                      .map((week) => _WeekColumn(week: week, isDark: isDark))
                      .toList(),
                ),
              ),
            ),

            const SizedBox(height: AppDimens.spaceSM),

            // Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Sedikit',
                  style: TextStyle(
                    fontSize: 10,
                    color: isDark
                        ? AppColors.onSurfaceDarkVariant
                        : AppColors.textTertiary,
                  ),
                ),
                const SizedBox(width: AppDimens.spaceXS),
                ..._thresholds.map(
                  (t) => Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.only(right: 2),
                    decoration: BoxDecoration(
                      color: _colorForCount(t, isDark),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(width: AppDimens.spaceXS),
                Text(
                  'Banyak',
                  style: TextStyle(
                    fontSize: 10,
                    color: isDark
                        ? AppColors.onSurfaceDarkVariant
                        : AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

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

  static Color _colorForCount(int count, bool isDark) {
    if (count == 0) {
      return isDark
          ? AppColors.outlineDark
          : AppColors.outlineVariant;
    }
    if (count < 5) return AppColors.primary.withValues(alpha: 0.2);
    if (count < 15) return AppColors.primary.withValues(alpha: 0.4);
    if (count < 30) return AppColors.primary.withValues(alpha: 0.65);
    if (count < 50) return AppColors.primary.withValues(alpha: 0.85);
    return AppColors.primary;
  }
}

class _WeekColumn extends StatelessWidget {
  const _WeekColumn({required this.week, required this.isDark});

  final List<ReadingHistory> week;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: week
          .map((day) => _DayCell(history: day, isDark: isDark))
          .toList(),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({required this.history, required this.isDark});

  final ReadingHistory history;
  final bool isDark;

  static final _tooltipFormat = DateFormat('d MMM yyyy', 'id_ID');

  @override
  Widget build(BuildContext context) {
    final count = history.jumlahAyat;
    final color = ReadingHeatmap._colorForCount(count, isDark);
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
