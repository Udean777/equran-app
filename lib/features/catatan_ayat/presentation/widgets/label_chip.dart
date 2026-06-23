import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:flutter/material.dart';

class LabelChip extends StatelessWidget {
  const LabelChip({
    required this.label,
    this.icon,
    this.color,
    super.key,
  });

  final String label;
  final IconData? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final effectiveColor =
        color ?? (isDark ? AppColors.primaryLighter : AppColors.primary);
    final bgColor = isDark ? AppColors.primaryDark : AppColors.primaryContainer;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceSM,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppDimens.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 11, color: effectiveColor),
            const SizedBox(width: 3),
          ],
          Text(
            label,
            style: TextStyle(
              color: effectiveColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
