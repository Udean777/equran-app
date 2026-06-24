import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/cubit/quran_font_cubit.dart';
import 'package:equran_app/features/surat_list/constants/surat_list_constants.dart';
import 'package:equran_app/features/surat_list/domain/entities/surat.dart';
import 'package:equran_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class SuratCard extends StatelessWidget {
  const SuratCard({
    required this.surat,
    required this.onTap,
    this.onPlayTap,
    this.scrollPercent,
    super.key,
  });

  final Surat surat;
  final VoidCallback onTap;
  final VoidCallback? onPlayTap;
  final double? scrollPercent;

  @override
  Widget build(BuildContext context) {
    final isCompleted = scrollPercent == 1.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.spaceSM),
      child: Material(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimens.radiusLG),
          splashColor: AppColors.primaryContainer.withValues(alpha: 0.5),
          highlightColor: AppColors.primaryContainer.withValues(alpha: 0.3),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimens.radiusLG),
              border: Border.all(
                color: isCompleted
                    ? (context.isDark
                          ? AppColors.gold.withValues(alpha: 0.3)
                          : AppColors.gold.withValues(alpha: 0.5))
                    : context.borderSubtleColor,
                width: isCompleted ? AppDimens.goldBorderWidth : 1.0,
              ),
            ),
            child: Column(
              children: [
                _SuratCardBody(
                  surat: surat,
                  isCompleted: isCompleted,
                  onPlayTap: onPlayTap,
                ),
                if (scrollPercent != null)
                  _SuratProgressBar(
                    scrollPercent: scrollPercent!,
                    isCompleted: isCompleted,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SuratNomorBadge extends StatelessWidget {
  const SuratNomorBadge({required this.nomor, super.key});

  final int nomor;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Container(
      width: SuratListConstants.badgeSize,
      height: SuratListConstants.badgeSize,
      decoration: BoxDecoration(
        color: isDark ? AppColors.primaryDark : AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(AppDimens.radiusSM),
        border: Border.all(
          color: isDark
              ? AppColors.primaryLight.withValues(alpha: 0.3)
              : AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        nomor.toString(),
        style: TextStyle(
          color: isDark ? AppColors.primaryLighter : AppColors.primary,
          fontWeight: FontWeight.w700,
          fontSize: nomor > SuratListConstants.badgeLargeNumberThreshold
              ? SuratListConstants.badgeFontSizeLarge
              : SuratListConstants.badgeFontSizeSmall,
        ),
      ),
    );
  }
}

class SuratTempatTurunBadge extends StatelessWidget {
  const SuratTempatTurunBadge({
    required this.tempatTurun,
    required this.l10n,
    super.key,
  });

  final TempatTurun tempatTurun;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final isMekah = tempatTurun == TempatTurun.mekah;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceSM,
        vertical: AppDimens.spaceXXS,
      ),
      decoration: BoxDecoration(
        color: isMekah ? AppColors.mekahBadge : AppColors.madinahBadge,
        borderRadius: BorderRadius.circular(AppDimens.radiusFull),
      ),
      child: Text(
        isMekah ? l10n.mekah : l10n.madinah,
        style: TextStyle(
          color: isMekah
              ? AppColors.mekahBadgeText
              : AppColors.madinahBadgeText,
          fontSize: SuratListConstants.tempatTurunFontSize,
          fontWeight: FontWeight.w600,
          letterSpacing: SuratListConstants.letterSpacingSubtle,
        ),
      ),
    );
  }
}

class _SuratCardBody extends StatelessWidget {
  const _SuratCardBody({
    required this.surat,
    required this.isCompleted,
    this.onPlayTap,
  });

  final Surat surat;
  final bool isCompleted;
  final VoidCallback? onPlayTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.cardPaddingLG,
        vertical: AppDimens.cardPadding,
      ),
      child: Row(
        children: [
          SuratNomorBadge(nomor: surat.nomor),
          const SizedBox(width: AppDimens.spaceMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      surat.namaLatin,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: context.textPrimaryColor,
                        fontSize: SuratListConstants.namaLatinFontSize,
                      ),
                    ),
                    if (isCompleted) ...[
                      const SizedBox(width: AppDimens.spaceXS),
                      const Icon(
                        Icons.verified_rounded,
                        color: AppColors.gold,
                        size: AppDimens.iconSM,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Text(
                      l10n.ayatCount(surat.jumlahAyat),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: context.textTertiaryColor,
                        fontSize: SuratListConstants.ayatCountFontSize,
                      ),
                    ),
                    const SizedBox(width: AppDimens.spaceXS),
                    SuratTempatTurunBadge(
                      tempatTurun: surat.tempatTurun,
                      l10n: l10n,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                surat.nama,
                style: TextStyle(
                  fontFamily: kFontAmiri,
                  fontSize: SuratListConstants.arabicFontSize,
                  color: context.primaryActionColor,
                  height: SuratListConstants.arabicLineHeight,
                ),
              ),
              if (onPlayTap != null) ...[
                const SizedBox(height: AppDimens.spaceXS),
                GestureDetector(
                  onTap: onPlayTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.spaceSM,
                      vertical: SuratListConstants.progressMinHeight,
                    ),
                    decoration: BoxDecoration(
                      color: context.primaryContainerColor,
                      borderRadius: BorderRadius.circular(
                        AppDimens.radiusFull,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.play_arrow_rounded,
                          size: AppDimens.iconXS,
                          color: context.primaryActionColor,
                        ),
                        const SizedBox(width: AppDimens.spaceXXS),
                        Text(
                          l10n.play,
                          style: TextStyle(
                            color: context.primaryActionColor,
                            fontSize: SuratListConstants.playBadgeFontSize,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _SuratProgressBar extends StatelessWidget {
  const _SuratProgressBar({
    required this.scrollPercent,
    required this.isCompleted,
  });

  final double scrollPercent;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(AppDimens.radiusLG),
        bottomRight: Radius.circular(AppDimens.radiusLG),
      ),
      child: LinearProgressIndicator(
        value: scrollPercent,
        minHeight: SuratListConstants.progressMinHeight,
        backgroundColor: context.primaryContainerColor,
        valueColor: AlwaysStoppedAnimation<Color>(
          isCompleted
              ? AppColors.gold
              : context.primaryActionColor,
        ),
      ),
    );
  }
}
