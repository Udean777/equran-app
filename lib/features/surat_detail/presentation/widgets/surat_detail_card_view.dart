import 'dart:async';

import 'package:equran_app/core/router/app_routes.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/audio/domain/entities/audio_state_entity.dart';
import 'package:equran_app/features/audio/presentation/cubit/audio_cubit.dart';
import 'package:equran_app/features/audio/presentation/widgets/audio_player_bar.dart';
import 'package:equran_app/features/settings/presentation/widgets/settings_toast.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:equran_app/features/surat_detail/presentation/controllers/auto_read_controller.dart';
import 'package:equran_app/features/surat_detail/presentation/controllers/card_stack_controller.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/auto_read_audio_listener.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/card_view_gesture_handler.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/juz_aware_app_bar.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/surat_action_bar.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/surat_card_stack.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/swipe_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SuratDetailCardView extends StatefulWidget {
  const SuratDetailCardView({
    required this.detail,
    required this.controller,
    required this.onToggleAutoScroll,
    required this.autoScrollEnabled,
    required this.suratNomor,
    super.key,
  });

  final SuratDetail detail;
  final CardStackController controller;
  final VoidCallback onToggleAutoScroll;
  final bool autoScrollEnabled;
  final int suratNomor;

  @override
  State<SuratDetailCardView> createState() => _SuratDetailCardViewState();
}

class _SuratDetailCardViewState extends State<SuratDetailCardView>
    with SingleTickerProviderStateMixin {
  late final CardViewGestureHandler gestureHandler;
  late AutoReadController _autoReadController;
  bool _isAutoReadControllerInitialized = false;

  @override
  void initState() {
    super.initState();
    gestureHandler = CardViewGestureHandler(this);
    widget.controller.addListener(_onControllerChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _autoReadController = AutoReadController(
        audioCubit: context.read<AudioCubit>(),
        cardController: widget.controller,
      );
      _autoReadController.addListener(_onAutoReadChanged);
      _isAutoReadControllerInitialized = true;

      final audioCubit = context.read<AudioCubit>();
      if (!audioCubit.isPlaylistMode) return;
      if (audioCubit.playlistSuratNomor != widget.suratNomor) return;

      final currentAyat = audioCubit.state.currentAyat;
      if (currentAyat == null) return;

      if (widget.controller.currentIndex != currentAyat) {
        widget.controller.jumpTo(currentAyat);
      }

      _autoReadController.activateWithoutPlay(
        onCompleted: () {
          if (!mounted) return;
          gestureHandler.animateToIndex(
            targetIndex: widget.controller.totalCards - 1,
            controller: widget.controller,
            context: context,
          );
        },
      );
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    gestureHandler.dispose();
    if (_isAutoReadControllerInitialized) {
      _autoReadController
        ..removeListener(_onAutoReadChanged)
        ..dispose();
    }
    super.dispose();
  }

  void _onAutoReadChanged() {
    if (mounted) setState(() {});
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  void _startAutoRead() {
    if (!_isAutoReadControllerInitialized) return;
    showSettingsToast(context, 'Mode Baca Otomatis aktif');
    _autoReadController.start(widget.detail);
  }

  void _stopAutoRead({bool showToast = true}) {
    if (!_isAutoReadControllerInitialized) return;
    if (!_autoReadController.isActive) return;
    _autoReadController.stop();
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
    final controller = widget.controller;
    final gh = gestureHandler;
    final isAutoRead =
        _isAutoReadControllerInitialized && _autoReadController.isActive;

    return AutoReadAudioListener(
      isAutoRead: isAutoRead,
      controller: controller,
      suratNomor: widget.suratNomor,
      onAnimateToIndex: (targetIndex) => gh.animateToIndex(
        targetIndex: targetIndex,
        controller: controller,
        context: context,
      ),
      child: BlocBuilder<AudioCubit, AudioPlayerState>(
        buildWhen: (prev, next) =>
            prev.isPlaying != next.isPlaying ||
            prev.isPaused != next.isPaused ||
            prev.isIdle != next.isIdle ||
            prev.currentQari != next.currentQari,
        builder: (context, audioState) {
          final audioCubit = context.read<AudioCubit>();
          final isCompletionCard = controller.isLast;

          return Scaffold(
            appBar: JuzAwareAppBar(
              detail: detail,
              controller: controller,
            ),
            bottomNavigationBar: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SuratActionBar(
                  detail: detail,
                  autoScrollEnabled: widget.autoScrollEnabled,
                  onToggleAutoScroll: widget.onToggleAutoScroll,
                ),
                ListenableBuilder(
                  listenable: controller,
                  builder: (_, _) => SwipeNavBar(
                    controller: controller,
                    onComplete: _showSuccessDialog,
                  ),
                ),
                if (!isCompletionCard)
                  AudioPlayerBar(
                    audioMap: detail.audioFull,
                    onStop: isAutoRead ? _stopAutoRead : null,
                    onPrevCard:
                        audioCubit.isPlaylistMode &&
                            audioCubit.playlistIndex > 0
                        ? () {
                            unawaited(audioCubit.previousAyat());
                            controller.goPrev();
                          }
                        : null,
                    onNextCard:
                        audioCubit.isPlaylistMode &&
                            audioCubit.playlistIndex <
                                audioCubit.playlist.length - 1
                        ? () {
                            unawaited(audioCubit.nextAyat());
                            controller.goNext();
                          }
                        : null,
                  ),
              ],
            ),
            body: GestureDetector(
              onHorizontalDragUpdate: (details) =>
                  gh.onHorizontalDragUpdate(details, controller),
              onHorizontalDragEnd: (details) => gh.onHorizontalDragEnd(
                details,
                controller,
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
                        : controller.dragOffset;
                    return SuratCardStack(
                      detail: detail,
                      controller: controller,
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
