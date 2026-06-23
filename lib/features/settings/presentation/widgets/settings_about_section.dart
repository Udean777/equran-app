import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/core/widgets/luxury_divider.dart';
import 'package:equran_app/features/settings/presentation/constants/settings_constants.dart';
import 'package:equran_app/features/settings/presentation/constants/settings_strings.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Section informasi sumber data dan API yang digunakan aplikasi.
///
/// Menampilkan daftar sumber data beserta link yang dapat diklik:
/// API Al-Quran, terjemahan Kemenag, jadwal shalat MyQuran, dan audio adzan.
/// Link dibuka menggunakan [launchUrl] dari package `url_launcher`.
class SettingsAboutSection extends StatelessWidget {
  const SettingsAboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;
    final borderColor = isDark
        ? AppColors.outlineDark
        : AppColors.outlineVariant;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.pagePadding),
      child: Container(
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(AppDimens.radiusXL),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: isDark ? 0.04 : 0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(AppDimens.cardPaddingLG),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: SettingsConstants.iconContainerSizeLarge,
                  height: SettingsConstants.iconContainerSizeLarge,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.primaryDark
                        : AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(AppDimens.radiusMD),
                    border: Border.all(
                      color: AppColors.gold.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Icon(
                    Icons.cloud_done_outlined,
                    color: isDark
                        ? AppColors.primaryLighter
                        : AppColors.primary,
                    size: 26,
                  ),
                ),
                const SizedBox(width: AppDimens.spaceMD),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        SettingsStrings.aboutDataSourceTitle,
                        style: AppTypography.serifHeadingSmall.copyWith(
                          color: isDark
                              ? AppColors.onSurfaceDark
                              : AppColors.textPrimary,
                          fontSize: SettingsConstants.fontSizeDisplay,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        SettingsStrings.aboutDataSourceSubtitle,
                        style: TextStyle(
                          fontSize: SettingsConstants.fontSizeSecondary,
                          color: isDark
                              ? AppColors.onSurfaceDarkVariant
                              : AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppDimens.spaceMD),

            const GoldDivider(verticalMargin: 0),

            const SizedBox(height: AppDimens.spaceMD),

            _LinkTile(
              icon: Icons.api_rounded,
              label: SettingsStrings.aboutEquranAPI,
              url: SettingsStrings.aboutEquranURL,
              isDark: isDark,
            ),
            const SizedBox(height: AppDimens.spaceXS),
            _LinkTile(
              icon: Icons.translate_rounded,
              label: SettingsStrings.aboutKemenagTranslation,
              url: SettingsStrings.aboutKemenagURL,
              isDark: isDark,
            ),
            const SizedBox(height: AppDimens.spaceXS),
            _LinkTile(
              icon: Icons.location_on_outlined,
              label: SettingsStrings.aboutMyQuranAPI,
              url: SettingsStrings.aboutMyQuranURL,
              isDark: isDark,
            ),
            const SizedBox(height: AppDimens.spaceXS),
            _LinkTile(
              icon: Icons.volume_up_outlined,
              label: SettingsStrings.aboutAdzanAudio,
              url: SettingsStrings.aboutAdzanURL,
              displayUrl: SettingsStrings.aboutAdzanDomain,
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }
}

/// Tile yang dapat diklik untuk membuka URL eksternal.
///
/// Menampilkan ikon, label sumber data, dan domain URL.
/// Menggunakan [launchUrl] untuk membuka browser.
class _LinkTile extends StatelessWidget {
  const _LinkTile({
    required this.icon,
    required this.label,
    required this.url,
    required this.isDark,
    this.displayUrl,
  });

  final IconData icon;
  final String label;
  final String url;
  final bool isDark;
  final String? displayUrl;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => launchUrl(Uri.parse(url)),
      borderRadius: BorderRadius.circular(AppDimens.radiusMD),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppDimens.spaceXS,
          horizontal: AppDimens.spaceXS,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isDark ? AppColors.primaryLighter : AppColors.primary,
            ),
            const SizedBox(width: AppDimens.spaceSM),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: SettingsConstants.fontSizeSmall,
                  color: isDark
                      ? AppColors.onSurfaceDark
                      : AppColors.textPrimary,
                ),
              ),
            ),
            Text(
              displayUrl ?? url.replaceFirst('https://', ''),
              style: TextStyle(
                fontSize: SettingsConstants.fontSizeTertiary,
                color: isDark ? AppColors.primaryLighter : AppColors.primary,
                decoration: TextDecoration.underline,
                decorationColor: isDark
                    ? AppColors.primaryLighter
                    : AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
