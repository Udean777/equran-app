import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/statistik_shalat/domain/entities/shalat_log.dart';
import 'package:flutter/material.dart';

/// Checklist 5 waktu shalat untuk hari ini.
class ShalatChecklistSection extends StatelessWidget {
  const ShalatChecklistSection({
    required this.today,
    required this.onStatusChanged,
    super.key,
  });

  final ShalatDayStats today;
  final void Function(WaktuShalat waktu, ShalatStatus status) onStatusChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMD),
          child: Text(
            'Shalat Hari Ini',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: AppDimens.spaceSM),
        ...WaktuShalat.values.map(
          (waktu) => _ShalatRow(
            waktu: waktu,
            log: today.logFor(waktu),
            onStatusChanged: (status) => onStatusChanged(waktu, status),
          ),
        ),
      ],
    );
  }
}

class _ShalatRow extends StatelessWidget {
  const _ShalatRow({
    required this.waktu,
    required this.log,
    required this.onStatusChanged,
  });

  final WaktuShalat waktu;
  final ShalatLog log;
  final void Function(ShalatStatus status) onStatusChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentStatus = log.status;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceMD,
        vertical: AppDimens.spaceXS / 2,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceMD,
        vertical: AppDimens.spaceSM,
      ),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppDimens.radiusMD),
        border: Border.all(
          color: _borderColor(currentStatus),
          width: currentStatus == ShalatStatus.belumDicatat ? 1 : 1.5,
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
              borderRadius: BorderRadius.circular(AppDimens.radiusSM),
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
              waktu.label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // Status buttons
          _StatusButtons(
            currentStatus: currentStatus,
            onStatusChanged: onStatusChanged,
          ),
        ],
      ),
    );
  }

  Color _borderColor(ShalatStatus status) {
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

  Color _iconBgColor(ShalatStatus status) {
    switch (status) {
      case ShalatStatus.tepatWaktu:
        return AppColors.success.withValues(alpha: 0.1);
      case ShalatStatus.qadha:
        return AppColors.warning.withValues(alpha: 0.1);
      case ShalatStatus.tidakShalat:
        return AppColors.error.withValues(alpha: 0.1);
      case ShalatStatus.belumDicatat:
        return AppColors.primary.withValues(alpha: 0.08);
    }
  }

  Color _iconColor(ShalatStatus status) {
    switch (status) {
      case ShalatStatus.tepatWaktu:
        return AppColors.success;
      case ShalatStatus.qadha:
        return AppColors.warning;
      case ShalatStatus.tidakShalat:
        return AppColors.error;
      case ShalatStatus.belumDicatat:
        return AppColors.primary;
    }
  }

  IconData _waktuIcon(WaktuShalat waktu) {
    switch (waktu) {
      case WaktuShalat.subuh:
        return Icons.wb_twilight_rounded;
      case WaktuShalat.dzuhur:
        return Icons.wb_sunny_rounded;
      case WaktuShalat.ashar:
        return Icons.wb_cloudy_rounded;
      case WaktuShalat.maghrib:
        return Icons.nights_stay_rounded;
      case WaktuShalat.isya:
        return Icons.dark_mode_rounded;
    }
  }
}

class _StatusButtons extends StatelessWidget {
  const _StatusButtons({
    required this.currentStatus,
    required this.onStatusChanged,
  });

  final ShalatStatus currentStatus;
  final void Function(ShalatStatus status) onStatusChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StatusChip(
          label: '✓',
          tooltip: 'Tepat Waktu',
          isSelected: currentStatus == ShalatStatus.tepatWaktu,
          selectedColor: AppColors.success,
          onTap: () => onStatusChanged(
            currentStatus == ShalatStatus.tepatWaktu
                ? ShalatStatus.belumDicatat
                : ShalatStatus.tepatWaktu,
          ),
        ),
        const SizedBox(width: AppDimens.spaceXS),
        _StatusChip(
          label: 'Q',
          tooltip: 'Qadha',
          isSelected: currentStatus == ShalatStatus.qadha,
          selectedColor: AppColors.warning,
          onTap: () => onStatusChanged(
            currentStatus == ShalatStatus.qadha
                ? ShalatStatus.belumDicatat
                : ShalatStatus.qadha,
          ),
        ),
        const SizedBox(width: AppDimens.spaceXS),
        _StatusChip(
          label: '✗',
          tooltip: 'Tidak Shalat',
          isSelected: currentStatus == ShalatStatus.tidakShalat,
          selectedColor: AppColors.error,
          onTap: () => onStatusChanged(
            currentStatus == ShalatStatus.tidakShalat
                ? ShalatStatus.belumDicatat
                : ShalatStatus.tidakShalat,
          ),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.label,
    required this.tooltip,
    required this.isSelected,
    required this.selectedColor,
    required this.onTap,
  });

  final String label;
  final String tooltip;
  final bool isSelected;
  final Color selectedColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isSelected
                ? selectedColor
                : selectedColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppDimens.radiusSM),
            border: Border.all(
              color: isSelected
                  ? selectedColor
                  : selectedColor.withValues(alpha: 0.3),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : selectedColor,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
