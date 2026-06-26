import 'package:equran_app/features/audio/presentation/providers.dart';
import 'package:equran_app/features/reading_progress/presentation/providers.dart';
import 'package:equran_app/features/surat_detail/presentation/viewmodels/auto_read_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AutoReadAudioListener extends ConsumerWidget {
  const AutoReadAudioListener({
    required this.child,
    required this.isAutoRead,
    required this.totalAyat,
    required this.suratNomor,
    required this.onAnimateToIndex,
    super.key,
  });

  final Widget child;
  final bool isAutoRead;
  final int totalAyat;
  final int suratNomor;
  final void Function(int targetIndex) onAnimateToIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AudioPlayerState>(audioViewModelProvider, (prev, curr) {
      if (!isAutoRead) return;
      if (prev?.currentAyat == curr.currentAyat) return;

      final currentAyat = curr.currentAyat;
      if (currentAyat == null) return;

      final cardState = ref.read(cardStackProvider(totalAyat));
      if (cardState.currentIndex != currentAyat) {
        onAnimateToIndex(currentAyat);
      }

      ref
          .read(readingProgressViewModelProvider.notifier)
          .bufferAyat(
            suratNomor,
            currentAyat,
          );
    });

    return child;
  }
}
