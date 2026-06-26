import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/hafalan/domain/entities/hafalan_surat.dart';
import 'package:equran_app/features/surat_list/presentation/constants/surat_list_constants.dart';
import 'package:equran_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class MurajaahReminderCard extends StatelessWidget {
  const MurajaahReminderCard({
    required this.suratList,
    required this.onTap,
    super.key,
  });

  final List<HafalanSurat> suratList;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    final displaySurats = suratList
        .take(SuratListConstants.murajaahMaxDisplaySurat)
        .toList();
    final hasExtra =
        suratList.length > SuratListConstants.murajaahMaxDisplaySurat;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.pagePadding,
        AppDimens.spaceXS,
        AppDimens.pagePadding,
        AppDimens.spaceXS,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimens.radiusLG),
          gradient: LinearGradient(
            colors: context.isDark
                ? [const Color(0xFF12241A), const Color(0xFF1B3626)]
                : [const Color(0xFFFAFDFB), const Color(0xFFEEF6F1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: AppColors.gold.withValues(
              alpha: context.isDark ? 0.35 : 0.45,
            ),
            width: SuratListConstants.murajaahBorderWidth,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: context.isDark ? 0.25 : 0.05,
              ),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimens.radiusLG),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppDimens.radiusLG),
            splashColor: AppColors.gold.withValues(alpha: 0.1),
            highlightColor: AppColors.gold.withValues(alpha: 0.05),
            child: Padding(
              padding: const EdgeInsets.all(AppDimens.cardPaddingLG),
              child: Row(
                children: [
                  const _MurajaahIcon(),
                  const SizedBox(width: AppDimens.spaceMD),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              l10n.murajaahToday,
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: context.isDark
                                    ? AppColors.goldLight
                                    : AppColors.goldDark,
                                fontWeight: FontWeight.w800,
                                fontSize:
                                    SuratListConstants.murajaahTitleFontSize,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(width: AppDimens.spaceXS),
                            const _MurajaahDot(),
                          ],
                        ),
                        const SizedBox(height: 6),
                        _MurajaahChips(
                          displaySurats: displaySurats,
                          hasExtra: hasExtra,
                          extraCount:
                              suratList.length -
                              SuratListConstants.murajaahMaxDisplaySurat,
                          l10n: l10n,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppDimens.spaceSM),
                  const _MurajaahActionButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MurajaahIcon extends StatelessWidget {
  const _MurajaahIcon();

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Container(
      width: SuratListConstants.murajaahIconSize,
      height: SuratListConstants.murajaahIconSize,
      decoration: BoxDecoration(
        color: AppColors.gold.withValues(alpha: isDark ? 0.15 : 0.1),
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.gold.withValues(alpha: isDark ? 0.3 : 0.4),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: isDark ? 0.1 : 0.05),
            blurRadius: 6,
            spreadRadius: 1,
          ),
        ],
      ),
      child: const Icon(
        Icons.auto_stories_rounded,
        color: AppColors.gold,
        size: AppDimens.bottomNavIconSize,
      ),
    );
  }
}

class _MurajaahDot extends StatelessWidget {
  const _MurajaahDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SuratListConstants.murajaahDotSize,
      height: SuratListConstants.murajaahDotSize,
      decoration: const BoxDecoration(
        color: AppColors.gold,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _MurajaahChips extends StatelessWidget {
  const _MurajaahChips({
    required this.displaySurats,
    required this.hasExtra,
    required this.extraCount,
    required this.l10n,
  });

  final List<HafalanSurat> displaySurats;
  final bool hasExtra;
  final int extraCount;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppDimens.spaceXS,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ...displaySurats.map(
          (s) => _MurajaahSuratChip(namaLatin: s.namaLatin),
        ),
        if (hasExtra)
          _MurajaahExtraChip(
            extraCount: extraCount,
            l10n: l10n,
          ),
      ],
    );
  }
}

class _MurajaahSuratChip extends StatelessWidget {
  const _MurajaahSuratChip({required this.namaLatin});

  final String namaLatin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = context.isDark;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceXS + 1,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.gold.withValues(alpha: 0.12)
            : AppColors.gold.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppDimens.radiusSM),
        border: Border.all(
          color: AppColors.gold.withValues(alpha: isDark ? 0.35 : 0.3),
          width: SuratListConstants.murajaahChipBorderWidth,
        ),
      ),
      child: Text(
        namaLatin,
        style: theme.textTheme.labelSmall?.copyWith(
          color: isDark ? AppColors.goldLight : AppColors.goldDark,
          fontWeight: FontWeight.w600,
          fontSize: SuratListConstants.murajaahChipFontSize,
        ),
      ),
    );
  }
}

class _MurajaahExtraChip extends StatelessWidget {
  const _MurajaahExtraChip({
    required this.extraCount,
    required this.l10n,
  });

  final int extraCount;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = context.isDark;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceXS + 1,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.primaryLighter.withValues(alpha: 0.15)
            : AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(AppDimens.radiusSM),
        border: Border.all(
          color: isDark
              ? AppColors.primaryLighter.withValues(alpha: 0.3)
              : AppColors.primary.withValues(alpha: 0.25),
          width: SuratListConstants.murajaahChipBorderWidth,
        ),
      ),
      child: Text(
        l10n.andMore(extraCount),
        style: theme.textTheme.labelSmall?.copyWith(
          color: context.primaryActionColor,
          fontWeight: FontWeight.bold,
          fontSize: SuratListConstants.murajaahChipFontSize,
        ),
      ),
    );
  }
}

class _MurajaahActionButton extends StatelessWidget {
  const _MurajaahActionButton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = context.isDark;
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.gold.withValues(alpha: 0.2) : AppColors.gold,
        borderRadius: BorderRadius.circular(AppDimens.radiusMD),
        border: isDark
            ? Border.all(
                color: AppColors.gold.withValues(alpha: 0.4),
              )
            : null,
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: AppColors.gold.withValues(alpha: 0.25),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.start,
            style: theme.textTheme.labelMedium?.copyWith(
              color: isDark ? AppColors.goldLighter : Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: SuratListConstants.murajaahButtonFontSize,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            Icons.arrow_forward_ios_rounded,
            color: isDark ? AppColors.goldLighter : Colors.white,
            size: 10,
          ),
        ],
      ),
    );
  }
}
