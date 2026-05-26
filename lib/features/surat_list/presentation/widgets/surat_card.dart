import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
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

  /// Progress membaca surat ini (0.0–1.0).
  final double? scrollPercent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;
    final borderColor =
        isDark ? AppColors.outlineDark : AppColors.outlineVariant;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.spaceSM),
      child: Material(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimens.radiusLG),
          splashColor: AppColors.primaryContainer.withValues(alpha: 0.5),
          highlightColor: AppColors.primaryContainer.withValues(alpha: 0.3),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimens.radiusLG),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.cardPaddingLG,
                    vertical: AppDimens.cardPadding,
                  ),
                  child: Row(
                    children: [
                      // Nomor badge — diamond shape luxury
                      _NomorBadge(nomor: surat.nomor, isDark: isDark),
                      const SizedBox(width: AppDimens.spaceMD),

                      // Info tengah
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              surat.namaLatin,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? AppColors.onSurfaceDark
                                    : AppColors.textPrimary,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Row(
                              children: [
                                Text(
                                  l10n.ayatCount(surat.jumlahAyat),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: isDark
                                        ? AppColors.onSurfaceDarkVariant
                                        : AppColors.textTertiary,
                                    fontSize: 11,
                                  ),
                                ),
                                const SizedBox(width: AppDimens.spaceXS),
                                _TempatTurunBadge(
                                  tempatTurun: surat.tempatTurun,
                                  l10n: l10n,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Kanan — arabic + play
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            surat.nama,
                            style: TextStyle(
                              fontFamily: 'Amiri',
                              fontSize: 22,
                              color: isDark
                                  ? AppColors.primaryLighter
                                  : AppColors.primary,
                              height: 1.4,
                            ),
                          ),
                          if (onPlayTap != null) ...[
                            const SizedBox(height: 4),
                            GestureDetector(
                              onTap: onPlayTap,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppDimens.spaceSM,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.primaryDark
                                      : AppColors.primaryContainer,
                                  borderRadius: BorderRadius.circular(
                                    AppDimens.radiusFull,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.play_arrow_rounded,
                                      size: 12,
                                      color: isDark
                                          ? AppColors.primaryLighter
                                          : AppColors.primary,
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      'Play',
                                      style: TextStyle(
                                        color: isDark
                                            ? AppColors.primaryLighter
                                            : AppColors.primary,
                                        fontSize: 10,
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
                ),

                // Progress bar — hanya tampil jika scrollPercent != null
                if (scrollPercent != null)
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(AppDimens.radiusLG),
                      bottomRight: Radius.circular(AppDimens.radiusLG),
                    ),
                    child: LinearProgressIndicator(
                      value: scrollPercent,
                      minHeight: 3,
                      backgroundColor: isDark
                          ? AppColors.primaryDark
                          : AppColors.primaryContainer,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isDark ? AppColors.primaryLighter : AppColors.primary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Nomor badge — luxury diamond/octagon style
// ---------------------------------------------------------------------------

class _NomorBadge extends StatelessWidget {
  const _NomorBadge({required this.nomor, required this.isDark});

  final int nomor;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
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
          fontSize: nomor > 99 ? 10 : 12,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tempat turun badge
// ---------------------------------------------------------------------------

class _TempatTurunBadge extends StatelessWidget {
  const _TempatTurunBadge({
    required this.tempatTurun,
    required this.l10n,
  });

  final TempatTurun tempatTurun;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final isMekah = tempatTurun == TempatTurun.mekah;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceSM,
        vertical: 2,
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
          fontSize: 9,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
