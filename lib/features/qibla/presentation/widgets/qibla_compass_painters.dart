import 'dart:math' as math;

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Threshold derajat untuk dianggap "aligned" ke kiblat.
/// Diexport agar bisa dipakai di file lain dalam feature qibla.
const qiblaAlignedThreshold = 5.0;

// ---------------------------------------------------------------------------
// Compass ring painter
// ---------------------------------------------------------------------------

/// Painter untuk ring kompas — lingkaran luar, tick marks, dan arc aligned.
class CompassRingPainter extends CustomPainter {
  CompassRingPainter({required this.isDark, required this.isAligned});

  final bool isDark;
  final bool isAligned;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2;
    final innerRadius = outerRadius - 24;

    // Ring luar
    final ringPaint = Paint()
      ..color = isAligned
          ? AppColors.gold.withValues(alpha: 0.5)
          : (isDark
                ? AppColors.outlineDark
                : AppColors.outline.withValues(alpha: 0.6))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawCircle(center, outerRadius - 2, ringPaint);

    // Ring dalam
    final innerPaint = Paint()
      ..color = isDark
          ? AppColors.surfaceDarkVariant.withValues(alpha: 0.5)
          : AppColors.surfaceVariant.withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, innerRadius, innerPaint);

    // Tick marks — 72 ticks (setiap 5 derajat)
    final tickPaint = Paint()
      ..color = isDark
          ? AppColors.onSurfaceDarkVariant.withValues(alpha: 0.3)
          : AppColors.textTertiary.withValues(alpha: 0.25)
      ..strokeWidth = 1;

    for (var i = 0; i < 72; i++) {
      final angle = i * 5 * math.pi / 180;
      final isMajor = i % 9 == 0;
      final tickLength = isMajor ? 10.0 : 5.0;
      final start = Offset(
        center.dx + (outerRadius - 4) * math.cos(angle),
        center.dy + (outerRadius - 4) * math.sin(angle),
      );
      final end = Offset(
        center.dx + (outerRadius - 4 - tickLength) * math.cos(angle),
        center.dy + (outerRadius - 4 - tickLength) * math.sin(angle),
      );
      canvas.drawLine(start, end, tickPaint);
    }

    // Arc gold saat aligned
    if (isAligned) {
      final arcPaint = Paint()
        ..color = AppColors.gold.withValues(alpha: 0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: outerRadius - 2),
        -math.pi / 2 - 0.15,
        0.3,
        false,
        arcPaint,
      );
    }
  }

  @override
  bool shouldRepaint(CompassRingPainter old) =>
      old.isAligned != isAligned || old.isDark != isDark;
}

// ---------------------------------------------------------------------------
// Needle painter
// ---------------------------------------------------------------------------

/// Painter untuk jarum kompas — menunjuk ke arah kiblat (Mekah).
class NeedlePainter extends CustomPainter {
  NeedlePainter({required this.isDark, required this.isAligned});

  final bool isDark;
  final bool isAligned;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final needleLength = size.height / 2 - 36;
    final needleTailLength = needleLength * 0.45;

    final primaryColor = isAligned ? AppColors.gold : AppColors.primary;
    final tailColor = isDark
        ? AppColors.onSurfaceDarkVariant.withValues(alpha: 0.4)
        : AppColors.textTertiary.withValues(alpha: 0.3);

    // Shadow jarum
    final shadowPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.2)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    canvas.drawLine(
      center,
      Offset(center.dx, center.dy - needleLength),
      shadowPaint,
    );

    // Batang jarum
    final needlePaint = Paint()
      ..color = primaryColor
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      center,
      Offset(center.dx, center.dy - needleLength + 28),
      needlePaint,
    );

    // Segitiga ujung jarum
    final arrowTip = Offset(center.dx, center.dy - needleLength);
    final arrowPath = Path()
      ..moveTo(arrowTip.dx, arrowTip.dy)
      ..lineTo(arrowTip.dx - 9, arrowTip.dy + 26)
      ..lineTo(arrowTip.dx + 9, arrowTip.dy + 26)
      ..close();

    canvas.drawPath(
      arrowPath,
      Paint()
        ..color = primaryColor
        ..style = PaintingStyle.fill,
    );

    // Label "MEKAH" di ujung jarum
    final textPainter = TextPainter(
      text: TextSpan(
        text: isAligned ? '✓ MEKAH' : 'MEKAH',
        style: TextStyle(
          color: isAligned ? AppColors.gold : AppColors.primary,
          fontSize: 9,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(
        arrowTip.dx - textPainter.width / 2,
        arrowTip.dy - textPainter.height - 6,
      ),
    );

    // Segitiga ekor
    final tailTip = Offset(center.dx, center.dy + needleTailLength);
    final tailPath = Path()
      ..moveTo(tailTip.dx, tailTip.dy)
      ..lineTo(tailTip.dx - 6, tailTip.dy - 16)
      ..lineTo(tailTip.dx + 6, tailTip.dy - 16)
      ..close();

    canvas.drawPath(
      tailPath,
      Paint()
        ..color = tailColor
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(NeedlePainter old) =>
      old.isAligned != isAligned || old.isDark != isDark;
}
