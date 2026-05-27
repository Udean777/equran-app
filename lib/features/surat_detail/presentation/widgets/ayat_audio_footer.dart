import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/audio/domain/entities/audio_state_entity.dart';
import 'package:equran_app/features/audio/presentation/cubit/audio_cubit.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Footer audio untuk AyatSwipeCard.
class AyatAudioFooter extends StatelessWidget {
  const AyatAudioFooter({
    required this.ayat,
    required this.suratDetail,
    required this.isDark,
    super.key,
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
                  AyatAudioButton(
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
                      // Single ayat mode — tidak playlist
                      unawaited(
                        cubit.playOrToggle(
                          url: audioUrl,
                          ayatNomor: ayat.nomorAyat,
                          qari: qari,
                          suratNomor: suratDetail.info.nomor,
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

/// Tombol play/pause audio berbentuk pill.
class AyatAudioButton extends StatelessWidget {
  const AyatAudioButton({
    required this.isPlaying,
    required this.isLoading,
    required this.primaryColor,
    required this.isDark,
    required this.onTap,
    super.key,
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
