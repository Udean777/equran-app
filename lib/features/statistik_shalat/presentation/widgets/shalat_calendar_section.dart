import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/features/statistik_shalat/domain/entities/shalat_log.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

/// Kalender bulanan dengan indikator warna per hari berdasarkan jumlah shalat.
class ShalatCalendarSection extends StatefulWidget {
  const ShalatCalendarSection({
    required this.statsByDate,
    required this.onDayTap,
    super.key,
  });

  final Map<String, ShalatDayStats> statsByDate;
  final void Function(DateTime date, ShalatDayStats stats) onDayTap;

  @override
  State<ShalatCalendarSection> createState() => _ShalatCalendarSectionState();
}

class _ShalatCalendarSectionState extends State<ShalatCalendarSection> {
  DateTime _focusedDay = DateTime.now();
  static final _dateFormat = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;
    final borderColor = isDark
        ? AppColors.outlineDark
        : AppColors.outlineVariant;
    final textColor = isDark ? AppColors.onSurfaceDark : AppColors.textPrimary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.pagePadding),
      child: Container(
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
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimens.cardPaddingLG,
                AppDimens.cardPaddingLG,
                AppDimens.cardPaddingLG,
                AppDimens.spaceSM,
              ),
              child: Row(
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
                    'Riwayat Shalat',
                    style: AppTypography.serifHeadingSmall.copyWith(
                      color: textColor,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              height: 1,
              margin: const EdgeInsets.symmetric(
                horizontal: AppDimens.cardPaddingLG,
              ),
              color: borderColor,
            ),

            TableCalendar<ShalatDayStats>(
              firstDay: DateTime.utc(2024),
              lastDay: DateTime.now().add(const Duration(days: 1)),
              focusedDay: _focusedDay,
              startingDayOfWeek: StartingDayOfWeek.monday,
              availableGestures: AvailableGestures.horizontalSwipe,
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: AppTypography.serifHeadingSmall.copyWith(
                  color: textColor,
                  fontSize: 14,
                ),
                leftChevronIcon: Icon(
                  Icons.chevron_left_rounded,
                  color: isDark
                      ? AppColors.onSurfaceDarkVariant
                      : AppColors.textSecondary,
                ),
                rightChevronIcon: Icon(
                  Icons.chevron_right_rounded,
                  color: isDark
                      ? AppColors.onSurfaceDarkVariant
                      : AppColors.textSecondary,
                ),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                  fontSize: 11,
                  color: isDark
                      ? AppColors.onSurfaceDarkVariant
                      : AppColors.textTertiary,
                ),
                weekendStyle: TextStyle(
                  fontSize: 11,
                  color: isDark
                      ? AppColors.onSurfaceDarkVariant
                      : AppColors.textTertiary,
                ),
              ),
              calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
                cellMargin: const EdgeInsets.all(2),
                defaultTextStyle: TextStyle(color: textColor, fontSize: 12),
                weekendTextStyle: TextStyle(color: textColor, fontSize: 12),
                todayDecoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.25),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
              onPageChanged: (focusedDay) {
                setState(() => _focusedDay = focusedDay);
              },
              onDaySelected: (selectedDay, focusedDay) {
                final dateKey = _dateFormat.format(selectedDay);
                final stats =
                    widget.statsByDate[dateKey] ??
                    ShalatDayStats(date: dateKey);
                widget.onDayTap(selectedDay, stats);
              },
              calendarBuilders: CalendarBuilders<ShalatDayStats>(
                defaultBuilder: (context, day, focusedDay) =>
                    _buildDayCell(day, isToday: false, isDark: isDark),
                todayBuilder: (context, day, focusedDay) =>
                    _buildDayCell(day, isToday: true, isDark: isDark),
              ),
            ),

            const SizedBox(height: AppDimens.spaceSM),
            _Legend(isDark: isDark),
            const SizedBox(height: AppDimens.spaceMD),
          ],
        ),
      ),
    );
  }

  Widget _buildDayCell(
    DateTime day, {
    required bool isToday,
    required bool isDark,
  }) {
    final dateKey = _dateFormat.format(day);
    final stats = widget.statsByDate[dateKey];
    final color = _colorForStats(stats);
    final textColor = isDark ? AppColors.onSurfaceDark : AppColors.textPrimary;

    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: isToday ? Border.all(color: AppColors.gold, width: 1.5) : null,
      ),
      child: Center(
        child: Text(
          '${day.day}',
          style: TextStyle(
            color: stats != null && stats.hasData ? Colors.white : textColor,
            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Color _colorForStats(ShalatDayStats? stats) {
    if (stats == null || !stats.hasData) return Colors.transparent;
    final tepatWaktu = stats.jumlahTepatWaktu;
    if (tepatWaktu == 5) return AppColors.success;
    if (tepatWaktu >= 3) return AppColors.warning;
    return AppColors.error;
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.cardPaddingLG),
      child: Wrap(
        spacing: AppDimens.spaceMD,
        runSpacing: AppDimens.spaceXS,
        children: [
          _LegendItem(
            color: AppColors.success,
            label: '5 tepat waktu',
            isDark: isDark,
          ),
          _LegendItem(
            color: AppColors.warning,
            label: '3–4 tepat waktu',
            isDark: isDark,
          ),
          _LegendItem(
            color: AppColors.error,
            label: '<3 tepat waktu',
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.label,
    required this.isDark,
  });

  final Color color;
  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: AppDimens.spaceXS),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isDark
                ? AppColors.onSurfaceDarkVariant
                : AppColors.textTertiary,
          ),
        ),
      ],
    );
  }
}
