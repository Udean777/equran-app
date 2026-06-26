import 'dart:async';

import 'package:equran_app/core/router/app_routes.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/audio/presentation/providers.dart';
import 'package:equran_app/features/audio/presentation/widgets/audio_player_bar.dart';
import 'package:equran_app/features/settings/presentation/widgets/settings_toast.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:equran_app/features/surat_detail/presentation/viewmodels/auto_read_notifier.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/auto_read_audio_listener.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/card_view_gesture_handler.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/juz_aware_app_bar.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/surat_action_bar.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/surat_card_stack.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/swipe_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SuratDetailCardView extends ConsumerStatefulWidget {
  const SuratDetailCardView({
    required this.detail,
    required this.totalAyat,
    required this.onToggleAutoScroll,
    required this.autoScrollEnabled,
    required this.suratNomor,
    super.key,
  });

  final SuratDetail detail;
  final int totalAyat;
  final VoidCallback onToggleAutoScroll;
  final bool autoScrollEnabled;
  final int suratNomor;

  @override
  ConsumerState<SuratDetailCardView> createState() =>
      _SuratDetailCardViewState();
}

class _SuratDetailCardViewState extends ConsumerState<SuratDetailCardView>
    with SingleTickerProviderStateMixin {
  late final CardViewGestureHandler gestureHandler;

  @override
  void initState() {
    super.initState();
    gestureHandler = CardViewGestureHandler(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final audioState = ref.read(audioViewModelProvider);
      final audioVM = ref.read(audioViewModelProvider.notifier);

      // Sync auto-read from existing audio
      if (!audioVM.isPlaylistMode) return;
      if (audioVM.playlistSuratNomor != widget.suratNomor) return;

      final currentAyat = audioState.currentAyat;
      if (currentAyat == null) return;

      final cardState = ref.read(cardStackProvider(widget.totalAyat));
      if (cardState.currentIndex != currentAyat) {
        ref
            .read(cardStackProvider(widget.totalAyat).notifier)
            .jumpTo(currentAyat);
      }

      ref
          .read(autoReadProvider(widget.totalAyat).notifier)
          .activateWithoutPlay(
            onCompleted: () {
              if (!mounted) return;
              final totalCards = cardState.totalCards;
              gestureHandler.animateToIndex(
                targetIndex: totalCards - 1,
                totalAyat: widget.totalAyat,
                context: context,
              );
            },
          );
    });
  }

  @override
  void dispose() {
    gestureHandler.dispose();
    super.dispose();
  }

  void _startAutoRead() {
    showSettingsToast(context, 'Mode Baca Otomatis aktif');
    final audioState = ref.read(audioViewModelProvider);
    ref
        .read(autoReadProvider(widget.totalAyat).notifier)
        .start(
          detail: widget.detail,
          qari: audioState.currentQari,
        );
  }

  void _stopAutoRead({bool showToast = true}) {
    final autoReadState = ref.read(autoReadProvider(widget.totalAyat));
    if (!autoReadState.isActive) return;
    ref.read(autoReadProvider(widget.totalAyat).notifier).stop();
    if (showToast && mounted) {
      showSettingsToast(
        context,
        'Mode Baca Otomatis dimatikan',
        isSuccess: false,
      );
    }
  }

  void _showSuccessDialog() {
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final detail = widget.detail;
    final cardState = ref.watch(cardStackProvider(widget.totalAyat));
    final autoReadState = ref.watch(autoReadProvider(widget.totalAyat));
    final gh = gestureHandler;
    final isAutoRead = autoReadState.isActive;

    return AutoReadAudioListener(
      isAutoRead: isAutoRead,
      totalAyat: widget.totalAyat,
      suratNomor: widget.suratNomor,
      onAnimateToIndex: (targetIndex) => gh.animateToIndex(
        targetIndex: targetIndex,
        totalAyat: widget.totalAyat,
        context: context,
      ),
      child: Consumer(
        builder: (context, ref, _) {
          final audioNotifier = ref.read(audioViewModelProvider.notifier);
          final isCompletionCard = cardState.isLast;

          return Scaffold(
            appBar: JuzAwareAppBar(
              detail: detail,
              totalAyat: widget.totalAyat,
            ),
            bottomNavigationBar: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SuratActionBar(
                  detail: detail,
                  autoScrollEnabled: widget.autoScrollEnabled,
                  onToggleAutoScroll: widget.onToggleAutoScroll,
                ),
                SwipeNavBar(
                  totalAyat: widget.totalAyat,
                  onComplete: _showSuccessDialog,
                ),
                if (!isCompletionCard)
                  AudioPlayerBar(
                    audioMap: detail.audioFull,
                    onStop: isAutoRead ? _stopAutoRead : null,
                    onPrevCard:
                        audioNotifier.isPlaylistMode &&
                            audioNotifier.playlistIndex > 0
                        ? () {
                            unawaited(audioNotifier.previousAyat());
                            ref
                                .read(
                                  cardStackProvider(widget.totalAyat).notifier,
                                )
                                .goPrev();
                          }
                        : null,
                    onNextCard:
                        audioNotifier.isPlaylistMode &&
                            audioNotifier.playlistIndex <
                                audioNotifier.playlist.length - 1
                        ? () {
                            unawaited(audioNotifier.nextAyat());
                            ref
                                .read(
                                  cardStackProvider(widget.totalAyat).notifier,
                                )
                                .goNext();
                          }
                        : null,
                  ),
              ],
            ),
            body: GestureDetector(
              onHorizontalDragUpdate: (details) =>
                  gh.onHorizontalDragUpdate(details, widget.totalAyat),
              onHorizontalDragEnd: (details) => gh.onHorizontalDragEnd(
                details,
                totalAyat: widget.totalAyat,
                context: context,
                onStopAutoRead: isAutoRead ? _stopAutoRead : null,
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimens.pagePadding,
                  AppDimens.spaceMD,
                  AppDimens.pagePadding,
                  AppDimens.spaceMD,
                ),
                child: AnimatedBuilder(
                  animation: gh.animController,
                  builder: (context, _) {
                    final offset = gh.isAnimating
                        ? gh.snapAnimation.value
                        : cardState.dragOffset;
                    return SuratCardStack(
                      detail: detail,
                      totalAyat: widget.totalAyat,
                      dragOffset: offset,
                      onStartAutoRead: _startAutoRead,
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
