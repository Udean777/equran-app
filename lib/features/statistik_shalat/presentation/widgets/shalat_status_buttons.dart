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
    required this.onStartSholat,
    this.isBeforeStart = false,
    this.isTepatWaktuDisabled = false,
    super.key,
  });

  final ShalatStatus currentStatus;
  final bool isBeforeStart;
  final bool isTepatWaktuDisabled;
  final void Function(ShalatStatus status) onStatusChanged;
  final VoidCallback onStartSholat;

  @override
  Widget build(BuildContext context) {
    final isSet = currentStatus != ShalatStatus.belumDicatat;

    if (isSet) {
      if (currentStatus == ShalatStatus.tidakShalat) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShalatStatusChip(
              label: _getLabel(currentStatus),
              tooltip: _getTooltip(currentStatus),
              isSelected: true,
              selectedColor: _getColor(currentStatus),
              onTap: () => _showAlreadySetToast(context),
            ),
            const SizedBox(width: 8),
            TextButton.icon(
              onPressed: onStartSholat,
              icon: const Icon(Icons.replay_rounded, size: 16),
              label: const Text('Tebus Qadha', style: TextStyle(fontSize: 12)),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.warning,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: const Size(0, 32),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        );
      }
      return ShalatStatusChip(
        label: _getLabel(currentStatus),
        tooltip: _getTooltip(currentStatus),
        isSelected: true,
        selectedColor: _getColor(currentStatus),
        onTap: () => _showAlreadySetToast(context),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FilledButton.tonal(
          onPressed: isBeforeStart ? onStartSholat : onStartSholat,
          style: FilledButton.styleFrom(
            backgroundColor: isBeforeStart
                ? (context.isDark ? Colors.grey[800] : Colors.grey[200])
                : (isTepatWaktuDisabled
                      ? AppColors.warning.withValues(alpha: 0.1)
                      : AppColors.success.withValues(alpha: 0.1)),
            foregroundColor: isBeforeStart
                ? Colors.grey
                : (isTepatWaktuDisabled
                      ? AppColors.warning
                      : AppColors.success),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            minimumSize: const Size(0, 32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimens.radiusSM),
              side: BorderSide(
                color: isBeforeStart
                    ? Colors.transparent
                    : (isTepatWaktuDisabled
                          ? AppColors.warning
                          : AppColors.success),
              ),
            ),
          ),
          child: Text(
            isBeforeStart
                ? 'Belum Waktunya'
                : (isTepatWaktuDisabled ? 'Sholat (Qadha)' : 'Mulai Sholat'),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(width: AppDimens.spaceXS),
        ShalatStatusChip(
          label: '✗',
          tooltip: StatistikShalatStrings.statusTidakShalat,
          isSelected: false,
          selectedColor: isBeforeStart ? Colors.grey : AppColors.error,
          onTap: () => onStatusChanged(ShalatStatus.tidakShalat),
        ),
      ],
    );
  }

  String _getLabel(ShalatStatus status) => switch (status) {
    ShalatStatus.tepatWaktu => '✓',
    ShalatStatus.qadha => 'Q',
    ShalatStatus.tidakShalat => '✗',
    ShalatStatus.belumDicatat => '',
  };

  String _getTooltip(ShalatStatus status) => switch (status) {
    ShalatStatus.tepatWaktu => StatistikShalatStrings.statusTepatWaktu,
    ShalatStatus.qadha => StatistikShalatStrings.statusQadha,
    ShalatStatus.tidakShalat => StatistikShalatStrings.statusTidakShalat,
    ShalatStatus.belumDicatat => '',
  };

  Color _getColor(ShalatStatus status) => switch (status) {
    ShalatStatus.tepatWaktu => AppColors.success,
    ShalatStatus.qadha => AppColors.warning,
    ShalatStatus.tidakShalat => AppColors.error,
    ShalatStatus.belumDicatat => AppColors.outline,
  };

  void _showAlreadySetToast(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Catatan shalat hari ini sudah tersimpan. Besok bisa diperbarui kembali.',
          style: TextStyle(fontSize: 13),
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(AppDimens.pagePadding),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusLG),
        ),
      ),
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
