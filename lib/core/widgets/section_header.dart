import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// Header section luxury — gold accent bar + optional icon + serif label.
///
/// Contoh penggunaan:
/// ```dart
/// // Sederhana
/// SectionHeader(label: 'Daftar Surah')
///
/// // Dengan icon
/// SectionHeader(label: 'Tampilan', icon: Icons.palette_outlined)
///
/// // Dengan trailing
/// SectionHeader(label: 'Daftar Surah', trailing: Text('114 Surah'))
/// ```
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.label,
    this.icon,
    this.trailing,
    this.showBackButton = false,
    this.onBack,
    super.key,
  });

  /// Label teks utama section.
  final String label;

  /// Icon opsional yang ditampilkan di antara gold bar dan label.
  final IconData? icon;

  /// Widget opsional di sisi kanan (misal count label, action button).
  final Widget? trailing;

  /// Tampilkan back button di sisi kiri (sebelum gold bar).
  final bool showBackButton;

  /// Callback back button. Jika null, pakai [Navigator.maybePop].
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.onSurfaceDark : AppColors.textPrimary;
    final iconColor = isDark ? AppColors.primaryLighter : AppColors.primary;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.pagePadding,
        AppDimens.spaceLG,
        AppDimens.pagePadding,
        AppDimens.spaceSM,
      ),
      child: Row(
        children: [
          // Back button opsional
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
                  color: iconColor,
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

          // Icon opsional
          if (icon != null) ...[
            Icon(icon, size: AppDimens.iconSM, color: iconColor),
            const SizedBox(width: AppDimens.spaceXS),
          ],

          // Label
          Expanded(
            child: Text(
              label,
              style: AppTypography.serifHeadingSmall.copyWith(
                color: textColor,
                fontSize: 15,
              ),
            ),
          ),

          // Trailing opsional
          ?trailing,
        ],
      ),
    );
  }
}
