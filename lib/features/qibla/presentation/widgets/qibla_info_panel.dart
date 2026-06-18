import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/core/widgets/luxury_divider.dart';
import 'package:flutter/material.dart';

/// Panel info: bearing, arah, dan status aligned.
class QiblaInfoPanel extends StatelessWidget {
  const QiblaInfoPanel({
    required this.bearing,
    required this.qiblaAngle,
    super.key,
  });

  final double bearing;
  final double qiblaAngle;

  bool get _isAligned {
    final normalized = qiblaAngle % 360;
    return normalized <= 5.0 || normalized >= 355.0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;
    final borderColor = _isAligned
        ? AppColors.gold.withValues(alpha: 0.4)
        : (isDark ? AppColors.outlineDark : AppColors.outlineVariant);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
        border: Border.all(color: borderColor, width: _isAligned ? 1.5 : 1),
        boxShadow: _isAligned
            ? [
                BoxShadow(
                  color: AppColors.gold.withValues(alpha: 0.12),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      padding: const EdgeInsets.all(AppDimens.cardPaddingLG),
      child: Column(
        children: [
          // Row info: bearing + arah
          Row(
            children: [
              Expanded(
                child: _InfoItem(
                  label: 'Arah Kiblat',
                  value: '${bearing.toStringAsFixed(1)}°',
                  icon: Icons.explore_rounded,
                  isDark: isDark,
                ),
              ),
              const GoldDivider.vertical(height: 48),
              Expanded(
                child: _InfoItem(
                  label: 'Dari Utara',
                  value: _bearingLabel(bearing),
                  icon: Icons.navigation_rounded,
                  isDark: isDark,
                ),
              ),
              const GoldDivider.vertical(height: 48),
              Expanded(
                child: _InfoItem(
                  label: 'Status',
                  value: _isAligned ? 'Tepat' : 'Belum',
                  icon: _isAligned
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  isDark: isDark,
                  isAligned: _isAligned,
                ),
              ),
            ],
          ),

          // Divider
          const SizedBox(height: AppDimens.spaceMD),
          Divider(
            height: 1,
            color: isDark ? AppColors.outlineDark : AppColors.outlineVariant,
          ),
          const SizedBox(height: AppDimens.spaceMD),

          // Instruksi user awam
          _InstructionRow(isAligned: _isAligned, qiblaAngle: qiblaAngle),
        ],
      ),
    );
  }

  String _bearingLabel(double bearing) {
    if (bearing >= 337.5 || bearing < 22.5) return 'Utara';
    if (bearing < 67.5) return 'Timur Laut';
    if (bearing < 112.5) return 'Timur';
    if (bearing < 157.5) return 'Tenggara';
    if (bearing < 202.5) return 'Selatan';
    if (bearing < 247.5) return 'Barat Daya';
    if (bearing < 292.5) return 'Barat';
    return 'Barat Laut';
  }
}

// ── Info item ─────────────────────────────────────────────────────────────────

class _InfoItem extends StatelessWidget {
  const _InfoItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.isDark,
    this.isAligned = false,
  });

  final String label;
  final String value;
  final IconData icon;
  final bool isDark;
  final bool isAligned;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = isAligned
        ? AppColors.gold
        : (isDark ? AppColors.primaryLighter : AppColors.primary);
    final bgColor = isAligned
        ? AppColors.gold.withValues(alpha: isDark ? 0.15 : 0.1)
        : (isDark ? AppColors.primaryDark : AppColors.primaryContainer);

    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
          child: Icon(icon, size: AppDimens.iconSM + 2, color: accentColor),
        ),
        const SizedBox(height: AppDimens.spaceSM),
        Text(
          value,
          style: AppTypography.serifHeadingSmall.copyWith(
            color: isAligned
                ? AppColors.gold
                : (isDark ? AppColors.onSurfaceDark : AppColors.textPrimary),
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: isDark
                ? AppColors.onSurfaceDarkVariant
                : AppColors.textTertiary,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

// ── Instruction row ───────────────────────────────────────────────────────────

class _InstructionRow extends StatelessWidget {
  const _InstructionRow({
    required this.isAligned,
    required this.qiblaAngle,
  });

  final bool isAligned;
  final double qiblaAngle;

  String get _instruction {
    if (isAligned) {
      return 'Anda sudah menghadap kiblat. Mulai shalat sekarang.';
    }
    final normalized = qiblaAngle % 360;
    if (normalized < 180) {
      return 'Putar badan ke kanan hingga jarum menunjuk lurus ke atas.';
    }
    return 'Putar badan ke kiri hingga jarum menunjuk lurus ke atas.';
  }

  IconData get _icon =>
      isAligned ? Icons.mosque_rounded : Icons.rotate_right_rounded;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isAligned
        ? AppColors.gold
        : (isDark ? AppColors.primaryLighter : AppColors.primary);

    return Row(
      children: [
        Icon(_icon, size: 18, color: color),
        const SizedBox(width: AppDimens.spaceSM),
        Expanded(
          child: Text(
            _instruction,
            style: TextStyle(
              fontSize: 12,
              color: isDark
                  ? AppColors.onSurfaceDarkVariant
                  : AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
