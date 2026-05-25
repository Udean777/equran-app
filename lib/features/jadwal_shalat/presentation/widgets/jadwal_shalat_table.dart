import 'package:equran_app/features/jadwal_shalat/domain/entities/jadwal_shalat_entry.dart';
import 'package:flutter/material.dart';

class JadwalShalatTable extends StatelessWidget {
  const JadwalShalatTable({
    required this.entries,
    required this.todayTanggalLengkap,
    super.key,
  });

  final List<JadwalShalatEntry> entries;
  final String todayTanggalLengkap;

  static const _headers = [
    'Tgl',
    'Hari',
    'Imsak',
    'Subuh',
    'Terbit',
    'Dhuha',
    'Dzuhur',
    'Ashar',
    'Maghrib',
    'Isya',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(
            colorScheme.surfaceContainerHighest,
          ),
          dataRowMinHeight: 36,
          dataRowMaxHeight: 40,
          horizontalMargin: 12,
          columnSpacing: 12,
          headingTextStyle: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurfaceVariant,
          ),
          columns: _headers.map((h) => DataColumn(label: Text(h))).toList(),
          rows: entries.map((e) {
            final isToday = e.tanggalLengkap == todayTanggalLengkap;
            return DataRow(
              color: isToday
                  ? WidgetStateProperty.all(
                      colorScheme.primaryContainer.withValues(alpha: 0.4),
                    )
                  : null,
              cells: [
                DataCell(
                  Text(
                    '${e.tanggal}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: isToday ? FontWeight.w700 : FontWeight.normal,
                      color: isToday ? colorScheme.primary : null,
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    e.hari,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: isToday ? FontWeight.w600 : FontWeight.normal,
                      color: isToday ? colorScheme.primary : null,
                    ),
                  ),
                ),
                DataCell(_TimeCell(time: e.imsak, isToday: isToday)),
                DataCell(_TimeCell(time: e.subuh, isToday: isToday)),
                DataCell(_TimeCell(time: e.terbit, isToday: isToday)),
                DataCell(_TimeCell(time: e.dhuha, isToday: isToday)),
                DataCell(_TimeCell(time: e.dzuhur, isToday: isToday)),
                DataCell(_TimeCell(time: e.ashar, isToday: isToday)),
                DataCell(_TimeCell(time: e.maghrib, isToday: isToday)),
                DataCell(_TimeCell(time: e.isya, isToday: isToday)),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _TimeCell extends StatelessWidget {
  const _TimeCell({required this.time, required this.isToday});

  final String time;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Text(
      time,
      style: theme.textTheme.bodySmall?.copyWith(
        fontWeight: isToday ? FontWeight.w600 : FontWeight.normal,
        color: isToday ? colorScheme.primary : null,
      ),
    );
  }
}
