import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:equran_app/features/surat_detail/presentation/pages/share_ayat_page.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/ayat_audio_footer.dart';
import 'package:flutter/material.dart';

/// Card per ayat — arab, latin, terjemah, nomor, audio, bookmark, share.
/// Ukuran adaptif: tidak memaksa full height, wrap konten.
class AyatSwipeCard extends StatelessWidget {
  const AyatSwipeCard({
    required this.ayat,
    required this.suratDetail,
    required this.isBookmarked,
    required this.onBookmarkToggle,
    super.key,
  });

  final Ayat ayat;
  final SuratDetail suratDetail;
  final bool isBookmarked;
  final VoidCallback onBookmarkToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;
    final borderColor = isDark
        ? AppColors.outlineDark
        : AppColors.outlineVariant;
    final textPrimary = isDark
        ? AppColors.onSurfaceDark
        : AppColors.textPrimary;
    final textSecondary = isDark
        ? AppColors.onSurfaceDarkVariant
        : AppColors.textSecondary;
    final textTertiary = isDark
        ? AppColors.onSurfaceDarkVariant
        : AppColors.textTertiary;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(AppDimens.radiusXL),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header — nomor ayat + share + bookmark
          _CardHeader(
            ayat: ayat,
            suratDetail: suratDetail,
            isBookmarked: isBookmarked,
            onBookmarkToggle: onBookmarkToggle,
            isDark: isDark,
            textTertiary: textTertiary,
          ),

          // Divider gold
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.spaceLG,
            ),
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    AppColors.gold.withValues(alpha: 0.4),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Content — scrollable if content exceeds constraints
          Flexible(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimens.spaceLG,
                  AppDimens.spaceMD,
                  AppDimens.spaceLG,
                  AppDimens.spaceMD,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Teks Arab
                    Text(
                      ayat.teksArab,
                      style: AppTypography.arabicLarge.copyWith(
                        color: isDark
                            ? AppColors.primaryLighter
                            : AppColors.primary,
                        fontSize: 28,
                        height: 2.2,
                      ),
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                    ),

                    const SizedBox(height: AppDimens.spaceMD),

                    Divider(color: borderColor, thickness: 1),

                    const SizedBox(height: AppDimens.spaceMD),

                    // Teks Latin
                    Text(
                      ayat.teksLatin,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: textSecondary,
                        fontStyle: FontStyle.italic,
                        height: 1.8,
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: AppDimens.spaceMD),

                    // Terjemahan
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppDimens.spaceMD),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.primaryDark.withValues(alpha: 0.3)
                            : AppColors.primaryContainer.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(AppDimens.radiusMD),
                        border: Border.all(
                          color: isDark
                              ? AppColors.primaryLight.withValues(alpha: 0.15)
                              : AppColors.primary.withValues(alpha: 0.1),
                        ),
                      ),
                      child: Text(
                        ayat.teksIndonesia,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: textPrimary,
                          height: 1.8,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Footer — audio button
          AyatAudioFooter(
            ayat: ayat,
            suratDetail: suratDetail,
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Header
// ---------------------------------------------------------------------------

class _CardHeader extends StatelessWidget {
  const _CardHeader({
    required this.ayat,
    required this.suratDetail,
    required this.isBookmarked,
    required this.onBookmarkToggle,
    required this.isDark,
    required this.textTertiary,
  });

  final Ayat ayat;
  final SuratDetail suratDetail;
  final bool isBookmarked;
  final VoidCallback onBookmarkToggle;
  final bool isDark;
  final Color textTertiary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.spaceLG,
        AppDimens.spaceMD,
        AppDimens.spaceXS,
        AppDimens.spaceSM,
      ),
      child: Row(
        children: [
          // Nomor badge
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.primaryDark
                  : AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(AppDimens.radiusSM),
              border: Border.all(
                color: isDark
                    ? AppColors.primaryLight.withValues(alpha: 0.3)
                    : AppColors.primary.withValues(alpha: 0.2),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              '${ayat.nomorAyat}',
              style: TextStyle(
                color: isDark ? AppColors.primaryLighter : AppColors.primary,
                fontWeight: FontWeight.w700,
                fontSize: ayat.nomorAyat > 99 ? 10 : 12,
              ),
            ),
          ),

          const SizedBox(width: AppDimens.spaceSM),

          // Label
          Expanded(
            child: Text(
              'Ayat ${ayat.nomorAyat} / ${suratDetail.info.jumlahAyat}',
              style: theme.textTheme.labelSmall?.copyWith(
                color: textTertiary,
                fontSize: 11,
                letterSpacing: 0.3,
              ),
            ),
          ),

          // Share button
          IconButton(
            icon: Icon(
              Icons.share_outlined,
              color: textTertiary,
              size: AppDimens.iconMD,
            ),
            onPressed: () => _showSharePage(context),
            tooltip: 'Bagikan ayat',
            padding: const EdgeInsets.all(AppDimens.spaceXS),
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),

          // Bookmark button
          IconButton(
            icon: Icon(
              isBookmarked
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_outline_rounded,
              color: isBookmarked ? AppColors.gold : textTertiary,
              size: AppDimens.iconMD,
            ),
            onPressed: onBookmarkToggle,
            tooltip: isBookmarked ? 'Hapus bookmark' : 'Bookmark ayat',
            padding: const EdgeInsets.all(AppDimens.spaceXS),
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
        ],
      ),
    );
  }

  void _showSharePage(BuildContext context) {
    unawaited(
      Navigator.push<void>(
        context,
        MaterialPageRoute(
          builder: (_) => ShareAyatPage(
            ayat: ayat,
            namaLatin: suratDetail.info.namaLatin,
            suratNomor: suratDetail.info.nomor,
          ),
        ),
      ),
    );
  }
}
