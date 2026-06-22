import 'package:equran_app/core/router/app_routes.dart';
import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/features/bookmark/domain/entities/last_read.dart';
import 'package:equran_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LastReadCard extends StatelessWidget {
  const LastReadCard({required this.lastRead, super.key});
  final LastRead lastRead;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.pagePadding,
        AppDimens.spaceMD,
        AppDimens.pagePadding,
        AppDimens.spaceXS,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppDimens.radiusXL),
        child: InkWell(
          onTap: () => context.push(
            AppRoutes.suratWithAyat(lastRead.suratNomor, lastRead.ayatNomor),
          ),
          borderRadius: BorderRadius.circular(AppDimens.radiusXL),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [AppColors.primaryDark, AppColors.primary]
                    : [AppColors.primary, AppColors.primaryLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppDimens.radiusXL),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(
                    alpha: isDark ? 0.2 : 0.3,
                  ),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Stack(
              children: [
                const _DecorativeCircles(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _CardHeader(lastRead: lastRead, l10n: l10n),
                    if (lastRead.totalAyat > 0)
                      _ProgressSection(lastRead: lastRead)
                    else
                      const SizedBox(height: AppDimens.spaceMD),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DecorativeCircles extends StatelessWidget {
  const _DecorativeCircles();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: -12,
          top: -12,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.onPrimary.withValues(alpha: 0.05),
            ),
          ),
        ),
        Positioned(
          right: 20,
          top: -20,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.onPrimary.withValues(alpha: 0.04),
            ),
          ),
        ),
      ],
    );
  }
}

class _CardHeader extends StatelessWidget {
  const _CardHeader({required this.lastRead, required this.l10n});
  final LastRead lastRead;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.cardPaddingLG,
        AppDimens.cardPaddingLG,
        AppDimens.cardPaddingLG,
        AppDimens.spaceMD,
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.onPrimary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppDimens.radiusMD),
              border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
            ),
            child: const Icon(
              Icons.menu_book_rounded,
              color: AppColors.onPrimary,
              size: AppDimens.iconMD,
            ),
          ),
          const SizedBox(width: AppDimens.spaceMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.continueReading,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.onPrimary.withValues(alpha: 0.7),
                    letterSpacing: 0.5,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  lastRead.namaLatin,
                  style: AppTypography.serifHeadingSmall.copyWith(
                    color: AppColors.onPrimary,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  lastRead.totalAyat > 0
                      ? l10n.ayatFrom(lastRead.ayatNomor, lastRead.totalAyat)
                      : l10n.ayat(lastRead.ayatNomor),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.onPrimary.withValues(alpha: 0.75),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.onPrimary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_forward_rounded,
              color: AppColors.onPrimary,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressSection extends StatelessWidget {
  const _ProgressSection({required this.lastRead});
  final LastRead lastRead;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.cardPaddingLG,
        0,
        AppDimens.cardPaddingLG,
        AppDimens.spaceSM,
      ),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppDimens.radiusFull),
              child: LinearProgressIndicator(
                value: lastRead.maxScrollPercent,
                minHeight: 3,
                backgroundColor: AppColors.onPrimary.withValues(alpha: 0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
              ),
            ),
          ),
          const SizedBox(width: AppDimens.spaceSM),
          Text(
            '${(lastRead.maxScrollPercent * 100).round()}%',
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppColors.onPrimary.withValues(alpha: 0.7),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
