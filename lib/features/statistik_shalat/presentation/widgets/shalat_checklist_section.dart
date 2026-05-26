import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor =
        isDark ? AppColors.outlineDark : AppColors.outlineVariant;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.pagePadding,
        AppDimens.spaceSM,
        AppDimens.pagePadding,
        AppDimens.spaceXS,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surface,
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
                      borderRadius:
                          BorderRadius.circular(AppDimens.radiusFull),
                    ),
                  ),
                  const SizedBox(width: AppDimens.spaceSM),
                  Text(
                    'Shalat Hari Ini',
                    style: AppTypography.serifHeadingSmall.copyWith(
                      color: isDark
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
              color: isDark
                  ? AppColors.outlineDark
                  : AppColors.outlineVariant,
            ),

            // Rows
            ...WaktuShalat.values.map(
              (waktu) => _ShalatRow(
                waktu: waktu,
                log: today.logFor(waktu),
                isDark: isDark,
                onStatusChanged: (status) => onStatusChanged(waktu, status),
              ),
            ),

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
    required this.onStatusChanged,
  });

  final WaktuShalat waktu;
  final ShalatLog log;
  final bool isDark;
  final void Function(ShalatStatus status) onStatusChanged;

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
              waktu.label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: isDark
                    ? AppColors.onSurfaceDark
                    : AppColors.textPrimary,
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

  Color _borderColor(ShalatStatus status) => switch (status) {
    ShalatStatus.tepatWaktu => AppColors.success,
    ShalatStatus.qadha => AppColors.warning,
    ShalatStatus.tidakShalat => AppColors.error,
    ShalatStatus.belumDicatat => AppColors.outline,
  };

  Color _iconBgColor(ShalatStatus status) => switch (status) {
    ShalatStatus.tepatWaktu =>
      AppColors.success.withValues(alpha: 0.12),
    ShalatStatus.qadha => AppColors.warning.withValues(alpha: 0.12),
    ShalatStatus.tidakShalat =>
      AppColors.error.withValues(alpha: 0.12),
    ShalatStatus.belumDicatat =>
      AppColors.primary.withValues(alpha: 0.08),
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
