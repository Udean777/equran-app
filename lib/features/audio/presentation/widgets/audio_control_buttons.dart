import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/audio/presentation/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tombol play/pause dengan loading state untuk AudioPlayerBar.
class AudioPlayPauseButton extends StatelessWidget {
  const AudioPlayPauseButton({
    required this.state,
    required this.isDark,
    this.size = 40.0,
    this.iconSize = 22.0,
    this.showLoadingIndicator = false,
    super.key,
  });

  final AudioPlayerState state;
  final bool isDark;

  /// Diameter tombol play/pause.
  final double size;

  /// Ukuran icon di dalam tombol.
  final double iconSize;

  /// Jika true, tampilkan spinner saat isLoading.
  /// Mini bar: false (tetap tampil play/pause).
  /// Full player: true (boleh tampil spinner).
  final bool showLoadingIndicator;

  @override
  Widget build(BuildContext context) {
    final primaryColor = isDark ? AppColors.primaryLighter : AppColors.primary;

    if (showLoadingIndicator && state.isLoading) {
      return SizedBox(
        width: size,
        height: size,
        child: Padding(
          padding: EdgeInsets.all(size * 0.25),
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: primaryColor,
          ),
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isDark ? AppColors.primaryDark : AppColors.primaryContainer,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(
          state.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
          color: primaryColor,
          size: iconSize,
        ),
        onPressed: () {
          final vm = ProviderScope.containerOf(
            context,
          ).read(audioViewModelProvider.notifier);
          if (state.isPlaying) {
            unawaited(vm.pause());
          } else if (state.isPaused) {
            unawaited(vm.resume());
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
    this.iconSize = AppDimens.iconMD,
    this.buttonSize = 36.0,
    super.key,
  });

  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;

  /// Ukuran icon.
  final double iconSize;

  /// Ukuran minimum area tap (width & height).
  final double buttonSize;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: color, size: iconSize),
      onPressed: onPressed,
      padding: const EdgeInsets.all(AppDimens.spaceXS),
      constraints: BoxConstraints(minWidth: buttonSize, minHeight: buttonSize),
    );
  }
}
