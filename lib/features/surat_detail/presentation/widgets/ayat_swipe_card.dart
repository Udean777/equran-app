import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/core/utils/bottom_sheet_utils.dart';
import 'package:equran_app/features/audio/domain/entities/audio_state_entity.dart';
import 'package:equran_app/features/audio/presentation/cubit/audio_cubit.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/share_ayat_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    final borderColor =
        isDark ? AppColors.outlineDark : AppColors.outlineVariant;
    final textPrimary =
        isDark ? AppColors.onSurfaceDark : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.onSurfaceDarkVariant : AppColors.textSecondary;
    final textTertiary =
        isDark ? AppColors.onSurfaceDarkVariant : AppColors.textTertiary;

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
      // IntrinsicHeight agar card wrap konten, tidak paksa full height
      child: IntrinsicHeight(
        child: Column(
          mainAxisSize: MainAxisSize.min,
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

            // Content — tidak pakai Expanded, biar wrap
            Padding(
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
                      borderRadius:
                          BorderRadius.circular(AppDimens.radiusMD),
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

            // Footer — audio button
            _CardFooter(
              ayat: ayat,
              suratDetail: suratDetail,
              isDark: isDark,
            ),
          ],
        ),
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
            onPressed: () => _showShareSheet(context),
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

  void _showShareSheet(BuildContext context) {
    unawaited(
      showAppBottomSheet<void>(
        context,
        builder: (_) => ShareAyatSheet(
          ayat: ayat,
          namaLatin: suratDetail.info.namaLatin,
          suratNomor: suratDetail.info.nomor,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Footer — audio
// ---------------------------------------------------------------------------

class _CardFooter extends StatelessWidget {
  const _CardFooter({
    required this.ayat,
    required this.suratDetail,
    required this.isDark,
  });

  final Ayat ayat;
  final SuratDetail suratDetail;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final borderColor =
        isDark ? AppColors.outlineDark : AppColors.outlineVariant;
    final primaryColor =
        isDark ? AppColors.primaryLighter : AppColors.primary;

    return BlocBuilder<AudioCubit, AudioPlayerState>(
      buildWhen: (prev, next) =>
          prev.currentAyat != next.currentAyat ||
          prev.isPlaying != next.isPlaying ||
          prev.isLoading != next.isLoading ||
          prev.isPaused != next.isPaused ||
          prev.currentQari != next.currentQari,
      builder: (context, audioState) {
        final cubit = context.read<AudioCubit>();
        final qari = audioState.currentQari;
        final audioUrl =
            ayat.audio[qari.id] ?? ayat.audio.values.firstOrNull;
        final isCurrentAyat = audioState.currentAyat == ayat.nomorAyat;
        final isPlaying = isCurrentAyat && audioState.isPlaying;
        final isLoading = isCurrentAyat && audioState.isLoading;

        return Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: borderColor)),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(AppDimens.radiusXL),
              bottomRight: Radius.circular(AppDimens.radiusXL),
            ),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.spaceLG,
            vertical: AppDimens.spaceSM,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (audioUrl == null)
                Text(
                  'Audio tidak tersedia',
                  style: TextStyle(
                    color: isDark
                        ? AppColors.onSurfaceDarkVariant
                        : AppColors.textTertiary,
                    fontSize: 12,
                  ),
                )
              else
                _AudioButton(
                  isPlaying: isPlaying,
                  isLoading: isLoading,
                  primaryColor: primaryColor,
                  isDark: isDark,
                  onTap: () {
                    if (isCurrentAyat) {
                      if (isPlaying) {
                        unawaited(cubit.pause());
                      } else {
                        unawaited(cubit.resume());
                      }
                    } else {
                      unawaited(
                        cubit.playFullSurat(
                          ayatList: suratDetail.ayatList,
                          startIndex: ayat.nomorAyat - 1,
                          qari: qari,
                          suratNomor: suratDetail.info.nomor,
                          suratName: suratDetail.info.namaLatin,
                          audioMap: suratDetail.audioFull,
                        ),
                      );
                    }
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

class _AudioButton extends StatelessWidget {
  const _AudioButton({
    required this.isPlaying,
    required this.isLoading,
    required this.primaryColor,
    required this.isDark,
    required this.onTap,
  });

  final bool isPlaying;
  final bool isLoading;
  final Color primaryColor;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spaceMD,
          vertical: AppDimens.spaceXS + 2,
        ),
        decoration: BoxDecoration(
          color: isDark ? AppColors.primaryDark : AppColors.primaryContainer,
          borderRadius: BorderRadius.circular(AppDimens.radiusFull),
          border: Border.all(color: primaryColor.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLoading)
              SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: primaryColor,
                ),
              )
            else
              Icon(
                isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                color: primaryColor,
                size: 18,
              ),
            const SizedBox(width: AppDimens.spaceXS),
            Text(
              isPlaying ? 'Pause' : 'Play Ayat',
              style: TextStyle(
                color: primaryColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
