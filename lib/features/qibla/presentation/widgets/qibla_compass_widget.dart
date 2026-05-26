import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:flutter/material.dart';

/// Widget kompas yang berputar smooth mengikuti arah kiblat.
class QiblaCompassWidget extends StatelessWidget {
  const QiblaCompassWidget({
    required this.qiblaAngle,
    this.accuracy,
    super.key,
  });

  final double qiblaAngle;
  final double? accuracy;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 280,
          height: 280,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Lingkaran luar — gold border
              Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.gold.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
              ),
              // Lingkaran tengah
              Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark
                      ? AppColors.primaryDark.withValues(alpha: 0.15)
                      : AppColors.primaryContainer.withValues(alpha: 0.3),
                  border: Border.all(
                    color: isDark
                        ? AppColors.primaryLight.withValues(alpha: 0.2)
                        : AppColors.primary.withValues(alpha: 0.15),
                  ),
                ),
              ),
              // Label arah mata angin
              ..._buildCardinalLabels(isDark),
              // Jarum kompas yang berputar
              AnimatedRotation(
                turns: qiblaAngle / 360,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                child: _buildNeedle(),
              ),
              // Titik tengah — gold
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.gold,
                  border: Border.all(
                    color: isDark
                        ? AppColors.surfaceDark
                        : AppColors.surface,
                    width: 2,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Hint kalibrasi jika akurasi rendah
        if (accuracy != null && accuracy! > 30) ...[
          const SizedBox(height: AppDimens.spaceMD),
          _CalibrationHint(),
        ],
      ],
    );
  }

  Widget _buildNeedle() {
    return SizedBox(
      width: 280,
      height: 280,
      child: CustomPaint(
        painter: _NeedlePainter(),
      ),
    );
  }

  List<Widget> _buildCardinalLabels(bool isDark) {
    const labels = [
      (text: 'U', angle: 0.0, dx: 0.0, dy: -120.0),
      (text: 'T', angle: 0.0, dx: 120.0, dy: 0.0),
      (text: 'S', angle: 0.0, dx: 0.0, dy: 120.0),
      (text: 'B', angle: 0.0, dx: -120.0, dy: 0.0),
    ];

    return labels.map((label) {
      return Transform.translate(
        offset: Offset(label.dx, label.dy),
        child: Text(
          label.text,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isDark
                ? AppColors.primaryLighter.withValues(alpha: 0.6)
                : AppColors.primary.withValues(alpha: 0.5),
          ),
        ),
      );
    }).toList();
  }
}

class _NeedlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final needleLength = size.height / 2 - 30;

    // Jarum atas (menunjuk kiblat) — primary
    final paintUp = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    // Jarum bawah — abu
    final paintDown = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    // Segitiga ujung jarum atas — gold
    final arrowPath = Path()
      ..moveTo(center.dx, center.dy - needleLength)
      ..lineTo(center.dx - 8, center.dy - needleLength + 20)
      ..lineTo(center.dx + 8, center.dy - needleLength + 20)
      ..close();

    canvas
      ..drawLine(
        center,
        Offset(center.dx, center.dy - needleLength),
        paintUp,
      )
      ..drawPath(
        arrowPath,
        Paint()..color = AppColors.gold,
      )
      ..drawLine(
        center,
        Offset(center.dx, center.dy + needleLength * 0.6),
        paintDown,
      );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CalibrationHint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceMD,
        vertical: AppDimens.spaceSM,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.warningContainer.withValues(alpha: 0.1)
            : AppColors.warningContainer,
        borderRadius: BorderRadius.circular(AppDimens.radiusFull),
        border: Border.all(
          color: AppColors.warning.withValues(alpha: 0.3),
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: 14,
            color: AppColors.warning,
          ),
          SizedBox(width: AppDimens.spaceXS),
          Text(
            'Kalibrasi kompas diperlukan',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.warning,
            ),
          ),
        ],
      ),
    );
  }
}
