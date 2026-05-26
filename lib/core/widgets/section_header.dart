import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// Header section luxury — gold accent bar + serif label.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.label,
    this.showBackButton = false,
    this.onBack,
    super.key,
  });

  final String label;
  final bool showBackButton;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.pagePadding,
        AppDimens.spaceLG,
        AppDimens.pagePadding,
        AppDimens.spaceSM,
      ),
      child: Row(
        children: [
          if (showBackButton) ...[
            GestureDetector(
              onTap: onBack ?? () => Navigator.maybePop(context),
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.primaryDark
                      : AppColors.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_back_rounded,
                  size: 14,
                  color: isDark ? AppColors.primaryLighter : AppColors.primary,
                ),
              ),
            ),
            const SizedBox(width: AppDimens.spaceSM),
          ],
          // Gold accent bar
          Container(
            width: 3,
            height: 16,
            decoration: BoxDecoration(
              color: AppColors.gold,
              borderRadius: BorderRadius.circular(AppDimens.radiusFull),
            ),
          ),
          const SizedBox(width: AppDimens.spaceSM),
          Text(
            label,
            style: AppTypography.serifHeadingSmall.copyWith(
              color: isDark ? AppColors.onSurfaceDark : AppColors.textPrimary,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
