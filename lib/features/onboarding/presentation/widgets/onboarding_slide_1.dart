import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/core/widgets/app_logo.dart';
import 'package:equran_app/features/onboarding/presentation/widgets/onboarding_shared.dart';
import 'package:flutter/material.dart';

/// Slide 1 — Welcome
class OnboardingSlide1 extends StatelessWidget {
  const OnboardingSlide1({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingSlideBase(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppLogo(
            size: 100,
            borderRadius: BorderRadius.circular(AppDimens.radiusLG),
          ),
          const SizedBox(height: AppDimens.spaceXL),
          Text(
            'eQuran',
            style: AppTypography.serifDisplayLarge.copyWith(
              color: AppColors.gold,
              fontSize: 48,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: AppDimens.spaceSM),
          Text(
            'Teman Ibadah Sehari-hari',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 16,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: AppDimens.spaceXL),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 1,
                color: AppColors.gold.withValues(alpha: 0.4),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.spaceMD,
                ),
                child: Icon(
                  Icons.star_rounded,
                  color: AppColors.gold.withValues(alpha: 0.6),
                  size: 12,
                ),
              ),
              Container(
                width: 40,
                height: 1,
                color: AppColors.gold.withValues(alpha: 0.4),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceXL),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceXL),
            child: Text(
              'Al-Quran digital lengkap dengan jadwal shalat, '
              'pengingat adzan, hafalan, dan statistik ibadah harian.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.65),
                fontSize: 14,
                height: 1.7,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
