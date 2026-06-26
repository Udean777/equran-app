import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/audio/presentation/providers.dart';
import 'package:equran_app/features/audio/presentation/utils/format_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Slider progress + label waktu untuk AudioPlayerBar.
class AudioProgressBar extends ConsumerWidget {
  const AudioProgressBar({
    required this.isDark,
    this.showLabels = true,
    super.key,
  });

  final bool isDark;

  /// Jika false, hanya render slider tanpa label waktu.
  final bool showLabels;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posState = ref.watch(audioViewModelProvider);
    final vm = ref.read(audioViewModelProvider.notifier);
    final isPlaylist = vm.isPlaylistMode;
    final playlistTotal = vm.playlistTotalDuration;

    final position = isPlaylist && playlistTotal > Duration.zero
        ? vm.playlistCurrentPosition
        : posState.position;
    final duration = isPlaylist && playlistTotal > Duration.zero
        ? playlistTotal
        : posState.duration;

    final progress = duration.inMilliseconds > 0
        ? position.inMilliseconds / duration.inMilliseconds
        : 0.0;
    final primaryColor = isDark ? AppColors.primaryLighter : AppColors.primary;

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
              unawaited(vm.seek(seekTo));
            },
          ),
        ),
        if (showLabels)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.spaceSM,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  position.toReadableString(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isDark
                        ? AppColors.onSurfaceDarkVariant
                        : AppColors.textTertiary,
                    fontSize: 10,
                  ),
                ),
                Text(
                  duration.toReadableString(),
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
  }
}
