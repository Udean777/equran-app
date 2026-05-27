import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/core/widgets/app_logo.dart';
import 'package:equran_app/features/onboarding/presentation/widgets/onboarding_shared.dart';
import 'package:flutter/material.dart';

/// Slide 6 — Siap Digunakan
class OnboardingSlide6 extends StatelessWidget {
  const OnboardingSlide6({super.key});

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
            'Semua Siap!',
            style: AppTypography.serifDisplayMedium.copyWith(
              color: Colors.white,
              fontSize: 36,
            ),
          ),
          const SizedBox(height: AppDimens.spaceMD),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.spaceXL,
            ),
            child: Text(
              'eQuran siap menemani ibadah harianmu. '
              'Semoga Allah memudahkan setiap langkah ibadahmu.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.65),
                fontSize: 15,
                height: 1.7,
              ),
            ),
          ),
          const SizedBox(height: AppDimens.spaceXL),

          // Arabic dua
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.spaceLG,
              vertical: AppDimens.spaceMD,
            ),
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppDimens.radiusLG),
              border: Border.all(
                color: AppColors.gold.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              children: [
                Text(
                  'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 22,
                    color: AppColors.gold.withValues(alpha: 0.9),
                    height: 1.8,
                  ),
                ),
                const SizedBox(height: AppDimens.spaceXS),
                Text(
                  'Dengan nama Allah Yang Maha Pengasih, Maha Penyayang',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
