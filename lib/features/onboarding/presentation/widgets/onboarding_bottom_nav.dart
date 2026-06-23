import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/onboarding/constants/onboarding_constants.dart';
import 'package:equran_app/features/onboarding/presentation/widgets/onboarding_nav_button.dart';
import 'package:flutter/material.dart';

class OnboardingBottomNav extends StatelessWidget {
  const OnboardingBottomNav({
    required this.currentPage,
    required this.totalPages,
    required this.isLastPage,
    required this.isPermissionSlide,
    required this.permissionRequested,
    required this.allPermissionsGranted,
    required this.bottomPadding,
    required this.onNext,
    required this.onPrev,
    required this.onSkip,
    required this.onFinish,
    super.key,
  });

  final int currentPage;
  final int totalPages;
  final bool isLastPage;
  final bool isPermissionSlide;
  final bool permissionRequested;
  final bool allPermissionsGranted;
  final double bottomPadding;
  final VoidCallback onNext;
  final VoidCallback onPrev;
  final VoidCallback onSkip;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            OnboardingColors.background.withValues(alpha: 0),
            OnboardingColors.background,
          ],
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        AppDimens.pagePadding,
        AppDimens.spaceLG,
        AppDimens.pagePadding,
        bottomPadding + AppDimens.spaceLG,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              totalPages,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(
                  horizontal: AppDimens.spaceXS,
                ),
                width: i == currentPage ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: i == currentPage
                      ? AppColors.gold
                      : AppColors.gold.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppDimens.spaceMD),

          Row(
            children: [
              if (currentPage > 0) ...[
                Expanded(
                  child: OnboardingNavButton(
                    label: 'Kembali',
                    isPrimary: false,
                    onTap: onPrev,
                  ),
                ),
                const SizedBox(width: AppDimens.spaceMD),
              ],
              Expanded(
                flex: currentPage > 0 ? 1 : 1,
                child: isLastPage
                    ? OnboardingNavButton(
                        label: 'Mulai Sekarang',
                        isPrimary: true,
                        onTap: onFinish,
                      )
                    : isPermissionSlide && allPermissionsGranted
                    ? OnboardingNavButton(
                        label: 'Lewati',
                        isPrimary: false,
                        onTap: onSkip,
                      )
                    : OnboardingNavButton(
                        label: 'Lanjut',
                        isPrimary: true,
                        onTap: onNext,
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
