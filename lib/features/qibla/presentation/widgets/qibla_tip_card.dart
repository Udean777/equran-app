import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/widgets/luxury_card.dart';
import 'package:flutter/material.dart';

/// Card tip akurasi kompas Qibla.
class QiblaTipCard extends StatelessWidget {
  const QiblaTipCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final theme = Theme.of(context);

    return LuxuryCard(
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.goldDark.withValues(alpha: 0.2)
                  : AppColors.goldLighter,
              borderRadius: BorderRadius.circular(AppDimens.radiusSM),
            ),
            child: const Icon(
              Icons.tips_and_updates_outlined,
              size: 16,
              color: AppColors.goldDark,
            ),
          ),
          const SizedBox(width: AppDimens.spaceMD),
          Expanded(
            child: Text(
              'Jauhkan dari benda logam, magnet, dan elektronik '
              'untuk hasil yang lebih akurat.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark
                    ? AppColors.onSurfaceDarkVariant
                    : AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
