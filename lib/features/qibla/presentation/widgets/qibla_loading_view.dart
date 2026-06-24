import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:flutter/material.dart';

/// Loading view untuk Qibla — animasi kompas berputar + pesan status.
class QiblaLoadingView extends StatefulWidget {
  const QiblaLoadingView({required this.message, super.key});

  final String message;

  @override
  State<QiblaLoadingView> createState() => _QiblaLoadingViewState();
}

class _QiblaLoadingViewState extends State<QiblaLoadingView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotateAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    unawaited(_controller.repeat());
    _rotateAnim = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.spaceLG),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Ring luar berputar
                  RotationTransition(
                    turns: _rotateAnim,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.gold.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: CustomPaint(
                        painter: _DashedCirclePainter(
                          color: AppColors.gold.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  ),
                  // Icon kompas statis
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark
                          ? AppColors.primaryDark.withValues(alpha: 0.4)
                          : AppColors.primaryContainer.withValues(alpha: 0.5),
                    ),
                    child: Icon(
                      Icons.explore_rounded,
                      size: 32,
                      color: isDark
                          ? AppColors.primaryLighter
                          : AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimens.spaceLG),
            Text(
              widget.message,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? AppColors.onSurfaceDarkVariant
                    : AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimens.spaceSM),
            Text(
              'Pastikan GPS dan izin lokasi aktif',
              style: TextStyle(
                fontSize: 12,
                color: isDark
                    ? AppColors.onSurfaceDarkVariant.withValues(alpha: 0.6)
                    : AppColors.textTertiary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  _DashedCirclePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 1;
    const dashCount = 12;
    const dashAngle = 0.2;
    const gapAngle = (2 * 3.14159 / dashCount) - dashAngle;

    for (var i = 0; i < dashCount; i++) {
      final startAngle = i * (dashAngle + gapAngle);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        dashAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_DashedCirclePainter old) => old.color != color;
}
