import 'dart:async';
import 'dart:math' as math;

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:flutter/material.dart';

/// Threshold derajat untuk dianggap "aligned" ke kiblat.
const _alignedThreshold = 5.0;

/// Widget kompas kiblat — berputar smooth, glow saat aligned, label Mekah jelas.
class QiblaCompassWidget extends StatefulWidget {
  const QiblaCompassWidget({
    required this.qiblaAngle,
    this.accuracy,
    super.key,
  });

  final double qiblaAngle;
  final double? accuracy;

  @override
  State<QiblaCompassWidget> createState() => _QiblaCompassWidgetState();
}

class _QiblaCompassWidgetState extends State<QiblaCompassWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _glowController;
  late Animation<double> _pulseAnim;
  late Animation<double> _glowAnim;

  bool _wasAligned = false;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    unawaited(_pulseController.repeat(reverse: true));

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _pulseAnim = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _glowAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeOut),
    );
  }

  @override
  void didUpdateWidget(QiblaCompassWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    final isAligned = _isAligned(widget.qiblaAngle);
    if (isAligned && !_wasAligned) {
      unawaited(_glowController.forward());
    } else if (!isAligned && _wasAligned) {
      unawaited(_glowController.reverse());
    }
    _wasAligned = isAligned;
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  bool _isAligned(double angle) {
    final normalized = angle % 360;
    return normalized <= _alignedThreshold ||
        normalized >= (360 - _alignedThreshold);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAligned = _isAligned(widget.qiblaAngle);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Status badge ──────────────────────────────────────────────────
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: isAligned
              ? const _AlignedBadge(key: ValueKey('aligned'))
              : _GuideBadge(
                  qiblaAngle: widget.qiblaAngle,
                  key: const ValueKey('guide'),
                ),
        ),

        const SizedBox(height: AppDimens.spaceLG),

        // ── Kompas ────────────────────────────────────────────────────────
        AnimatedBuilder(
          animation: Listenable.merge([_pulseAnim, _glowAnim]),
          builder: (context, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                // Glow ring saat aligned
                if (isAligned)
                  Opacity(
                    opacity: _glowAnim.value * 0.4,
                    child: Container(
                      width: 320,
                      height: 320,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.gold,
                            blurRadius: 40,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                    ),
                  ),

                // Pulse ring luar
                Transform.scale(
                  scale: isAligned ? _pulseAnim.value : 1.0,
                  child: child,
                ),
              ],
            );
          },
          child: SizedBox(
            width: 300,
            height: 300,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Ring terluar — dekorasi
                _CompassRing(isDark: isDark, isAligned: isAligned),

                // Label arah mata angin (statis)
                ..._buildCardinalLabels(isDark),

                // Jarum kompas yang berputar
                AnimatedRotation(
                  turns: widget.qiblaAngle / 360,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  child: _CompassNeedle(
                    isDark: isDark,
                    isAligned: isAligned,
                  ),
                ),

                // Titik tengah
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isAligned ? AppColors.gold : AppColors.primary,
                    border: Border.all(
                      color: isDark ? AppColors.surfaceDark : AppColors.surface,
                      width: 2.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (isAligned ? AppColors.gold : AppColors.primary)
                            .withValues(alpha: 0.4),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: AppDimens.spaceLG),

        // ── Hint kalibrasi ────────────────────────────────────────────────
        if (widget.accuracy != null && widget.accuracy! > 30)
          _CalibrationHint(),
      ],
    );
  }

  List<Widget> _buildCardinalLabels(bool isDark) {
    const labels = [
      (text: 'U', dx: 0.0, dy: -128.0),
      (text: 'T', dx: 128.0, dy: 0.0),
      (text: 'S', dx: 0.0, dy: 128.0),
      (text: 'B', dx: -128.0, dy: 0.0),
    ];

    return labels.map((label) {
      final isNorth = label.text == 'U';
      return Transform.translate(
        offset: Offset(label.dx, label.dy),
        child: Text(
          label.text,
          style: TextStyle(
            fontSize: isNorth ? 15 : 12,
            fontWeight: isNorth ? FontWeight.w800 : FontWeight.w600,
            color: isNorth
                ? (isDark ? AppColors.primaryLighter : AppColors.primary)
                : (isDark
                      ? AppColors.onSurfaceDarkVariant.withValues(alpha: 0.5)
                      : AppColors.textTertiary.withValues(alpha: 0.6)),
          ),
        ),
      );
    }).toList();
  }
}

// ── Compass ring ──────────────────────────────────────────────────────────────

class _CompassRing extends StatelessWidget {
  const _CompassRing({required this.isDark, required this.isAligned});

  final bool isDark;
  final bool isAligned;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(300, 300),
      painter: _CompassRingPainter(isDark: isDark, isAligned: isAligned),
    );
  }
}

class _CompassRingPainter extends CustomPainter {
  _CompassRingPainter({required this.isDark, required this.isAligned});

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
          ? AppColors.onSurfaceDarkVariant.withValues(alpha: 0.25)
          : AppColors.textTertiary.withValues(alpha: 0.2)
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;

    final majorTickPaint = Paint()
      ..color = isDark
          ? AppColors.onSurfaceDarkVariant.withValues(alpha: 0.5)
          : AppColors.textSecondary.withValues(alpha: 0.4)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    for (var i = 0; i < 72; i++) {
      final angle = (i * 5) * math.pi / 180;
      final isMajor = i % 9 == 0; // setiap 45 derajat
      final tickLength = isMajor ? 12.0 : 6.0;
      final paint = isMajor ? majorTickPaint : tickPaint;

      final outerPoint = Offset(
        center.dx + (outerRadius - 4) * math.cos(angle - math.pi / 2),
        center.dy + (outerRadius - 4) * math.sin(angle - math.pi / 2),
      );
      final innerPoint = Offset(
        center.dx +
            (outerRadius - 4 - tickLength) * math.cos(angle - math.pi / 2),
        center.dy +
            (outerRadius - 4 - tickLength) * math.sin(angle - math.pi / 2),
      );

      canvas.drawLine(outerPoint, innerPoint, paint);
    }

    // Gold arc saat aligned
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
  bool shouldRepaint(_CompassRingPainter old) =>
      old.isAligned != isAligned || old.isDark != isDark;
}

// ── Compass needle ────────────────────────────────────────────────────────────

class _CompassNeedle extends StatelessWidget {
  const _CompassNeedle({required this.isDark, required this.isAligned});

  final bool isDark;
  final bool isAligned;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 300,
      child: CustomPaint(
        painter: _NeedlePainter(isDark: isDark, isAligned: isAligned),
      ),
    );
  }
}

class _NeedlePainter extends CustomPainter {
  _NeedlePainter({required this.isDark, required this.isAligned});

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
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawLine(
      center,
      Offset(center.dx, center.dy - needleLength),
      shadowPaint,
    );

    // Jarum bawah (ekor)
    final tailPaint = Paint()
      ..color = tailColor
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      center,
      Offset(center.dx, center.dy + needleTailLength),
      tailPaint,
    );

    // Jarum atas (menunjuk kiblat)
    final needlePaint = Paint()
      ..color = primaryColor
      ..strokeWidth = 3.5
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
  bool shouldRepaint(_NeedlePainter old) =>
      old.isAligned != isAligned || old.isDark != isDark;
}

// ── Status badges ─────────────────────────────────────────────────────────────

class _AlignedBadge extends StatelessWidget {
  const _AlignedBadge({super.key});

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

class _GuideBadge extends StatelessWidget {
  const _GuideBadge({required this.qiblaAngle, super.key});

  final double qiblaAngle;

  String _rotationHint(double angle) {
    final normalized = angle % 360;
    if (normalized < 180) {
      return 'Putar ke kanan ${normalized.toStringAsFixed(0)}°';
    } else {
      return 'Putar ke kiri ${(360 - normalized).toStringAsFixed(0)}°';
    }
  }

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
            ? AppColors.primaryDark.withValues(alpha: 0.5)
            : AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(AppDimens.radiusFull),
        border: Border.all(
          color: isDark
              ? AppColors.primaryLight.withValues(alpha: 0.3)
              : AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.rotate_right_rounded,
            size: 15,
            color: isDark ? AppColors.primaryLighter : AppColors.primary,
          ),
          const SizedBox(width: AppDimens.spaceXS),
          Text(
            _rotationHint(qiblaAngle),
            style: TextStyle(
              color: isDark ? AppColors.primaryLighter : AppColors.primary,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Calibration hint ──────────────────────────────────────────────────────────

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
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.warning_amber_rounded, size: 14, color: AppColors.warning),
          SizedBox(width: AppDimens.spaceXS),
          Text(
            'Kalibrasi kompas diperlukan — gerakkan angka 8',
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
