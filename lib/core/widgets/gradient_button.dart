import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// Tombol dengan gradient primary — dipakai untuk aksi utama/CTA.
///
/// Gradient otomatis menyesuaikan theme (light/dark).
/// Mendukung state loading dan icon opsional.
///
/// Contoh:
/// ```dart
/// // Tombol sederhana
/// GradientButton(
///   label: 'Mulai Setoran',
///   onTap: () => context.push('/setoran'),
/// )
///
/// // Dengan icon
/// GradientButton(
///   label: 'Mulai Setoran',
///   icon: Icons.play_arrow_rounded,
///   onTap: () => context.push('/setoran'),
/// )
///
/// // Loading state
/// GradientButton(
///   label: 'Menyimpan...',
///   isLoading: true,
///   onTap: null,
/// )
/// ```
class GradientButton extends StatelessWidget {
  const GradientButton({
    required this.label,
    required this.onTap,
    this.icon,
    this.isLoading = false,
    this.width = double.infinity,
    super.key,
  });

  /// Teks label tombol.
  final String label;

  /// Callback tap. Pass null untuk disable tombol.
  final VoidCallback? onTap;

  /// Icon opsional di sisi kiri label.
  final IconData? icon;

  /// Tampilkan loading indicator, sembunyikan label. Default false.
  final bool isLoading;

  /// Lebar tombol. Default [double.infinity] (full width).
  final double width;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDisabled = onTap == null || isLoading;

    final gradient = LinearGradient(
      colors: isDark
          ? [AppColors.primaryDark, AppColors.primary]
          : [AppColors.primary, AppColors.primaryLight],
    );

    return SizedBox(
      width: width,
      child: Container(
        decoration: BoxDecoration(
          gradient: isDisabled ? null : gradient,
          color: isDisabled
              ? (isDark
                    ? AppColors.surfaceDarkVariant
                    : AppColors.surfaceVariant)
              : null,
          borderRadius: BorderRadius.circular(AppDimens.radiusLG),
          boxShadow: isDisabled
              ? null
              : [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimens.radiusLG),
          child: InkWell(
            onTap: isDisabled ? null : onTap,
            borderRadius: BorderRadius.circular(AppDimens.radiusLG),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppDimens.spaceMD,
                horizontal: AppDimens.spaceLG,
              ),
              child: Center(child: _buildContent(isDark, isDisabled)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(bool isDark, bool isDisabled) {
    final contentColor = isDisabled
        ? (isDark ? AppColors.onSurfaceDarkVariant : AppColors.textTertiary)
        : AppColors.onPrimary;

    if (isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(contentColor),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, color: contentColor, size: AppDimens.iconMD),
          const SizedBox(width: AppDimens.spaceSM),
        ],
        Text(
          label,
          style: AppTypography.serifHeadingSmall.copyWith(
            color: contentColor,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
