import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/audio/domain/entities/audio_state_entity.dart';
import 'package:equran_app/features/audio/presentation/cubit/audio_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Tombol play/pause dengan loading state untuk AudioPlayerBar.
class AudioPlayPauseButton extends StatelessWidget {
  const AudioPlayPauseButton({
    required this.state,
    required this.isDark,
    super.key,
  });

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

/// Icon button generik untuk AudioPlayerBar.
class AudioIconBtn extends StatelessWidget {
  const AudioIconBtn({
    required this.icon,
    required this.color,
    required this.onPressed,
    super.key,
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
