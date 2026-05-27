import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

class SectionLabel extends StatelessWidget {
  const SectionLabel({required this.label, required this.isDark, super.key});

  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: AppDimens.spaceXS),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 14,
            decoration: BoxDecoration(
              color: AppColors.gold,
              borderRadius: BorderRadius.circular(AppDimens.radiusFull),
            ),
          ),
          const SizedBox(width: AppDimens.spaceSM),
          Text(
            label,
            style: AppTypography.serifHeadingSmall.copyWith(
              fontSize: 13,
              color: isDark ? AppColors.onSurfaceDark : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
