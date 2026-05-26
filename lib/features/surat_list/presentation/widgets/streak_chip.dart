import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:flutter/material.dart';

/// Streak chip — menampilkan jumlah hari berturut-turut membaca Quran.
class StreakChip extends StatelessWidget {
  const StreakChip({required this.streak, super.key});

  final int streak;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.pagePadding,
        AppDimens.spaceSM,
        AppDimens.pagePadding,
        AppDimens.spaceXS,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.spaceSM + 2,
              vertical: AppDimens.spaceXS,
            ),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.goldDark.withValues(alpha: 0.2)
                  : AppColors.goldLighter,
              borderRadius: BorderRadius.circular(AppDimens.radiusFull),
              border: Border.all(
                color: AppColors.gold.withValues(alpha: 0.4),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.local_fire_department_rounded,
                  color: Colors.orange,
                  size: 13,
                ),
                const SizedBox(width: AppDimens.spaceXS),
                Text(
                  '$streak hari berturut-turut',
                  style: TextStyle(
                    color: isDark ? AppColors.goldLight : AppColors.goldDark,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
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
