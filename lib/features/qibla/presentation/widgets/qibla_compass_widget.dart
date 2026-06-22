import 'dart:async';
import 'dart:math' as math;

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/qibla/presentation/widgets/qibla_compass_painters.dart';
import 'package:equran_app/features/qibla/presentation/widgets/qibla_status_badges.dart';
import 'package:flutter/material.dart';

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
      unawaited(_pulseController.repeat(reverse: true));
      unawaited(_glowController.forward());
    } else if (!isAligned && _wasAligned) {
      _pulseController
        ..stop()
        ..reset();
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
    return normalized <= qiblaAlignedThreshold ||
        normalized >= (360 - qiblaAlignedThreshold);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isAligned = _isAligned(widget.qiblaAngle);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Status badge
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: isAligned
              ? const QiblaAlignedBadge(key: ValueKey('aligned'))
              : QiblaGuideBadge(
                  qiblaAngle: widget.qiblaAngle,
                  key: const ValueKey('guide'),
                ),
        ),

        const SizedBox(height: AppDimens.spaceLG),

        // Kompas
        Stack(
          alignment: Alignment.center,
          children: [
            // Glow — rebuild hanya saat _glowAnim berubah (transisi aligned)
            AnimatedBuilder(
              animation: _glowAnim,
              builder: (context, child) {
                if (!isAligned) return const SizedBox.shrink();
                return Container(
                  width: 320,
                  height: 320,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.gold.withValues(
                          alpha: 0.15 * _glowAnim.value,
                        ),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                );
              },
            ),

            // Ring — pulse scale hanya rebuild ring, bukan seluruh stack
            AnimatedBuilder(
              animation: _pulseAnim,
              builder: (context, child) {
                return Transform.scale(
                  scale: isAligned ? _pulseAnim.value : 1.0,
                  child: child,
                );
              },
              child: _CompassRing(isDark: isDark, isAligned: isAligned),
            ),

            // Label arah mata angin
            ..._buildCardinalLabels(isDark),

            // Jarum — berputar sesuai qiblaAngle
            Transform.rotate(
              angle: widget.qiblaAngle * math.pi / 180,
              child: _CompassNeedle(isDark: isDark, isAligned: isAligned),
            ),

            // Titik tengah
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isAligned ? AppColors.gold : AppColors.primary,
                boxShadow: [
                  BoxShadow(
                    color: (isAligned ? AppColors.gold : AppColors.primary)
                        .withValues(alpha: 0.4),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: AppDimens.spaceLG),

        // Hint kalibrasi
        if (widget.accuracy != null && widget.accuracy! > 30)
          const QiblaCalibrationHint(),
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

// ---------------------------------------------------------------------------
// Compass ring widget — wraps CompassRingPainter
// ---------------------------------------------------------------------------

class _CompassRing extends StatelessWidget {
  const _CompassRing({required this.isDark, required this.isAligned});

  final bool isDark;
  final bool isAligned;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(300, 300),
      painter: CompassRingPainter(isDark: isDark, isAligned: isAligned),
    );
  }
}

// ---------------------------------------------------------------------------
// Compass needle widget — wraps NeedlePainter
// ---------------------------------------------------------------------------

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
        painter: NeedlePainter(isDark: isDark, isAligned: isAligned),
      ),
    );
  }
}
