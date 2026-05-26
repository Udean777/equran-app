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
        final effectiveAudioMap = audioMap.isNotEmpty
            ? audioMap
            : cubit.lastAudioMap;
        final isPlaylist = cubit.isPlaylistMode;
        final suratName = cubit.playlistSuratName;
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return _AudioPlayerBarContent(
          state: state,
          cubit: cubit,
          effectiveAudioMap: effectiveAudioMap,
          isPlaylist: isPlaylist,
          suratName: suratName,
          isDark: isDark,
        );
      },
    );
  }

}

class _AudioPlayerBarContent extends StatelessWidget {
  const _AudioPlayerBarContent({
    required this.state,
    required this.cubit,
    required this.effectiveAudioMap,
    required this.isPlaylist,
    required this.suratName,
    required this.isDark,
  });

  final AudioPlayerState state;
  final AudioCubit cubit;
  final Map<String, String> effectiveAudioMap;
  final bool isPlaylist;
  final String? suratName;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;
    final primaryColor = isDark ? AppColors.primaryLighter : AppColors.primary;

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.outlineDark : AppColors.outlineVariant,
          ),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppDimens.pagePadding,
        AppDimens.spaceSM,
        AppDimens.spaceSM,
        AppDimens.spaceSM,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top row — info + controls
          Row(
            children: [
              // Left: icon + info
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.primaryDark
                      : AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(AppDimens.radiusSM),
                ),
                child: Icon(
                  Icons.music_note_rounded,
                  color: primaryColor,
                  size: AppDimens.iconSM + 2,
                ),
              ),
              const SizedBox(width: AppDimens.spaceSM + 2),

              // Info — surat name + qari
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isPlaylist && suratName != null)
                      Text(
                        suratName!,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    // Qari selector
                    GestureDetector(
                      onTap: () => _showQariSelector(
                        context,
                        state,
                        effectiveAudioMap,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              state.currentQari.name,
                              style: theme.textTheme.labelSmall?.copyWith(
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
                            size: 16,
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
                    horizontal: AppDimens.spaceSM,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.primaryDark
                        : AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                  ),
                  child: Text(
                    'Ayat ${state.currentAyat}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                    ),
                  ),
                ),

              const SizedBox(width: AppDimens.spaceXS),

              // Controls
              if (isPlaylist)
                _IconBtn(
                  icon: Icons.skip_previous_rounded,
                  color: cubit.playlistIndex > 0
                      ? primaryColor
                      : (isDark
                            ? AppColors.outlineDark
                            : AppColors.textDisabled),
                  onPressed: cubit.playlistIndex > 0
                      ? () => unawaited(cubit.previousAyat())
                      : null,
                ),

              _IconBtn(
                icon: Icons.stop_rounded,
                color: isDark
                    ? AppColors.onSurfaceDarkVariant
                    : AppColors.textSecondary,
                onPressed: () => unawaited(cubit.stop()),
              ),

              _PlayPauseButton(state: state, isDark: isDark),

              if (isPlaylist)
                _IconBtn(
                  icon: Icons.skip_next_rounded,
                  color: cubit.playlistIndex < cubit.playlist.length - 1
                      ? primaryColor
                      : (isDark
                            ? AppColors.outlineDark
                            : AppColors.textDisabled),
                  onPressed: cubit.playlistIndex < cubit.playlist.length - 1
                      ? () => unawaited(cubit.nextAyat())
                      : null,
                ),
            ],
          ),

          const SizedBox(height: AppDimens.spaceXS),

          // Progress bar
          _ProgressBar(isDark: isDark),
        ],
      ),
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

// ---------------------------------------------------------------------------
// Progress bar
// ---------------------------------------------------------------------------

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioCubit, AudioPlayerState>(
      buildWhen: (prev, curr) =>
          prev.position != curr.position || prev.duration != curr.duration,
      builder: (context, posState) {
        final position = posState.position;
        final duration = posState.duration;
        final progress = duration.inMilliseconds > 0
            ? position.inMilliseconds / duration.inMilliseconds
            : 0.0;
        final primaryColor = isDark
            ? AppColors.primaryLighter
            : AppColors.primary;

        return Column(
          children: [
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 2.5,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
                activeTrackColor: primaryColor,
                inactiveTrackColor: isDark
                    ? AppColors.outlineDark
                    : AppColors.primaryContainer,
                thumbColor: primaryColor,
                overlayColor: primaryColor.withValues(alpha: 0.12),
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
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.spaceSM,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDuration(position),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: isDark
                          ? AppColors.onSurfaceDarkVariant
                          : AppColors.textTertiary,
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    _formatDuration(duration),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: isDark
                          ? AppColors.onSurfaceDarkVariant
                          : AppColors.textTertiary,
                      fontSize: 10,
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

// ---------------------------------------------------------------------------
// Play/Pause button
// ---------------------------------------------------------------------------

class _PlayPauseButton extends StatelessWidget {
  const _PlayPauseButton({required this.state, required this.isDark});

  final AudioPlayerState state;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final primaryColor = isDark ? AppColors.primaryLighter : AppColors.primary;

    if (state.isLoading) {
      return SizedBox(
        width: 40,
        height: 40,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: primaryColor,
          ),
        ),
      );
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isDark ? AppColors.primaryDark : AppColors.primaryContainer,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(
          state.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
          color: primaryColor,
          size: 22,
        ),
        onPressed: () {
          final cubit = context.read<AudioCubit>();
          if (state.isPlaying) {
            unawaited(cubit.pause());
          } else if (state.isPaused) {
            unawaited(cubit.resume());
          }
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Icon button helper
// ---------------------------------------------------------------------------

class _IconBtn extends StatelessWidget {
  const _IconBtn({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: color, size: AppDimens.iconMD),
      onPressed: onPressed,
      padding: const EdgeInsets.all(AppDimens.spaceXS),
      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
    );
  }
}
