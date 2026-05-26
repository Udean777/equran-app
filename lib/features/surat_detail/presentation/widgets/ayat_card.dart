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
    this.onBookmarkToggle,
    this.onPlayTap,
    this.onShareTap,
    super.key,
  });

  final Ayat ayat;
  final bool isBookmarked;
  final bool isPlaying;
  final bool isAudioLoading;
  final VoidCallback? onBookmarkToggle;
  final VoidCallback? onPlayTap;
  final VoidCallback? onShareTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuranFontCubit, QuranFontState>(
      builder: (context, fontState) => Card(
        margin: const EdgeInsets.symmetric(
          horizontal: AppDimens.spaceMD,
          vertical: AppDimens.spaceXS,
        ),
        // Highlight ayat yang sedang diplay
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMD),
          side: isPlaying
              ? const BorderSide(color: AppColors.primary, width: 1.5)
              : const BorderSide(color: AppColors.outline),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Nomor ayat + action buttons
              Row(
                children: [
                  _AyatNumberBadge(nomor: ayat.nomorAyat),
                  const Spacer(),
                  // Play button
                  if (onPlayTap != null)
                    isAudioLoading
                        ? const SizedBox(
                            width: 32,
                            height: 32,
                            child: Padding(
                              padding: EdgeInsets.all(6),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primary,
                              ),
                            ),
                          )
                        : IconButton(
                            icon: Icon(
                              isPlaying
                                  ? Icons.pause_circle_outline_rounded
                                  : Icons.play_circle_outline_rounded,
                              color: isPlaying
                                  ? AppColors.primary
                                  : Colors.grey[400],
                            ),
                            onPressed: onPlayTap,
                            tooltip: isPlaying ? 'Pause' : 'Play',
                          ),
                  // Bookmark button
                  if (onBookmarkToggle != null)
                    IconButton(
                      icon: Icon(
                        isBookmarked
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_border_rounded,
                        color: isBookmarked
                            ? AppColors.secondary
                            : Colors.grey[400],
                      ),
                      onPressed: onBookmarkToggle,
                      tooltip: isBookmarked
                          ? 'Hapus Bookmark'
                          : 'Tambah Bookmark',
                    ),
                  // Share button
                  if (onShareTap != null)
                    IconButton(
                      icon: Icon(
                        Icons.share_rounded,
                        color: Colors.grey[400],
                      ),
                      onPressed: onShareTap,
                      tooltip: 'Bagikan Ayat',
                    ),
                ],
              ),
              const SizedBox(height: AppDimens.spaceMD),
              // Teks Arab
              Text(
                ayat.teksArab,
                textAlign: TextAlign.right,
                style: AppTypography.arabicDynamic(fontState).copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppDimens.spaceMD),
              const Divider(),
              const SizedBox(height: AppDimens.spaceSM),
              // Teks Latin
              Text(
                ayat.teksLatin,
                style: AppTypography.translationDynamic(fontState).copyWith(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: AppDimens.spaceSM),
              // Teks Indonesia
              Text(
                ayat.teksIndonesia,
                style: AppTypography.translationDynamic(fontState),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AyatNumberBadge extends StatelessWidget {
  const _AyatNumberBadge({required this.nomor});

  final int nomor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: const BoxDecoration(
        color: AppColors.ayatNumberBg,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        nomor.toString(),
        style: const TextStyle(
          color: AppColors.ayatNumberText,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
