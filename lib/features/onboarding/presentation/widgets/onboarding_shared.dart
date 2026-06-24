import 'dart:math';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/features/onboarding/constants/onboarding_constants.dart';
import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Base slide layout — gradient background + safe area
// ---------------------------------------------------------------------------

class OnboardingSlideBase extends StatelessWidget {
  const OnboardingSlideBase({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            OnboardingColors.background,
            OnboardingColors.backgroundEnd,
            OnboardingColors.background,
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppDimens.pagePadding,
            AppDimens.spaceXL,
            AppDimens.pagePadding,
            AppDimens.spaceMD,
          ),
          child: child,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Arabesque ornament
// ---------------------------------------------------------------------------

class OnboardingArabesqueOrnament extends StatelessWidget {
  const OnboardingArabesqueOrnament({required this.size, super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _ArabesquePainter()),
    );
  }
}

class _ArabesquePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paintOuter = Paint()
      ..color = AppColors.gold.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final paintInner = Paint()
      ..color = AppColors.gold.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final paintCore = Paint()
      ..color = AppColors.gold.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas
      ..drawCircle(center, radius, paintOuter)
      ..drawCircle(center, radius * 0.85, paintOuter)
      ..drawCircle(center, radius * 0.65, paintInner)
      ..drawCircle(center, radius * 0.45, paintInner)
      ..drawCircle(center, radius * 0.25, paintCore);
    final starPaint = Paint()
      ..color = AppColors.gold.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path();
    for (var i = 0; i < 8; i++) {
      final angle = i * 45 * (pi / 180);
      final outerX = center.dx + radius * 0.55 * cos(angle);
      final outerY = center.dy + radius * 0.55 * sin(angle);
      final innerAngle = angle + 22.5 * (pi / 180);
      final innerX = center.dx + radius * 0.28 * cos(innerAngle);
      final innerY = center.dy + radius * 0.28 * sin(innerAngle);
      if (i == 0) {
        path.moveTo(outerX, outerY);
      } else {
        path.lineTo(outerX, outerY);
      }
      path.lineTo(innerX, innerY);
    }
    path.close();
    canvas
      ..drawPath(path, starPaint)
      // Center dot
      ..drawCircle(
        center,
        4,
        Paint()..color = AppColors.gold.withValues(alpha: 0.8),
      );

    // Radial lines
    final linePaint = Paint()
      ..color = AppColors.gold.withValues(alpha: 0.15)
      ..strokeWidth = 1;
    for (var i = 0; i < 16; i++) {
      final angle = i * 22.5 * (pi / 180);
      canvas.drawLine(
        Offset(
          center.dx + radius * 0.65 * cos(angle),
          center.dy + radius * 0.65 * sin(angle),
        ),
        Offset(
          center.dx + radius * 0.85 * cos(angle),
          center.dy + radius * 0.85 * sin(angle),
        ),
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ---------------------------------------------------------------------------
// Feature slide layout
// ---------------------------------------------------------------------------

class OnboardingFeatureSlide extends StatelessWidget {
  const OnboardingFeatureSlide({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.features,
    super.key,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String description;
  final List<OnboardingFeaturePoint> features;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon badge
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.gold.withValues(alpha: 0.3),
                AppColors.gold.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(AppDimens.radiusXL),
            border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
          ),
          child: Icon(icon, color: AppColors.gold, size: 36),
        ),
        const SizedBox(height: AppDimens.spaceLG),

        // Subtitle
        Text(
          subtitle.toUpperCase(),
          style: TextStyle(
            color: AppColors.gold.withValues(alpha: 0.8),
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: AppDimens.spaceXS),

        // Title
        Text(
          title,
          style: AppTypography.serifHeadingLarge.copyWith(
            color: Colors.white,
            fontSize: 28,
          ),
        ),
        const SizedBox(height: AppDimens.spaceSM),

        // Description
        Text(
          description,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.65),
            fontSize: 14,
            height: 1.6,
          ),
        ),
        const SizedBox(height: AppDimens.spaceXL),

        // Feature points
        ...features.map(
          (f) => Padding(
            padding: const EdgeInsets.only(bottom: AppDimens.spaceMD),
            child: f,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Feature point item
// ---------------------------------------------------------------------------

class OnboardingFeaturePoint extends StatelessWidget {
  const OnboardingFeaturePoint({
    required this.icon,
    required this.text,
    super.key,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.primaryLight.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(AppDimens.radiusSM),
          ),
          child: Icon(icon, color: AppColors.gold, size: 16),
        ),
        const SizedBox(width: AppDimens.spaceMD),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.75),
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
