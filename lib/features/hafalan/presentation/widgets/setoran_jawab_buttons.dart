import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// Tombol jawab hafal / belum hafal di bagian bawah setoran.
class SetoranJawabButtons extends StatelessWidget {
  const SetoranJawabButtons({
    required this.onHafal,
    required this.onBelumHafal,
    required this.isDark,
    super.key,
  });

  final VoidCallback onHafal;
  final VoidCallback onBelumHafal;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.pagePadding,
        AppDimens.spaceMD,
        AppDimens.pagePadding,
        AppDimens.spaceLG,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surface,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.outlineDark : AppColors.outlineVariant,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Belum Hafal
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onBelumHafal,
              icon: const Icon(
                Icons.close_rounded,
                color: AppColors.error,
                size: 18,
              ),
              label: const Text(
                'Belum Hafal',
                style: TextStyle(
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.error),
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimens.spaceMD,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimens.radiusLG),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppDimens.spaceMD),
          // Hafal
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryLight],
                ),
                borderRadius: BorderRadius.circular(AppDimens.radiusLG),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onHafal,
                  borderRadius: BorderRadius.circular(AppDimens.radiusLG),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppDimens.spaceMD,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.check_rounded,
                          color: AppColors.onPrimary,
                          size: 18,
                        ),
                        const SizedBox(width: AppDimens.spaceXS),
                        Text(
                          'Hafal',
                          style: AppTypography.serifHeadingSmall.copyWith(
                            color: AppColors.onPrimary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
