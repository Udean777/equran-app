import 'dart:async';

import 'package:equran_app/core/router/app_routes.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/audio/domain/entities/audio_state_entity.dart';
import 'package:equran_app/features/audio/presentation/cubit/audio_cubit.dart';
import 'package:equran_app/features/audio/presentation/widgets/audio_player_bar.dart';
import 'package:equran_app/features/reading_progress/presentation/cubit/reading_progress_cubit.dart';
import 'package:equran_app/features/settings/presentation/widgets/settings_toast.dart';
import 'package:equran_app/features/surat_detail/constants/card_swipe_config.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:equran_app/features/surat_detail/presentation/controllers/auto_read_controller.dart';
import 'package:equran_app/features/surat_detail/presentation/controllers/card_stack_controller.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/juz_aware_app_bar.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/surat_action_bar.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/surat_card_stack.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/swipe_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Scaffold utama SuratDetailPage — card stack Tinder-style per ayat.
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
  late AnimationController _animController;
  late Animation<double> _snapAnimation;
  late AutoReadController _autoReadController;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _snapAnimation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    widget.controller.addListener(_onControllerChanged);

    // AutoReadController dibuat di initState — AudioCubit sudah tersedia via context
    // karena initState dipanggil setelah widget tree terbentuk.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _autoReadController = AutoReadController(
        audioCubit: context.read<AudioCubit>(),
        cardController: widget.controller,
      );
      _autoReadController.addListener(_onAutoReadChanged);
      _isAutoReadControllerInitialized = true;

      // Sync card ke audio aktif saat page pertama kali mount.
      // Kasus: user tap LastReadCard dari luar saat audio playlist masih berjalan
      // untuk surat yang sama — card harus langsung ke ayat audio terkini.
      final audioCubit = context.read<AudioCubit>();
      if (!audioCubit.isPlaylistMode) return;
      if (audioCubit.playlistSuratNomor != widget.suratNomor) return;

      final currentAyat = audioCubit.state.currentAyat;
      if (currentAyat == null) return;

      // Jump langsung tanpa animasi — ini initial sync, bukan advance
      if (widget.controller.currentIndex != currentAyat) {
        widget.controller.jumpTo(currentAyat);
      }

      // Aktifkan auto-read mode agar BlocListener mulai sync selanjutnya
      _autoReadController.activateWithoutPlay(
        onCompleted: () {
          if (!mounted) return;
          _animateToIndex(widget.controller.totalCards - 1);
        },
      );
    });
  }

  @override
  void dispose() {
    // Reset drag offset ke 0 sebelum dispose untuk menghindari visual artifact
    widget.controller.updateDrag(0);

    _animController.dispose();
    widget.controller.removeListener(_onControllerChanged);
    // AutoReadController mungkin belum diinisialisasi jika addPostFrameCallback
    // belum dipanggil saat dispose (edge case unmount sangat cepat).
    if (_isAutoReadControllerInitialized) {
      _autoReadController
        ..removeListener(_onAutoReadChanged)
        ..dispose();
    }
    super.dispose();
  }

  // Guard untuk edge case dispose sebelum postFrameCallback
  bool _isAutoReadControllerInitialized = false;

  void _onAutoReadChanged() {
    if (mounted) setState(() {});
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    if (_isAnimating) return;
    var newOffset = widget.controller.dragOffset + details.delta.dx;

    // Begitu juga pada info card, berarti dia gabisa swipe ke kanan, karna gaada card sebelum dia
    if (widget.controller.isFirst && newOffset > 0) {
      newOffset = 0;
    }

    // Dan jika sudah mentok di card selesai membaca (completion card), berarti gabisa di swipe lagi ke kiri
    if (widget.controller.isLast && newOffset < 0) {
      // Kita beri rubber band effect (resistance) agar kerasa mental/mentok, batas max -60
      newOffset = (widget.controller.dragOffset + details.delta.dx * 0.2).clamp(
        -60.0,
        0.0,
      );
    }

    widget.controller.updateDrag(newOffset);
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (_isAnimating) return;
    final screenWidth = MediaQuery.of(context).size.width;
    final velocity = details.primaryVelocity ?? 0;
    final offset = widget.controller.dragOffset;

    // Threshold: 30% layar atau velocity > 500
    final ratio = offset / screenWidth;

    if (ratio < -CardSwipeConfig.swipeThreshold ||
        velocity < -CardSwipeConfig.velocityThreshold) {
      // Halaman selanjutnya (jika ada)
      if (!widget.controller.isLast) {
        // Matikan auto-read jika user swipe manual
        if (_isAutoReadControllerInitialized && _autoReadController.isActive) {
          _stopAutoRead();
        }
        _animateOut(toLeft: true);
      } else {
        _snapBack();
      }
    } else if (ratio > CardSwipeConfig.swipeThreshold ||
        velocity > CardSwipeConfig.velocityThreshold) {
      // Halaman sebelumnya (jika ada)
      if (!widget.controller.isFirst) {
        // Matikan auto-read jika user swipe manual
        if (_isAutoReadControllerInitialized && _autoReadController.isActive) {
          _stopAutoRead();
        }
        _animateOut(toLeft: false);
      } else {
        _snapBack();
      }
    } else {
      _snapBack();
    }
  }

  void _animateOut({required bool toLeft}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final step = screenWidth - AppDimens.pagePadding;
    final target = toLeft ? -step : step;

    _isAnimating = true;
    _snapAnimation =
        Tween<double>(
          begin: widget.controller.dragOffset,
          end: target,
        ).animate(
          CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
        );

    _animController.reset();
    unawaited(
      _animController.forward().then((_) {
        _isAnimating = false;
        if (toLeft) {
          widget.controller.goNext();
        } else {
          widget.controller.goPrev();
        }
      }),
    );
  }

  /// Animasi tumble ke index tertentu — dipakai oleh auto-read mode.
  /// Selalu animasi ke kiri (next card).
  void _animateToIndex(int targetIndex) {
    if (_isAnimating) return;
    if (targetIndex <= widget.controller.currentIndex) return;

    final screenWidth = MediaQuery.sizeOf(context).width;
    final step = screenWidth - AppDimens.pagePadding;

    _isAnimating = true;
    _snapAnimation =
        Tween<double>(
          begin: 0,
          end: -step,
        ).animate(
          CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
        );

    _animController.reset();
    unawaited(
      _animController.forward().then((_) {
        _isAnimating = false;
        widget.controller.jumpTo(targetIndex);
      }),
    );
  }

  void _snapBack() {
    _isAnimating = true;
    _snapAnimation =
        Tween<double>(
          begin: widget.controller.dragOffset,
          end: 0,
        ).animate(
          CurvedAnimation(parent: _animController, curve: Curves.elasticOut),
        );

    _animController.reset();
    unawaited(
      _animController.forward().then((_) {
        _isAnimating = false;
        widget.controller.updateDrag(0);
      }),
    );
  }

  void _showSuccessDialog() {
    context.go(AppRoutes.home);
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

  @override
  Widget build(BuildContext context) {
    final detail = widget.detail;
    final controller = widget.controller;
    final isAutoRead =
        _isAutoReadControllerInitialized && _autoReadController.isActive;

    return BlocListener<AudioCubit, AudioPlayerState>(
      // Sync card swipe dengan audio advance saat auto-read aktif
      listenWhen: (prev, curr) =>
          isAutoRead && prev.currentAyat != curr.currentAyat,
      listener: (context, audioState) {
        if (!isAutoRead) return;

        // Sync card ke ayat yang sedang diplay dengan animasi tumble
        final currentAyat = audioState.currentAyat;
        if (currentAyat == null) return;
        final targetIndex = currentAyat; // index 1-based = ayat nomor
        if (widget.controller.currentIndex != targetIndex) {
          _animateToIndex(targetIndex);
        }

        // Buffer ayat ke reading progress saat auto-read advance
        context.read<ReadingProgressCubit>().bufferAyat(
          widget.detail.info.nomor,
          currentAyat,
        );
      },
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
                // Action bar — tombol berlabel untuk Hafalan, Download, Play
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
                // Sembunyikan AudioPlayerBar di completion card
                if (!isCompletionCard)
                  AudioPlayerBar(
                    audioMap: detail.audioFull,
                    // Stop: jika auto-read aktif, matikan mode juga
                    onStop: isAutoRead ? _stopAutoRead : null,
                    // Prev: swipe card + audio prev
                    onPrevCard:
                        audioCubit.isPlaylistMode &&
                            audioCubit.playlistIndex > 0
                        ? () {
                            unawaited(audioCubit.previousAyat());
                            controller.goPrev();
                          }
                        : null,
                    // Next: swipe card + audio next
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
              onHorizontalDragUpdate: _onHorizontalDragUpdate,
              onHorizontalDragEnd: _onHorizontalDragEnd,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimens.pagePadding,
                  AppDimens.spaceMD,
                  AppDimens.pagePadding,
                  AppDimens.spaceMD,
                ),
                child: AnimatedBuilder(
                  animation: _animController,
                  builder: (context, _) {
                    final offset = _isAnimating
                        ? _snapAnimation.value
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
