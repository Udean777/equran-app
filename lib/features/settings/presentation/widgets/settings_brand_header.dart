import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/core/widgets/app_logo.dart';
import 'package:equran_app/features/settings/presentation/constants/settings_constants.dart';
import 'package:equran_app/features/settings/presentation/constants/settings_strings.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Widget header brand premium untuk halaman Pengaturan (Settings).
///
/// Menampilkan logo eQuran teroptimasi, nama aplikasi serif, tagline,
/// serta badge versi rilisan resmi dengan aksen emas yang mewah.
class SettingsBrandHeader extends StatelessWidget {
  const SettingsBrandHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: AppDimens.spaceXL,
        horizontal: AppDimens.pagePadding,
      ),
      margin: const EdgeInsets.only(bottom: AppDimens.spaceMD),
      child: Column(
        children: [
          // App Logo container dengan bingkai emas dan bayangan mewah
          AppLogo(
            size: SettingsConstants.logoSize,
            borderRadius: BorderRadius.circular(AppDimens.radiusXL),
          ),
          const SizedBox(height: AppDimens.spaceMD),

          // Nama Aplikasi
          Text(
            SettingsStrings.brandName,
            style: AppTypography.serifHeadingLarge.copyWith(
              fontSize: SettingsConstants.fontSizeLarge,
              color: isDark ? Colors.white : AppColors.textPrimary,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: AppDimens.spaceXXS),

          // Tagline
          Text(
            SettingsStrings.brandTagline,
            style: TextStyle(
              fontSize: SettingsConstants.fontSizeSmall,
              color: isDark
                  ? AppColors.onSurfaceDarkVariant
                  : AppColors.textTertiary,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: AppDimens.spaceSM),

          // Badge Versi Aplikasi
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              final versionText = snapshot.hasData
                  ? 'v${snapshot.data!.version}'
                  : SettingsStrings.brandVersion;

              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.spaceSM,
                  vertical: AppDimens.spaceXXS,
                ),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                  border: Border.all(
                    color: AppColors.gold.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: SettingsConstants.badgeSize,
                      height: SettingsConstants.badgeSize,
                      decoration: const BoxDecoration(
                        color: AppColors.gold,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: AppDimens.spaceXS),
                    Text(
                      versionText,
                      style: const TextStyle(
                        fontSize: SettingsConstants.fontSizeExtraSmall,
                        fontWeight: FontWeight.bold,
                        color: AppColors.gold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
