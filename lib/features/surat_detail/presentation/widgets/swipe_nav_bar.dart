import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/features/surat_detail/presentation/controllers/card_stack_controller.dart';
import 'package:flutter/material.dart';

/// Bottom navigation bar untuk card stack — arrow prev/next + progress bar.
class SwipeNavBar extends StatelessWidget {
  const SwipeNavBar({
    required this.controller,
    super.key,
  });

  final CardStackController controller;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor =
        isDark ? AppColors.primaryLighter : AppColors.primary;
    final disabledColor =
        isDark ? AppColors.outlineDark : AppColors.textDisabled;
    final surfaceColor =
        isDark ? AppColors.surfaceDark : AppColors.surface;
    final borderColor =
        isDark ? AppColors.outlineDark : AppColors.outlineVariant;

    final isFirst = controller.isFirst;
    final isLast = controller.isLast;
    final isInfoCard = controller.isInfoCard;
    final currentIndex = controller.currentIndex;
    final totalAyat = controller.totalAyat;

    // Label tengah
    final label = isInfoCard
        ? 'Info Surat'
        : 'Ayat $currentIndex / $totalAyat';

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        border: Border(
          top: BorderSide(color: borderColor),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppDimens.spaceSM,
        AppDimens.spaceXS,
        AppDimens.spaceSM,
        AppDimens.spaceSM,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimens.radiusFull),
            child: LinearProgressIndicator(
              value: controller.currentProgress,
              minHeight: 3,
              backgroundColor:
                  isDark ? AppColors.primaryDark : AppColors.primaryContainer,
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ),
          ),

          const SizedBox(height: AppDimens.spaceXS),

          // Controls row
          Row(
            children: [
              // Prev button
              _NavButton(
                icon: Icons.arrow_back_ios_rounded,
                onPressed: isFirst ? null : controller.goPrev,
                color: isFirst ? disabledColor : primaryColor,
                isDark: isDark,
              ),

              // Label + ayat counter
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: AppTypography.serifHeadingSmall.copyWith(
                        fontSize: 13,
                        color: isDark
                            ? AppColors.onSurfaceDark
                            : AppColors.textPrimary,
                        height: 1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (!isInfoCard) ...[
                      const SizedBox(height: 3),
                      Text(
                        '${(controller.currentProgress * 100).round()}% selesai',
                        style: TextStyle(
                          fontSize: 10,
                          color: isDark
                              ? AppColors.onSurfaceDarkVariant
                              : AppColors.textTertiary,
                          letterSpacing: 0.3,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),

              // Next button
              _NavButton(
                icon: Icons.arrow_forward_ios_rounded,
                onPressed: isLast ? null : controller.goNext,
                color: isLast ? disabledColor : primaryColor,
                isDark: isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.icon,
    required this.color,
    required this.isDark,
    this.onPressed,
  });

  final IconData icon;
  final Color color;
  final bool isDark;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppDimens.radiusMD),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppDimens.radiusMD),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: onPressed != null
                ? (isDark
                    ? AppColors.primaryDark
                    : AppColors.primaryContainer)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppDimens.radiusMD),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
      ),
    );
  }
}
