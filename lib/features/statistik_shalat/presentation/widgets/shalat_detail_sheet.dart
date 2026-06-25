import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/utils/bottom_sheet_utils.dart';
import 'package:equran_app/core/utils/dialog_utils.dart';
import 'package:equran_app/features/statistik_shalat/domain/entities/shalat_log.dart';
import 'package:equran_app/features/statistik_shalat/presentation/constants/statistik_shalat_constants.dart';
import 'package:equran_app/features/statistik_shalat/presentation/constants/statistik_shalat_strings.dart';
import 'package:equran_app/features/statistik_shalat/presentation/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// Bottom sheet untuk lihat detail + edit shalat tanggal tertentu.
class ShalatDetailSheet extends ConsumerWidget {
  const ShalatDetailSheet({
    required this.date,
    required this.dayStats,
    super.key,
  });

  final DateTime date;
  final ShalatDayStats dayStats;

  static final _dateFormat = DateFormat('yyyy-MM-dd');

  static Future<void> show({
    required BuildContext context,
    required DateTime date,
    required ShalatDayStats dayStats,
  }) {
    return showAppBottomSheet<void>(
      context,
      builder: (_) => ShalatDetailSheet(date: date, dayStats: dayStats),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dateStr = _dateFormat.format(date);
    final hari = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(date);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.symmetric(vertical: AppDimens.spaceSM),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.outline,
              borderRadius: BorderRadius.circular(AppDimens.radiusFull),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.spaceMD,
              vertical: AppDimens.spaceSM,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hari,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppDimens.spaceXS),
                Text(
                  '${dayStats.jumlahTepatWaktu}/${StatistikShalatConstants.totalWaktuShalat} ${StatistikShalatStrings.labelTepatWaktu.toLowerCase()} • ${dayStats.jumlahShalat}/${StatistikShalatConstants.totalWaktuShalat} dilaksanakan',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          // Delete action
          if (dayStats.hasData)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.spaceMD,
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () async {
                    final confirmed = await showConfirmDialog(
                      context,
                      title: StatistikShalatStrings.deleteDialogTitle,
                      content: StatistikShalatStrings.deleteDialogContent,
                    );

                    if (confirmed && context.mounted) {
                      await ref
                          .read(statistikShalatViewModelProvider.notifier)
                          .deleteShalatForDate(dateStr);
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    }
                  },
                  icon: const Icon(Icons.delete_outline, size: 20),
                  label: const Text(StatistikShalatStrings.deleteConfirmButton),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.error,
                  ),
                ),
              ),
            ),
          const Divider(height: 1),
          // Shalat list
          ...WaktuShalat.values.map(
            (waktu) => _DetailRow(
              date: dateStr,
              waktu: waktu,
              log: dayStats.logFor(waktu),
            ),
          ),
          const SizedBox(height: AppDimens.spaceMD),
        ],
      ),
    );
  }
}

class _DetailRow extends ConsumerWidget {
  const _DetailRow({
    required this.date,
    required this.waktu,
    required this.log,
  });

  final String date;
  final WaktuShalat waktu;
  final ShalatLog log;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceMD,
        vertical: AppDimens.spaceXS,
      ),
      child: Row(
        children: [
          // Status indicator
          Container(
            width: 8,
            height: 36,
            decoration: BoxDecoration(
              color: _statusColor(log.status),
              borderRadius: BorderRadius.circular(AppDimens.radiusSM),
            ),
          ),
          const SizedBox(width: AppDimens.spaceMD),
          // Nama waktu + status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  waktu.label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  _statusLabel(log.status),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: _statusColor(log.status),
                  ),
                ),
              ],
            ),
          ),
          // Status dropdown
          PopupMenuButton<ShalatStatus>(
            icon: const Icon(Icons.more_vert_rounded, size: AppDimens.iconSM),
            onSelected: (status) {
              unawaited(
                ref
                    .read(statistikShalatViewModelProvider.notifier)
                    .updateShalatForDate(
                      date: date,
                      waktu: waktu,
                      status: status,
                    ),
              );
              Navigator.pop(context);
            },
            itemBuilder: (_) => [
              _menuItem(
                ShalatStatus.tepatWaktu,
                StatistikShalatStrings.statusTepatWaktu,
                AppColors.success,
              ),
              _menuItem(
                ShalatStatus.qadha,
                StatistikShalatStrings.statusQadha,
                AppColors.warning,
              ),
              _menuItem(
                ShalatStatus.tidakShalat,
                StatistikShalatStrings.statusTidakShalat,
                AppColors.error,
              ),
              _menuItem(
                ShalatStatus.belumDicatat,
                StatistikShalatStrings.statusBelumDicatat,
                AppColors.outline,
              ),
            ],
          ),
        ],
      ),
    );
  }

  PopupMenuItem<ShalatStatus> _menuItem(
    ShalatStatus status,
    String label,
    Color color,
  ) => PopupMenuItem(
    value: status,
    child: Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: AppDimens.spaceSM),
        Text(label),
      ],
    ),
  );

  Color _statusColor(ShalatStatus status) {
    switch (status) {
      case ShalatStatus.tepatWaktu:
        return AppColors.success;
      case ShalatStatus.qadha:
        return AppColors.warning;
      case ShalatStatus.tidakShalat:
        return AppColors.error;
      case ShalatStatus.belumDicatat:
        return AppColors.outline;
    }
  }

  String _statusLabel(ShalatStatus status) {
    switch (status) {
      case ShalatStatus.tepatWaktu:
        return StatistikShalatStrings.statusTepatWaktu;
      case ShalatStatus.qadha:
        return StatistikShalatStrings.statusQadha;
      case ShalatStatus.tidakShalat:
        return StatistikShalatStrings.statusTidakShalat;
      case ShalatStatus.belumDicatat:
        return StatistikShalatStrings.statusBelumDicatat;
    }
  }
}
