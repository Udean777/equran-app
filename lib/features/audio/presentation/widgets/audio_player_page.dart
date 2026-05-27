import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/utils/bottom_sheet_utils.dart';
import 'package:equran_app/features/audio/domain/entities/audio_state_entity.dart';
import 'package:equran_app/features/audio/presentation/cubit/audio_cubit.dart';
import 'package:equran_app/features/audio/presentation/widgets/audio_control_buttons.dart';
import 'package:equran_app/features/audio/presentation/widgets/audio_progress_bar.dart';
import 'package:equran_app/features/audio/presentation/widgets/qari_selector_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Full player page ala Spotify — dibuka via slide-up transition dari AudioPlayerBar.
class AudioPlayerPage extends StatelessWidget {
  const AudioPlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AudioCubit, AudioPlayerState>(
      listenWhen: (prev, curr) => !prev.isIdle && curr.isIdle,
      listener: (context, state) {
        // Hanya pop jika audio benar-benar dihentikan (bukan transisi antar ayat).
        // Saat ganti ayat di playlist, state sebentar isIdle sebelum loading —
        // cek isPlaylistMode untuk memastikan ini bukan transisi antar ayat.
        final cubit = context.read<AudioCubit>();
        if (!cubit.isPlaylistMode && Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      },
      buildWhen: (prev, curr) =>
          prev.currentAyat != curr.currentAyat ||
          prev.isPlaying != curr.isPlaying ||
          prev.isPaused != curr.isPaused ||
          prev.isLoading != curr.isLoading ||
          prev.currentQari != curr.currentQari,
      builder: (context, state) {
        if (state.isIdle) return const SizedBox.shrink();

        final cubit = context.read<AudioCubit>();
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final effectiveAudioMap = cubit.lastAudioMap;

        return _AudioPlayerPageContent(
          state: state,
          cubit: cubit,
          isDark: isDark,
          effectiveAudioMap: effectiveAudioMap,
        );
      },
    );
  }
}

class _AudioPlayerPageContent extends StatelessWidget {
  const _AudioPlayerPageContent({
    required this.state,
    required this.cubit,
    required this.isDark,
    required this.effectiveAudioMap,
  });

  final AudioPlayerState state;
  final AudioCubit cubit;
  final bool isDark;
  final Map<String, String> effectiveAudioMap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = isDark ? AppColors.primaryLighter : AppColors.primary;
    final bgColor =
        isDark ? AppColors.backgroundDark : AppColors.background;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final artworkSize = (screenWidth * 0.72).clamp(0.0, 300.0);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header — chevron down
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimens.spaceSM,
                AppDimens.spaceSM,
                AppDimens.spaceSM,
                0,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: isDark
                          ? AppColors.onSurfaceDark
                          : AppColors.textPrimary,
                      size: 32,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: 'Tutup',
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Artwork
            Container(
              width: artworkSize,
              height: artworkSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppDimens.radiusLG),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: isDark ? 0.4 : 0.15,
                    ),
                    blurRadius: 32,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                'assets/icons/app_icon.png',
                fit: BoxFit.cover,
              ),
            ),

            const Spacer(),

            // Info — nama surat + ayat badge + qari
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.pagePadding,
              ),
              child: Row(
                children: [
                  // Nama surat + qari
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (cubit.isPlaylistMode &&
                            cubit.playlistSuratName != null)
                          Text(
                            cubit.playlistSuratName!,
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: isDark
                                  ? AppColors.onSurfaceDark
                                  : AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        const SizedBox(height: AppDimens.spaceXS),
                        // Qari selector
                        GestureDetector(
                          onTap: () => _showQariSelector(context, state),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  state.currentQari.name,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: isDark
                                        ? AppColors.onSurfaceDarkVariant
                                        : AppColors.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Icon(
                                Icons.arrow_drop_down_rounded,
                                color: isDark
                                    ? AppColors.onSurfaceDarkVariant
                                    : AppColors.textTertiary,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Ayat badge
                  if (state.currentAyat != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimens.spaceMD,
                        vertical: AppDimens.spaceXS,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.primaryDark
                            : AppColors.primaryContainer,
                        borderRadius:
                            BorderRadius.circular(AppDimens.radiusFull),
                      ),
                      child: Text(
                        'Ayat ${state.currentAyat}',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: AppDimens.spaceMD),

            // Progress bar dengan label waktu
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.spaceSM,
              ),
              child: AudioProgressBar(isDark: isDark),
            ),

            const SizedBox(height: AppDimens.spaceMD),

            // Control buttons — lebih besar dari mini bar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.pagePadding,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (cubit.isPlaylistMode)
                    AudioIconBtn(
                      icon: Icons.skip_previous_rounded,
                      iconSize: 28,
                      buttonSize: 48,
                      color: cubit.playlistIndex > 0
                          ? primaryColor
                          : (isDark
                                ? AppColors.outlineDark
                                : AppColors.textDisabled),
                      onPressed: cubit.playlistIndex > 0
                          ? () => unawaited(cubit.previousAyat())
                          : null,
                    ),

                  AudioIconBtn(
                    icon: Icons.stop_rounded,
                    iconSize: 28,
                    buttonSize: 48,
                    color: isDark
                        ? AppColors.onSurfaceDarkVariant
                        : AppColors.textSecondary,
                    onPressed: () => unawaited(cubit.stop()),
                  ),

                  AudioPlayPauseButton(
                    state: state,
                    isDark: isDark,
                    size: 56,
                    iconSize: 28,
                    showLoadingIndicator: true,
                  ),

                  if (cubit.isPlaylistMode)
                    AudioIconBtn(
                      icon: Icons.skip_next_rounded,
                      iconSize: 28,
                      buttonSize: 48,
                      color: cubit.playlistIndex < cubit.playlist.length - 1
                          ? primaryColor
                          : (isDark
                                ? AppColors.outlineDark
                                : AppColors.textDisabled),
                      onPressed:
                          cubit.playlistIndex < cubit.playlist.length - 1
                              ? () => unawaited(cubit.nextAyat())
                              : null,
                    ),
                ],
              ),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }

  void _showQariSelector(BuildContext context, AudioPlayerState state) {
    unawaited(
      showAppBottomSheet<void>(
        context,
        builder: (_) => QariSelectorSheet(
          selectedQari: state.currentQari,
          audioMap: effectiveAudioMap,
          onQariSelected: (qari) {
            unawaited(
              context.read<AudioCubit>().changeQari(
                qari: qari,
                audioMap: effectiveAudioMap,
              ),
            );
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
