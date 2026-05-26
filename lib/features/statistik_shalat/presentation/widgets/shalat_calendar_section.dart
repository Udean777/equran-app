import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
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

  /// Map tanggal (yyyy-MM-dd) → ShalatDayStats.
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
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceMD,
        vertical: AppDimens.spaceSM,
      ),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppDimens.radiusMD),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppDimens.spaceMD),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_month_rounded,
                  size: AppDimens.iconSM + 2,
                  color: AppColors.primary,
                ),
                const SizedBox(width: AppDimens.spaceSM),
                Text(
                  'Riwayat Shalat',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          TableCalendar<ShalatDayStats>(
            firstDay: DateTime.utc(2024),
            lastDay: DateTime.now().add(const Duration(days: 1)),
            focusedDay: _focusedDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            availableGestures: AvailableGestures.horizontalSwipe,
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              leftChevronIcon: Icon(Icons.chevron_left_rounded),
              rightChevronIcon: Icon(Icons.chevron_right_rounded),
            ),
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              cellMargin: const EdgeInsets.all(2),
              todayDecoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.3),
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
                  widget.statsByDate[dateKey] ?? ShalatDayStats(date: dateKey);
              widget.onDayTap(selectedDay, stats);
            },
            calendarBuilders: CalendarBuilders<ShalatDayStats>(
              defaultBuilder: (context, day, focusedDay) =>
                  _buildDayCell(day, isToday: false),
              todayBuilder: (context, day, focusedDay) =>
                  _buildDayCell(day, isToday: true),
            ),
          ),
          const SizedBox(height: AppDimens.spaceSM),
          const _Legend(),
          const SizedBox(height: AppDimens.spaceSM),
        ],
      ),
    );
  }

  Widget _buildDayCell(DateTime day, {required bool isToday}) {
    final dateKey = _dateFormat.format(day);
    final stats = widget.statsByDate[dateKey];
    final color = _colorForStats(stats);

    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: isToday ? Border.all(color: AppColors.primary, width: 2) : null,
      ),
      child: Center(
        child: Text(
          '${day.day}',
          style: TextStyle(
            color: stats != null && stats.hasData ? Colors.white : null,
            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
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
  const _Legend();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimens.spaceMD),
      child: Wrap(
        spacing: AppDimens.spaceMD,
        runSpacing: AppDimens.spaceXS,
        children: [
          _LegendItem(color: AppColors.success, label: '5 tepat waktu'),
          _LegendItem(color: AppColors.warning, label: '3–4 tepat waktu'),
          _LegendItem(color: AppColors.error, label: '<3 tepat waktu'),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: AppDimens.spaceXS),
        Text(
          label,
          style: const TextStyle(fontSize: 11),
        ),
      ],
    );
  }
}
