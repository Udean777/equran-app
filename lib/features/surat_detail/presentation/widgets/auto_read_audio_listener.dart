import 'package:equran_app/features/audio/domain/entities/audio_state_entity.dart';
import 'package:equran_app/features/audio/presentation/cubit/audio_cubit.dart';
import 'package:equran_app/features/reading_progress/presentation/cubit/reading_progress_cubit.dart';
import 'package:equran_app/features/surat_detail/presentation/controllers/card_stack_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AutoReadAudioListener extends StatelessWidget {
  const AutoReadAudioListener({
    required this.child,
    required this.isAutoRead,
    required this.controller,
    required this.suratNomor,
    required this.onAnimateToIndex,
    super.key,
  });

  final Widget child;
  final bool isAutoRead;
  final CardStackController controller;
  final int suratNomor;
  final void Function(int targetIndex) onAnimateToIndex;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AudioCubit, AudioPlayerState>(
      listenWhen: (prev, curr) =>
          isAutoRead && prev.currentAyat != curr.currentAyat,
      listener: (context, audioState) {
        if (!isAutoRead) return;

        final currentAyat = audioState.currentAyat;
        if (currentAyat == null) return;

        if (controller.currentIndex != currentAyat) {
          onAnimateToIndex(currentAyat);
        }

        context.read<ReadingProgressCubit>().bufferAyat(
          suratNomor,
          currentAyat,
        );
      },
      child: child,
    );
  }
}
