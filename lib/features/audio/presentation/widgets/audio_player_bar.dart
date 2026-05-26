import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/utils/bottom_sheet_utils.dart';
import 'package:equran_app/features/audio/domain/entities/audio_state_entity.dart';
import 'package:equran_app/features/audio/presentation/cubit/audio_cubit.dart';
import 'package:equran_app/features/audio/presentation/widgets/qari_selector_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AudioPlayerBar extends StatelessWidget {
  const AudioPlayerBar({
    this.audioMap = const {},
    super.key,
  });

  /// Map qari id → audio URL dari response API.
  /// Jika kosong, fallback ke [AudioCubit.lastAudioMap].
  final Map<String, String> audioMap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioCubit, AudioPlayerState>(
      // Hanya rebuild jika idle/aktif berubah, ayat berubah, atau qari berubah
      // Position update (~200ms) tidak trigger rebuild di sini
      buildWhen: (prev, curr) =>
          prev.isIdle != curr.isIdle ||
          prev.currentAyat != curr.currentAyat ||
          prev.currentQari != curr.currentQari ||
          prev.isPlaying != curr.isPlaying ||
          prev.isPaused != curr.isPaused ||
          prev.isLoading != curr.isLoading,
      builder: (context, state) {
        if (state.isIdle) return const SizedBox.shrink();

        final cubit = context.read<AudioCubit>();
        final effectiveAudioMap =
            audioMap.isNotEmpty ? audioMap : cubit.lastAudioMap;
        final isPlaylist = cubit.isPlaylistMode;
        final suratName = cubit.playlistSuratName;

        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(
            AppDimens.spaceMD,
            AppDimens.spaceSM,
            AppDimens.spaceMD,
            AppDimens.spaceMD,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Surat name (playlist mode only)
              if (isPlaylist && suratName != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppDimens.spaceXS),
                  child: Text(
                    suratName,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

              // Qari + Ayat info
              Row(
                children: [
                  // Qari selector
                  GestureDetector(
                    onTap: () => _showQariSelector(context, state, effectiveAudioMap),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          state.currentQari.name,
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const Icon(
                          Icons.arrow_drop_down_rounded,
                          color: AppColors.primary,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Ayat info
                  if (state.currentAyat != null)
                    Text(
                      'Ayat ${state.currentAyat}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppDimens.spaceXS),

              // Progress bar — punya BlocBuilder sendiri, hanya rebuild saat position update
              const _ProgressBar(),

              // Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Previous (playlist mode only)
                  if (isPlaylist)
                    IconButton(
                      icon: const Icon(Icons.skip_previous_rounded),
                      color: cubit.playlistIndex > 0
                          ? AppColors.primary
                          : Colors.grey[400],
                      onPressed: cubit.playlistIndex > 0
                          ? () => unawaited(cubit.previousAyat())
                          : null,
                      tooltip: 'Ayat sebelumnya',
                    ),

                  // Stop
                  IconButton(
                    icon: const Icon(Icons.stop_rounded),
                    color: Colors.grey[600],
                    onPressed: () => unawaited(cubit.stop()),
                    tooltip: 'Stop',
                  ),

                  // Play/Pause
                  _PlayPauseButton(state: state),

                  // Next (playlist mode only)
                  if (isPlaylist)
                    IconButton(
                      icon: const Icon(Icons.skip_next_rounded),
                      color: cubit.playlistIndex < cubit.playlist.length - 1
                          ? AppColors.primary
                          : Colors.grey[400],
                      onPressed: cubit.playlistIndex < cubit.playlist.length - 1
                          ? () => unawaited(cubit.nextAyat())
                          : null,
                      tooltip: 'Ayat berikutnya',
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showQariSelector(
    BuildContext context,
    AudioPlayerState state,
    Map<String, String> audioMap,
  ) {
    unawaited(
      showAppBottomSheet<void>(
        context,
        builder: (_) => QariSelectorSheet(
          selectedQari: state.currentQari,
          audioMap: audioMap,
          onQariSelected: (qari) {
            unawaited(
              context.read<AudioCubit>().changeQari(
                qari: qari,
                audioMap: audioMap,
              ),
            );
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar();

  @override
  Widget build(BuildContext context) {
    // BlocBuilder sendiri untuk position — hanya bagian ini rebuild setiap ~200ms
    return BlocBuilder<AudioCubit, AudioPlayerState>(
      buildWhen: (prev, curr) =>
          prev.position != curr.position ||
          prev.duration != curr.duration,
      builder: (context, posState) {
        final position = posState.position;
        final duration = posState.duration;
        final progress = duration.inMilliseconds > 0
            ? position.inMilliseconds / duration.inMilliseconds
            : 0.0;

        return Column(
          children: [
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 3,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                overlayShape:
                    const RoundSliderOverlayShape(overlayRadius: 12),
                activeTrackColor: AppColors.primary,
                inactiveTrackColor: AppColors.primary.withValues(alpha: 0.2),
                thumbColor: AppColors.primary,
              ),
              child: Slider(
                value: progress.clamp(0.0, 1.0),
                onChanged: (value) {
                  final seekTo = Duration(
                    milliseconds: (value * duration.inMilliseconds).round(),
                  );
                  unawaited(context.read<AudioCubit>().seek(seekTo));
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppDimens.spaceSM),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDuration(position),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.grey[500],
                    ),
                  ),
                  Text(
                    _formatDuration(duration),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

class _PlayPauseButton extends StatelessWidget {
  const _PlayPauseButton({required this.state});

  final AudioPlayerState state;

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return const SizedBox(
        width: 48,
        height: 48,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primary,
          ),
        ),
      );
    }

    return IconButton(
      icon: Icon(
        state.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
      ),
      color: AppColors.primary,
      iconSize: 32,
      onPressed: () {
        final cubit = context.read<AudioCubit>();
        if (state.isPlaying) {
          unawaited(cubit.pause());
        } else if (state.isPaused) {
          unawaited(cubit.resume());
        }
      },
    );
  }
}
