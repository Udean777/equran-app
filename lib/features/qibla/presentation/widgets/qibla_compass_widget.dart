import 'package:equran_app/core/theme/app_colors.dart';
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 280,
          height: 280,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Lingkaran luar dekoratif
              Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.15),
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
                  color: AppColors.primary.withValues(alpha: 0.05),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.2),
                  ),
                ),
              ),
              // Label arah mata angin
              ..._buildCardinalLabels(),
              // Jarum kompas yang berputar
              AnimatedRotation(
                turns: qiblaAngle / 360,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                child: _buildNeedle(),
              ),
              // Titik tengah
              Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        // Hint kalibrasi jika akurasi rendah
        if (accuracy != null && accuracy! > 30) ...[
          const SizedBox(height: 12),
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

  List<Widget> _buildCardinalLabels() {
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
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.primary.withValues(alpha: 0.5),
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

    // Jarum atas (menunjuk kiblat) — hijau
    final paintUp = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    // Jarum bawah — abu
    final paintDown = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    // Segitiga ujung jarum atas
    final arrowPath = Path()
      ..moveTo(center.dx, center.dy - needleLength)
      ..lineTo(center.dx - 8, center.dy - needleLength + 20)
      ..lineTo(center.dx + 8, center.dy - needleLength + 20)
      ..close();

    // Gambar jarum atas, segitiga ujung jarum atas, dan jarum bawah
    canvas
      ..drawLine(
        center,
        Offset(center.dx, center.dy - needleLength),
        paintUp,
      )
      ..drawPath(
        arrowPath,
        Paint()..color = AppColors.primary,
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Colors.orange,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            'Gerakkan perangkat membentuk angka 8 untuk kalibrasi',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.orange.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
