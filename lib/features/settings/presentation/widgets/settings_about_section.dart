import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/core/widgets/luxury_divider.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Section sumber data & API — card equran.id dengan link.
class SettingsAboutSection extends StatelessWidget {
  const SettingsAboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
                  width: 48,
                  height: 48,
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
                        'Sumber Data',
                        style: AppTypography.serifHeadingSmall.copyWith(
                          color: isDark
                              ? AppColors.onSurfaceDark
                              : AppColors.textPrimary,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Data Al-Quran & Audio Pendukung',
                        style: TextStyle(
                          fontSize: 12,
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
              label: 'API Al-Quran',
              url: 'https://equran.id',
              isDark: isDark,
            ),
            const SizedBox(height: AppDimens.spaceXS),
            _LinkTile(
              icon: Icons.translate_rounded,
              label: 'Terjemahan Kemenag RI',
              url: 'https://quran.kemenag.go.id',
              isDark: isDark,
            ),
            const SizedBox(height: AppDimens.spaceXS),
            _LinkTile(
              icon: Icons.location_on_outlined,
              label: 'Jadwal Shalat MyQuran',
              url: 'https://api.myquran.com',
              isDark: isDark,
            ),
            const SizedBox(height: AppDimens.spaceXS),
            _LinkTile(
              icon: Icons.volume_up_outlined,
              label: 'Audio Adzan (IslamDownload)',
              url: 'https://islamdownload.net/123801-download-suara-adzan.html',
              displayUrl: 'islamdownload.net',
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }
}

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
                  fontSize: 13,
                  color: isDark
                      ? AppColors.onSurfaceDark
                      : AppColors.textPrimary,
                ),
              ),
            ),
            Text(
              displayUrl ?? url.replaceFirst('https://', ''),
              style: TextStyle(
                fontSize: 11,
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
