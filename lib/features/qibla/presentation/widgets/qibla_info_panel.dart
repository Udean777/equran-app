import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// Panel info: tampilkan derajat bearing + label arah kiblat.
class QiblaInfoPanel extends StatelessWidget {
  const QiblaInfoPanel({
    required this.bearing,
    required this.qiblaAngle,
    super.key,
  });

  final double bearing;
  final double qiblaAngle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;
    final borderColor =
        isDark ? AppColors.outlineDark : AppColors.outlineVariant;

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
        border: Border.all(color: borderColor),
      ),
      padding: const EdgeInsets.all(AppDimens.cardPaddingLG),
      child: Row(
        children: [
          Expanded(
            child: _InfoItem(
              label: 'Arah Kiblat',
              value: '${bearing.toStringAsFixed(1)}°',
              icon: Icons.explore_rounded,
              isDark: isDark,
            ),
          ),
          Container(
            width: 1,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.gold.withValues(alpha: 0),
                  AppColors.gold.withValues(alpha: 0.4),
                  AppColors.gold.withValues(alpha: 0),
                ],
              ),
            ),
          ),
          Expanded(
            child: _InfoItem(
              label: 'Dari Utara',
              value: _bearingLabel(bearing),
              icon: Icons.navigation_rounded,
              isDark: isDark,
            ),
          ),
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

class _InfoItem extends StatelessWidget {
  const _InfoItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.isDark,
  });

  final String label;
  final String value;
  final IconData icon;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isDark ? AppColors.primaryDark : AppColors.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: AppDimens.iconSM + 2,
            color: isDark ? AppColors.primaryLighter : AppColors.primary,
          ),
        ),
        const SizedBox(height: AppDimens.spaceSM),
        Text(
          value,
          style: AppTypography.serifHeadingSmall.copyWith(
            color: isDark ? AppColors.onSurfaceDark : AppColors.textPrimary,
            fontSize: 18,
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
