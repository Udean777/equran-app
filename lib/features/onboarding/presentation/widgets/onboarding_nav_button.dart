import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:flutter/material.dart';

class OnboardingNavButton extends StatelessWidget {
  const OnboardingNavButton({
    required this.label,
    required this.isPrimary,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool isPrimary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (isPrimary) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.gold, AppColors.goldDark],
            ),
            borderRadius: BorderRadius.circular(AppDimens.radiusFull),
            boxShadow: [
              BoxShadow(
                color: AppColors.gold.withValues(alpha: 0.35),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.onGold,
              fontWeight: FontWeight.w700,
              fontSize: 15,
              letterSpacing: 0.3,
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppDimens.radiusFull),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
