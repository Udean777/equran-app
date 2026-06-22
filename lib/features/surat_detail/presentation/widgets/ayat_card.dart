import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/core/theme/cubit/quran_font_cubit.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/ayat_action_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AyatCard extends StatelessWidget {
  const AyatCard({
    required this.ayat,
    this.isBookmarked = false,
    this.isPlaying = false,
    this.isAudioLoading = false,
    this.hasCatatan = false,
    this.isDownloaded = false,
    this.isDownloading = false,
    this.downloadProgress = 0.0,
    this.onBookmarkToggle,
    this.onPlayTap,
    this.onShareTap,
    this.onCatatanTap,
    this.onDownloadTap,
    super.key,
  });

  final Ayat ayat;
  final bool isBookmarked;
  final bool isPlaying;
  final bool isAudioLoading;
  final bool hasCatatan;
  final bool isDownloaded;
  final bool isDownloading;
  final double downloadProgress;
  final VoidCallback? onBookmarkToggle;
  final VoidCallback? onPlayTap;
  final VoidCallback? onShareTap;
  final VoidCallback? onCatatanTap;
  final VoidCallback? onDownloadTap;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return BlocBuilder<QuranFontCubit, QuranFontState>(
      buildWhen: (prev, curr) =>
          prev.arabicFontSize != curr.arabicFontSize ||
          prev.translationFontSize != curr.translationFontSize ||
          prev.arabicFontFamily != curr.arabicFontFamily,
      builder: (context, fontState) {
        final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;
        final borderColor = isPlaying
            ? (isDark ? AppColors.primaryLighter : AppColors.primary)
            : (isDark ? AppColors.outlineDark : AppColors.outlineVariant);
        final borderWidth = isPlaying ? 1.5 : 1.0;

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.pagePadding,
            vertical: AppDimens.spaceXS,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(AppDimens.radiusLG),
              border: Border.all(color: borderColor, width: borderWidth),
              boxShadow: isPlaying
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header — nomor + actions
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppDimens.cardPaddingLG,
                    AppDimens.spaceMD,
                    AppDimens.spaceSM,
                    AppDimens.spaceXS,
                  ),
                  child: Row(
                    children: [
                      AyatNumberBadge(
                        nomor: ayat.nomorAyat,
                        hasCatatan: hasCatatan,
                        isDark: isDark,
                        isPlaying: isPlaying,
                      ),
                      const Spacer(),
                      AyatActionButtons(
                        isPlaying: isPlaying,
                        isAudioLoading: isAudioLoading,
                        isBookmarked: isBookmarked,
                        hasCatatan: hasCatatan,
                        isDownloaded: isDownloaded,
                        isDownloading: isDownloading,
                        downloadProgress: downloadProgress,
                        isDark: isDark,
                        onPlayTap: onPlayTap,
                        onBookmarkToggle: onBookmarkToggle,
                        onShareTap: onShareTap,
                        onCatatanTap: onCatatanTap,
                        onDownloadTap: onDownloadTap,
                      ),
                    ],
                  ),
                ),

                // Teks Arab
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppDimens.cardPaddingLG,
                    AppDimens.spaceMD,
                    AppDimens.cardPaddingLG,
                    AppDimens.spaceMD,
                  ),
                  child: Text(
                    ayat.teksArab,
                    textAlign: TextAlign.right,
                    style: AppTypography.arabicDynamic(fontState).copyWith(
                      color: isDark
                          ? AppColors.primaryLighter
                          : AppColors.primary,
                    ),
                  ),
                ),

                // Divider gold tipis
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.cardPaddingLG,
                  ),
                  child: Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.gold.withValues(alpha: 0),
                          AppColors.gold.withValues(alpha: 0.4),
                          AppColors.gold.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                ),

                // Teks Latin + Indonesia
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppDimens.cardPaddingLG,
                    AppDimens.spaceMD,
                    AppDimens.cardPaddingLG,
                    AppDimens.cardPaddingLG,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Latin
                      Text(
                        ayat.teksLatin,
                        style:
                            AppTypography.translationDynamic(
                              fontState,
                            ).copyWith(
                              fontStyle: FontStyle.italic,
                              color: isDark
                                  ? AppColors.onSurfaceDarkVariant
                                  : AppColors.textTertiary,
                            ),
                      ),
                      const SizedBox(height: AppDimens.spaceSM),
                      // Indonesia
                      Text(
                        ayat.teksIndonesia,
                        style:
                            AppTypography.translationDynamic(
                              fontState,
                            ).copyWith(
                              color: isDark
                                  ? AppColors.onSurfaceDark
                                  : AppColors.textSecondary,
                              height: 1.6,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
