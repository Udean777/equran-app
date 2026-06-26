import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/context_ext.dart';
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
    final surfaceColor = context.surfaceColor;
    final headerBg = context.surfaceVariantColor;
    final borderColor = context.borderSubtleColor;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.pagePadding,
        AppDimens.spaceXS,
        AppDimens.pagePadding,
        AppDimens.spaceMD,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(AppDimens.radiusLG),
          border: Border.all(color: borderColor),
        ),
        clipBehavior: Clip.antiAlias,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(headerBg),
            headingRowHeight: 40,
            dataRowMinHeight: 36,
            dataRowMaxHeight: 40,
            horizontalMargin: AppDimens.spaceMD,
            columnSpacing: AppDimens.spaceMD,
            dividerThickness: 1,
            headingTextStyle: context.theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: context.textSecondaryColor,
              letterSpacing: 0.3,
            ),
            dataTextStyle: context.theme.textTheme.bodySmall?.copyWith(
              color: context.textPrimaryColor,
              fontSize: 12,
            ),
            columns: _headers.map((h) => DataColumn(label: Text(h))).toList(),
            rows: entries.map((e) {
              final isToday = e.tanggalLengkap == todayTanggalLengkap;
              return DataRow(
                color: isToday
                    ? WidgetStateProperty.all(
                        context.primaryContainerColor.withValues(alpha: 0.4),
                      )
                    : WidgetStateProperty.all(Colors.transparent),
                cells: [
                  DataCell(
                    _cell(context, e.tanggal.toString(), isToday, bold: true),
                  ),
                  DataCell(_cell(context, e.hari.substring(0, 3), isToday)),
                  DataCell(_cell(context, e.imsak, isToday)),
                  DataCell(_cell(context, e.subuh, isToday)),
                  DataCell(_cell(context, e.terbit, isToday)),
                  DataCell(_cell(context, e.dhuha, isToday)),
                  DataCell(_cell(context, e.dzuhur, isToday)),
                  DataCell(_cell(context, e.ashar, isToday)),
                  DataCell(_cell(context, e.maghrib, isToday)),
                  DataCell(_cell(context, e.isya, isToday)),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _cell(
    BuildContext context,
    String text,
    bool isToday, {
    bool bold = false,
  }) {
    final color = isToday
        ? context.primaryActionColor
        : context.textPrimaryColor;

    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: (isToday || bold) ? FontWeight.w600 : FontWeight.w400,
        color: color,
      ),
    );
  }
}
