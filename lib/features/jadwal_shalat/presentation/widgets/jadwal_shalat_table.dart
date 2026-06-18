import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
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
    final isDark = theme.brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;
    final headerBg = isDark
        ? AppColors.surfaceDarkVariant
        : AppColors.surfaceVariant;
    final borderColor = isDark
        ? AppColors.outlineDark
        : AppColors.outlineVariant;

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
            headingTextStyle: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: isDark
                  ? AppColors.onSurfaceDarkVariant
                  : AppColors.textSecondary,
              letterSpacing: 0.3,
            ),
            dataTextStyle: theme.textTheme.bodySmall?.copyWith(
              color: isDark ? AppColors.onSurfaceDark : AppColors.textPrimary,
              fontSize: 12,
            ),
            columns: _headers.map((h) => DataColumn(label: Text(h))).toList(),
            rows: entries.map((e) {
              final isToday = e.tanggalLengkap == todayTanggalLengkap;
              return DataRow(
                color: isToday
                    ? WidgetStateProperty.all(
                        isDark
                            ? AppColors.primaryDark.withValues(alpha: 0.4)
                            : AppColors.primaryContainer,
                      )
                    : WidgetStateProperty.all(Colors.transparent),
                cells: [
                  DataCell(
                    _cell(e.tanggal.toString(), isToday, isDark, bold: true),
                  ),
                  DataCell(_cell(e.hari.substring(0, 3), isToday, isDark)),
                  DataCell(_cell(e.imsak, isToday, isDark)),
                  DataCell(_cell(e.subuh, isToday, isDark)),
                  DataCell(_cell(e.terbit, isToday, isDark)),
                  DataCell(_cell(e.dhuha, isToday, isDark)),
                  DataCell(_cell(e.dzuhur, isToday, isDark)),
                  DataCell(_cell(e.ashar, isToday, isDark)),
                  DataCell(_cell(e.maghrib, isToday, isDark)),
                  DataCell(_cell(e.isya, isToday, isDark)),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _cell(
    String text,
    bool isToday,
    bool isDark, {
    bool bold = false,
  }) {
    final color = isToday
        ? (isDark ? AppColors.primaryLighter : AppColors.primary)
        : (isDark ? AppColors.onSurfaceDark : AppColors.textPrimary);

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
