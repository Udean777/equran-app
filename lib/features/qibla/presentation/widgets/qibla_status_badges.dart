import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:flutter/material.dart';

/// Badge "Menghadap Kiblat!" — ditampilkan saat kompas aligned.
class QiblaAlignedBadge extends StatelessWidget {
  const QiblaAlignedBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceLG,
        vertical: AppDimens.spaceSM,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.goldDark, AppColors.gold],
        ),
        borderRadius: BorderRadius.circular(AppDimens.radiusFull),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_rounded, size: 16, color: Colors.white),
          SizedBox(width: AppDimens.spaceXS),
          Text(
            'Menghadap Kiblat!',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 13,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

/// Badge panduan arah — ditampilkan saat kompas belum aligned.
class QiblaGuideBadge extends StatelessWidget {
  const QiblaGuideBadge({required this.qiblaAngle, super.key});

  final double qiblaAngle;

  String _rotationHint(double angle) {
    final normalized = angle % 360;
    if (normalized < 10 || normalized > 350) return 'Lurus ke depan';
    if (normalized <= 180) {
      return 'Putar ${normalized.toStringAsFixed(0)}° ke kanan';
    }
    return 'Putar ${(360 - normalized).toStringAsFixed(0)}° ke kiri';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceLG,
        vertical: AppDimens.spaceSM,
      ),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(AppDimens.radiusFull),
        border: Border.all(
          color: context.borderVariantColor,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.explore_rounded,
            size: 16,
            color: context.primaryActionColor,
          ),
          const SizedBox(width: AppDimens.spaceXS),
          Text(
            _rotationHint(qiblaAngle),
            style: TextStyle(
              color: context.textPrimaryColor,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

/// Hint kalibrasi — ditampilkan saat akurasi sensor rendah (> 30°).
class QiblaCalibrationHint extends StatelessWidget {
  const QiblaCalibrationHint({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceMD,
        vertical: AppDimens.spaceSM,
      ),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: isDark ? 0.15 : 0.1),
        borderRadius: BorderRadius.circular(AppDimens.radiusMD),
        border: Border.all(
          color: Colors.orange.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: 14,
            color: Colors.orange.shade700,
          ),
          const SizedBox(width: AppDimens.spaceXS),
          Text(
            'Gerakkan ponsel membentuk angka 8 untuk kalibrasi',
            style: TextStyle(
              color: Colors.orange.shade700,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
