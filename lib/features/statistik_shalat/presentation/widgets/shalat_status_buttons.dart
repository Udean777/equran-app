import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/statistik_shalat/domain/entities/shalat_log.dart';
import 'package:equran_app/features/statistik_shalat/presentation/constants/statistik_shalat_strings.dart';
import 'package:flutter/material.dart';

/// Tiga tombol status shalat: tepat waktu, qadha, tidak shalat.
class ShalatStatusButtons extends StatelessWidget {
  const ShalatStatusButtons({
    required this.currentStatus,
    required this.onStatusChanged,
    super.key,
  });

  final ShalatStatus currentStatus;
  final void Function(ShalatStatus status) onStatusChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ShalatStatusChip(
          label: '✓',
          tooltip: StatistikShalatStrings.statusTepatWaktu,
          isSelected: currentStatus == ShalatStatus.tepatWaktu,
          selectedColor: AppColors.success,
          onTap: () => onStatusChanged(
            currentStatus == ShalatStatus.tepatWaktu
                ? ShalatStatus.belumDicatat
                : ShalatStatus.tepatWaktu,
          ),
        ),
        const SizedBox(width: AppDimens.spaceXS),
        ShalatStatusChip(
          label: 'Q',
          tooltip: StatistikShalatStrings.statusQadha,
          isSelected: currentStatus == ShalatStatus.qadha,
          selectedColor: AppColors.warning,
          onTap: () => onStatusChanged(
            currentStatus == ShalatStatus.qadha
                ? ShalatStatus.belumDicatat
                : ShalatStatus.qadha,
          ),
        ),
        const SizedBox(width: AppDimens.spaceXS),
        ShalatStatusChip(
          label: '✗',
          tooltip: StatistikShalatStrings.statusTidakShalat,
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

/// Chip tunggal untuk satu status shalat.
class ShalatStatusChip extends StatelessWidget {
  const ShalatStatusChip({
    required this.label,
    required this.tooltip,
    required this.isSelected,
    required this.selectedColor,
    required this.onTap,
    super.key,
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
