import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:flutter/material.dart';

class DoaTranslationCard extends StatelessWidget {
  const DoaTranslationCard({
    required this.label,
    required this.text,
    super.key,
  });

  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;
    final borderColor = isDark
        ? AppColors.outlineDark
        : AppColors.outlineVariant;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.pagePadding,
        AppDimens.spaceXS,
        AppDimens.pagePadding,
        AppDimens.spaceXS,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(AppDimens.radiusLG),
          border: Border.all(color: borderColor),
        ),
        padding: const EdgeInsets.all(AppDimens.cardPaddingLG),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label dengan gold accent
            Row(
              children: [
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
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.primaryLighter
                        : AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimens.spaceMD),
            Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.7,
                color: isDark
                    ? AppColors.onSurfaceDark
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
