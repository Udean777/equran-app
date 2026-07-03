import 'dart:async';
import 'package:equran_app/core/router/app_routes.dart';
import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/core/widgets/luxury_card.dart';
import 'package:equran_app/features/jadwal_shalat/domain/entities/jadwal_shalat_entry.dart';
import 'package:equran_app/features/statistik_shalat/domain/entities/shalat_log.dart';
import 'package:equran_app/features/statistik_shalat/presentation/constants/statistik_shalat_strings.dart';
import 'package:equran_app/features/statistik_shalat/presentation/widgets/shalat_status_buttons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// Checklist 5 waktu shalat untuk hari ini.
class ShalatChecklistSection extends StatelessWidget {
  const ShalatChecklistSection({
    required this.today,
    required this.onStatusChanged,
    this.todayJadwal,
    super.key,
  });

  final ShalatDayStats today;
  final JadwalShalatEntry? todayJadwal;
  final void Function(WaktuShalat waktu, ShalatStatus status) onStatusChanged;

  Future<void> _startSholatMode(
    BuildContext context,
    WaktuShalat waktu,
    bool isTepatWaktuDisabled,
  ) async {
    final result = await context.push<String>(
      '${AppRoutes.shalatFocus}?waktu=${waktu.name}',
    );
    if (result == 'success') {
      final status = isTepatWaktuDisabled
          ? ShalatStatus.qadha
          : ShalatStatus.tepatWaktu;
      onStatusChanged(waktu, status);
    } else if (result == 'abort') {
      onStatusChanged(waktu, ShalatStatus.tidakShalat);
    }
  }

  String? _getWaktuTimeStr(WaktuShalat waktu, JadwalShalatEntry entry) =>
      switch (waktu) {
        WaktuShalat.subuh => entry.subuh,
        WaktuShalat.dzuhur => entry.dzuhur,
        WaktuShalat.ashar => entry.ashar,
        WaktuShalat.maghrib => entry.maghrib,
        WaktuShalat.isya => entry.isya,
      };

  String? _getWaktuEndStr(WaktuShalat waktu, JadwalShalatEntry entry) =>
      switch (waktu) {
        WaktuShalat.subuh => entry.terbit,
        WaktuShalat.dzuhur => entry.ashar,
        WaktuShalat.ashar => entry.maghrib,
        WaktuShalat.maghrib => entry.isya,
        WaktuShalat.isya => '23:59', // Simplified for same day
      };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.pagePadding,
        AppDimens.spaceSM,
        AppDimens.pagePadding,
        AppDimens.spaceXS,
      ),
      child: LuxuryCard(
        radius: AppDimens.radiusXL,
        hasShadow: true,
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimens.cardPadding,
                AppDimens.cardPadding,
                AppDimens.cardPadding,
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
                    StatistikShalatStrings.sectionChecklistHariIni,
                    style: AppTypography.serifHeadingSmall.copyWith(
                      color: context.isDark
                          ? AppColors.onSurfaceDark
                          : AppColors.textPrimary,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),

            // Divider
            Container(
              height: 1,
              margin: const EdgeInsets.symmetric(
                horizontal: AppDimens.cardPadding,
              ),
              color: context.isDark
                  ? AppColors.outlineDark
                  : AppColors.outlineVariant,
            ),

            // Rows
            ...WaktuShalat.values.map((waktu) {
              var isTepatWaktuDisabled = false;
              var isBeforeStart = false;

              if (todayJadwal != null &&
                  today.date ==
                      DateFormat('yyyy-MM-dd').format(DateTime.now())) {
                final startStr = _getWaktuTimeStr(waktu, todayJadwal!);
                final endStr = _getWaktuEndStr(waktu, todayJadwal!);

                if (startStr != null && endStr != null) {
                  final now = DateTime.now();

                  final startParts = startStr.split(':');
                  final endParts = endStr.split(':');

                  if (startParts.length == 2 && endParts.length == 2) {
                    final startHour = int.tryParse(startParts[0]) ?? 0;
                    final startMinute = int.tryParse(startParts[1]) ?? 0;
                    final endHour = int.tryParse(endParts[0]) ?? 0;
                    final endMinute = int.tryParse(endParts[1]) ?? 0;

                    final startTime = DateTime(
                      now.year,
                      now.month,
                      now.day,
                      startHour,
                      startMinute,
                    );

                    final endTime = DateTime(
                      now.year,
                      now.month,
                      now.day,
                      endHour,
                      endMinute,
                    );

                    if (now.isBefore(startTime)) {
                      isBeforeStart = true;
                    } else if (now.isAfter(endTime)) {
                      isTepatWaktuDisabled = true;
                    }
                  }
                }
              }

              return _ShalatRow(
                waktu: waktu,
                log: today.logFor(waktu),
                isDark: context.isDark,
                isBeforeStart: isBeforeStart,
                isTepatWaktuDisabled: isTepatWaktuDisabled,
                onStatusChanged: (status) {
                  if (isBeforeStart) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Belum masuk waktu sholat.'),
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 2),
                      ),
                    );
                    return;
                  }
                  onStatusChanged(waktu, status);
                },
                onStartSholat: () {
                  if (isBeforeStart) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Belum masuk waktu sholat.'),
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 2),
                      ),
                    );
                    return;
                  }
                  unawaited(
                    _startSholatMode(context, waktu, isTepatWaktuDisabled),
                  );
                },
              );
            }),

            const SizedBox(height: AppDimens.spaceXS),
          ],
        ),
      ),
    );
  }
}

class _ShalatRow extends StatelessWidget {
  const _ShalatRow({
    required this.waktu,
    required this.log,
    required this.isDark,
    required this.isBeforeStart,
    required this.isTepatWaktuDisabled,
    required this.onStatusChanged,
    required this.onStartSholat,
  });

  final WaktuShalat waktu;
  final ShalatLog log;
  final bool isDark;
  final bool isBeforeStart;
  final bool isTepatWaktuDisabled;
  final void Function(ShalatStatus status) onStatusChanged;
  final VoidCallback onStartSholat;

  @override
  Widget build(BuildContext context) {
    final currentStatus = log.status;
    final borderColor = _borderColor(currentStatus);
    final hasBorder = currentStatus != ShalatStatus.belumDicatat;

    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppDimens.cardPadding,
        AppDimens.spaceXS,
        AppDimens.cardPadding,
        AppDimens.spaceXS,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceMD,
        vertical: AppDimens.spaceSM,
      ),
      decoration: BoxDecoration(
        color: hasBorder
            ? borderColor.withValues(alpha: isDark ? 0.08 : 0.05)
            : (isDark
                  ? AppColors.surfaceDarkVariant
                  : AppColors.surfaceVariant),
        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
        border: Border.all(
          color: hasBorder
              ? borderColor.withValues(alpha: 0.4)
              : (isDark ? AppColors.outlineDark : AppColors.outlineVariant),
        ),
      ),
      child: Row(
        children: [
          // Icon waktu
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _iconBgColor(currentStatus),
              borderRadius: BorderRadius.circular(AppDimens.radiusMD),
            ),
            child: Icon(
              _waktuIcon(waktu),
              size: AppDimens.iconSM + 2,
              color: _iconColor(currentStatus),
            ),
          ),
          const SizedBox(width: AppDimens.spaceMD),
          // Nama waktu
          Expanded(
            child: Text(
              waktu.displayName(),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: isDark ? AppColors.onSurfaceDark : AppColors.textPrimary,
              ),
            ),
          ),
          // Status buttons
          ShalatStatusButtons(
            currentStatus: currentStatus,
            isBeforeStart: isBeforeStart,
            isTepatWaktuDisabled: isTepatWaktuDisabled,
            onStatusChanged: onStatusChanged,
            onStartSholat: onStartSholat,
          ),
        ],
      ),
    );
  }

  Color _borderColor(ShalatStatus status) => switch (status) {
    ShalatStatus.tepatWaktu => AppColors.success,
    ShalatStatus.qadha => AppColors.warning,
    ShalatStatus.tidakShalat => AppColors.error,
    ShalatStatus.belumDicatat => AppColors.outline,
  };

  Color _iconBgColor(ShalatStatus status) => switch (status) {
    ShalatStatus.tepatWaktu => AppColors.success.withValues(alpha: 0.12),
    ShalatStatus.qadha => AppColors.warning.withValues(alpha: 0.12),
    ShalatStatus.tidakShalat => AppColors.error.withValues(alpha: 0.12),
    ShalatStatus.belumDicatat => AppColors.primary.withValues(alpha: 0.08),
  };

  Color _iconColor(ShalatStatus status) => switch (status) {
    ShalatStatus.tepatWaktu => AppColors.success,
    ShalatStatus.qadha => AppColors.warning,
    ShalatStatus.tidakShalat => AppColors.error,
    ShalatStatus.belumDicatat => AppColors.primary,
  };

  IconData _waktuIcon(WaktuShalat waktu) => switch (waktu) {
    WaktuShalat.subuh => Icons.wb_twilight_rounded,
    WaktuShalat.dzuhur => Icons.wb_sunny_rounded,
    WaktuShalat.ashar => Icons.wb_cloudy_rounded,
    WaktuShalat.maghrib => Icons.nights_stay_rounded,
    WaktuShalat.isya => Icons.dark_mode_rounded,
  };
}
