import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
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
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceLG,
        vertical: AppDimens.spaceMD,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _InfoItem(
            label: 'Arah Kiblat',
            value: '${bearing.toStringAsFixed(1)}°',
            icon: Icons.explore_rounded,
          ),
          Container(
            width: 1,
            height: 40,
            color: AppColors.primary.withValues(alpha: 0.2),
          ),
          _InfoItem(
            label: 'Dari Utara',
            value: _bearingLabel(bearing),
            icon: Icons.navigation_rounded,
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
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(height: AppDimens.spaceXS),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
