import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/core/theme/cubit/quran_font_cubit.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<QuranFontCubit, QuranFontState>(
      buildWhen: (prev, curr) =>
          prev.arabicFontSize != curr.arabicFontSize ||
          prev.translationFontSize != curr.translationFontSize ||
          prev.arabicFontFamily != curr.arabicFontFamily,
      builder: (context, fontState) {
        final surfaceColor =
            isDark ? AppColors.surfaceDark : AppColors.surface;
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
                      _AyatNumberBadge(
                        nomor: ayat.nomorAyat,
                        hasCatatan: hasCatatan,
                        isDark: isDark,
                        isPlaying: isPlaying,
                      ),
                      const Spacer(),
                      _ActionButtons(
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
                        style: AppTypography.translationDynamic(
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
                        style: AppTypography.translationDynamic(
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

// ---------------------------------------------------------------------------
// Nomor badge
// ---------------------------------------------------------------------------

class _AyatNumberBadge extends StatelessWidget {
  const _AyatNumberBadge({
    required this.nomor,
    required this.hasCatatan,
    required this.isDark,
    required this.isPlaying,
  });

  final int nomor;
  final bool hasCatatan;
  final bool isDark;
  final bool isPlaying;

  @override
  Widget build(BuildContext context) {
    final bgColor = isPlaying
        ? (isDark ? AppColors.primaryLight : AppColors.primary)
        : (isDark ? AppColors.primaryDark : AppColors.primaryContainer);
    final textColor = isPlaying
        ? AppColors.onPrimary
        : (isDark ? AppColors.primaryLighter : AppColors.primary);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: isPlaying
                  ? Colors.transparent
                  : (isDark
                      ? AppColors.primaryLight.withValues(alpha: 0.3)
                      : AppColors.primary.withValues(alpha: 0.2)),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            nomor.toString(),
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w700,
              fontSize: nomor > 99 ? 10 : 12,
            ),
          ),
        ),
        if (hasCatatan)
          Positioned(
            top: -2,
            right: -2,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: AppColors.gold,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark
                      ? AppColors.surfaceDark
                      : AppColors.surface,
                  width: 1.5,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Action buttons row
// ---------------------------------------------------------------------------

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    required this.isPlaying,
    required this.isAudioLoading,
    required this.isBookmarked,
    required this.hasCatatan,
    required this.isDownloaded,
    required this.isDownloading,
    required this.downloadProgress,
    required this.isDark,
    required this.onPlayTap,
    required this.onBookmarkToggle,
    required this.onShareTap,
    required this.onCatatanTap,
    required this.onDownloadTap,
  });

  final bool isPlaying;
  final bool isAudioLoading;
  final bool isBookmarked;
  final bool hasCatatan;
  final bool isDownloaded;
  final bool isDownloading;
  final double downloadProgress;
  final bool isDark;
  final VoidCallback? onPlayTap;
  final VoidCallback? onBookmarkToggle;
  final VoidCallback? onShareTap;
  final VoidCallback? onCatatanTap;
  final VoidCallback? onDownloadTap;

  Color get _iconColor =>
      isDark ? AppColors.onSurfaceDarkVariant : AppColors.textTertiary;

  Color get _activeColor =>
      isDark ? AppColors.primaryLighter : AppColors.primary;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Play
        if (onPlayTap != null)
          isAudioLoading
              ? SizedBox(
                  width: 32,
                  height: 32,
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: _activeColor,
                    ),
                  ),
                )
              : _ActionBtn(
                  icon: isPlaying
                      ? Icons.pause_circle_outline_rounded
                      : Icons.play_circle_outline_rounded,
                  color: isPlaying ? _activeColor : _iconColor,
                  onTap: onPlayTap,
                ),

        // Bookmark
        if (onBookmarkToggle != null)
          _ActionBtn(
            icon: isBookmarked
                ? Icons.bookmark_rounded
                : Icons.bookmark_border_rounded,
            color: isBookmarked ? AppColors.gold : _iconColor,
            onTap: onBookmarkToggle,
          ),

        // Share
        if (onShareTap != null)
          _ActionBtn(
            icon: Icons.share_rounded,
            color: _iconColor,
            onTap: onShareTap,
          ),

        // Catatan
        if (onCatatanTap != null)
          _ActionBtn(
            icon: Icons.edit_note_rounded,
            color: hasCatatan ? AppColors.gold : _iconColor,
            onTap: onCatatanTap,
          ),

        // Download
        if (onDownloadTap != null)
          isDownloading
              ? SizedBox(
                  width: 32,
                  height: 32,
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      value: downloadProgress > 0 ? downloadProgress : null,
                      color: _activeColor,
                    ),
                  ),
                )
              : _ActionBtn(
                  icon: isDownloaded
                      ? Icons.download_done_rounded
                      : Icons.download_outlined,
                  color: isDownloaded ? AppColors.success : _iconColor,
                  onTap: isDownloaded ? null : onDownloadTap,
                ),
      ],
    );
  }
}

class _ActionBtn extends StatelessWidget {
  const _ActionBtn({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: color, size: AppDimens.iconMD),
      onPressed: onTap,
      padding: const EdgeInsets.all(AppDimens.spaceXS),
      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
    );
  }
}
