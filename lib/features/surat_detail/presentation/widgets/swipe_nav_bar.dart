import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/features/surat_detail/presentation/viewmodels/auto_read_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Bottom navigation bar untuk card stack — arrow prev/next + progress bar.
class SwipeNavBar extends ConsumerWidget {
  const SwipeNavBar({
    required this.totalAyat,
    this.onComplete,
    super.key,
  });

  final int totalAyat;
  final VoidCallback? onComplete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardState = ref.watch(cardStackProvider(totalAyat));
    final isDark = context.isDark;
    final primaryColor = context.primaryActionColor;
    final disabledColor = isDark
        ? AppColors.outlineDark
        : AppColors.textDisabled;
    final surfaceColor = context.surfaceColor;
    final borderColor = context.borderSubtleColor;

    final isFirst = cardState.isFirst;
    final isLast = cardState.isLast;
    final isInfoCard = cardState.isInfoCard;
    final currentIndex = cardState.currentIndex;
    final totalAyatCount = cardState.totalAyat;

    // Label tengah
    final label = isInfoCard
        ? 'Info Surat'
        : 'Ayat $currentIndex / $totalAyatCount';

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
              value: cardState.currentProgress,
              minHeight: 3,
              backgroundColor: context.primaryContainerColor,
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
                onPressed: isFirst
                    ? null
                    : () => ref
                          .read(cardStackProvider(totalAyat).notifier)
                          .goPrev(),
                color: isFirst ? disabledColor : primaryColor,
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
                        color: context.textPrimaryColor,
                        height: 1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (!isInfoCard) ...[
                      const SizedBox(height: 3),
                      Text(
                        '${(cardState.currentProgress * 100).round()}% selesai',
                        style: TextStyle(
                          fontSize: 10,
                          color: context.textTertiaryColor,
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
                icon: isLast
                    ? Icons.check_rounded
                    : Icons.arrow_forward_ios_rounded,
                onPressed: isLast
                    ? onComplete
                    : () => ref
                          .read(cardStackProvider(totalAyat).notifier)
                          .goNext(),
                color: isLast
                    ? isDark
                          ? AppColors.goldLight
                          : AppColors.goldDark
                    : primaryColor,
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
    this.onPressed,
  });

  final IconData icon;
  final Color color;
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
                ? context.primaryContainerColor
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppDimens.radiusMD),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
      ),
    );
  }
}
