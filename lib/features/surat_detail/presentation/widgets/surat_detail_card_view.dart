import 'dart:async';

import 'package:equran_app/core/router/app_routes.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/audio/domain/entities/audio_state_entity.dart';
import 'package:equran_app/features/audio/presentation/cubit/audio_cubit.dart';
import 'package:equran_app/features/audio/presentation/widgets/audio_player_bar.dart';
import 'package:equran_app/features/bookmark/domain/entities/bookmark.dart';
import 'package:equran_app/features/bookmark/presentation/cubit/bookmark_cubit.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:equran_app/features/surat_detail/presentation/controllers/card_stack_controller.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/ayat_swipe_card.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/surat_completion_card.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/surat_detail_app_bar.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/surat_info_card.dart';
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
  }

  @override
  void dispose() {
    _animController.dispose();
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
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
      newOffset = (widget.controller.dragOffset + details.delta.dx * 0.2).clamp(-60.0, 0.0);
    }

    widget.controller.updateDrag(newOffset);
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (_isAnimating) return;
    final screenWidth = MediaQuery.of(context).size.width;
    final velocity = details.primaryVelocity ?? 0;
    final offset = widget.controller.dragOffset;

    // Threshold: 30% layar atau velocity > 500
    const threshold = 0.3;
    final ratio = offset / screenWidth;

    if (ratio < -threshold || velocity < -500) {
      // Halaman selanjutnya (jika ada)
      if (!widget.controller.isLast) {
        _animateOut(toLeft: true);
      } else {
        _snapBack();
      }
    } else if (ratio > threshold || velocity > 500) {
      // Halaman sebelumnya (jika ada)
      if (!widget.controller.isFirst) {
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
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final detail = widget.detail;
    final controller = widget.controller;

    return BlocBuilder<AudioCubit, AudioPlayerState>(
      buildWhen: (prev, next) =>
          prev.isPlaying != next.isPlaying ||
          prev.isPaused != next.isPaused ||
          prev.currentQari != next.currentQari,
      builder: (context, audioState) {
        return Scaffold(
          appBar: SuratDetailAppBar(
            detail: detail,
            autoScrollEnabled: widget.autoScrollEnabled,
            onToggleAutoScroll: widget.onToggleAutoScroll,
            onDownloadTap: () {},
            scrollProgress: controller.currentProgress,
          ),
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListenableBuilder(
                listenable: controller,
                builder: (_, _) => SwipeNavBar(
                  controller: controller,
                  onComplete: _showSuccessDialog,
                ),
              ),
              AudioPlayerBar(audioMap: detail.audioFull),
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
                  return _CardStack(
                    detail: detail,
                    controller: controller,
                    dragOffset: offset,
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Side-by-Side Horizontal Card View
// ---------------------------------------------------------------------------

class _CardStack extends StatelessWidget {
  const _CardStack({
    required this.detail,
    required this.controller,
    required this.dragOffset,
  });

  final SuratDetail detail;
  final CardStackController controller;
  final double dragOffset;

  @override
  Widget build(BuildContext context) {
    final currentIndex = controller.currentIndex;
    final totalCards = controller.totalCards;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Previous card (left)
        if (currentIndex > 0)
          _buildSideCard(context, currentIndex - 1, isLeft: true),

        // Next card (right)
        if (currentIndex < totalCards - 1)
          _buildSideCard(context, currentIndex + 1, isLeft: false),

        // Current card (center)
        _buildActiveCard(context, currentIndex),
      ],
    );
  }

  Widget _buildActiveCard(BuildContext context, int index) {
    final screenWidth = MediaQuery.of(context).size.width;
    final dragRatio = (dragOffset / screenWidth).clamp(-1.0, 1.0);
    
    // Tumble rotation: tilt as it moves
    final rotationAngle = dragRatio * 0.3; // max ~17 degrees
    
    // Tumble scale: shrink slightly
    final scale = 1.0 - dragRatio.abs() * 0.08;
    
    // Tumble opacity: fade slightly
    final opacity = (1.0 - dragRatio.abs() * 0.4).clamp(0.0, 1.0);
    
    // Tumble translation: horizontal + slight downward drop
    final translateY = dragRatio.abs() * 24.0;

    return Transform(
      transform: Matrix4.translationValues(dragOffset, translateY, 0)
        ..rotateZ(rotationAngle),
      alignment: Alignment.center,
      child: Transform.scale(
        scale: scale,
        child: Opacity(
          opacity: opacity,
          child: _buildCard(context, index),
        ),
      ),
    );
  }

  Widget _buildSideCard(BuildContext context, int index, {required bool isLeft}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final step = screenWidth - AppDimens.pagePadding;
    final baseOffset = isLeft ? -step : step;
    final offset = baseOffset + dragOffset;
    
    // progress: 0.0 when fully centered, 1.0 when fully off-screen
    final progress = (offset.abs() / step).clamp(0.0, 1.0);
    final activeFactor = 1.0 - progress; // 1.0 when centered, 0.0 when off-screen

    // Tumble rotation for side card: tilts when off-screen, upright when centered
    final tiltSign = isLeft ? -1.0 : 1.0;
    final rotationAngle = tiltSign * 0.2 * (1.0 - activeFactor); // ~11 degrees off-screen tilt

    // Tumble scale: 0.92 when off-screen, 1.0 when centered
    final scale = 0.92 + 0.08 * activeFactor;

    // Tumble opacity: 0.6 when off-screen, 1.0 when centered
    final opacity = (0.6 + 0.4 * activeFactor).clamp(0.0, 1.0);

    // Tumble translation: horizontal + slight vertical position adjustment
    final translateY = 20.0 * (1.0 - activeFactor);

    return Transform(
      transform: Matrix4.translationValues(offset, translateY, 0)
        ..rotateZ(rotationAngle),
      alignment: Alignment.center,
      child: Transform.scale(
        scale: scale,
        child: Opacity(
          opacity: opacity,
          child: _buildCard(context, index),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, int index) {
    Widget card;
    if (index == 0) {
      card = SuratInfoCard(detail: detail);
    } else if (index == controller.totalCards - 1) {
      card = SuratCompletionCard(
        detail: detail,
        onBackToHome: () {
    context.go(AppRoutes.home);
        },
        onRestart: () {
          controller.jumpTo(0);
        },
      );
    } else {
      final ayatIndex = index - 1;
      if (ayatIndex >= detail.ayatList.length) return const SizedBox.shrink();

      final ayat = detail.ayatList[ayatIndex];

      card = BlocBuilder<BookmarkCubit, BookmarkState>(
        buildWhen: (prev, next) =>
            prev.mapOrNull(success: (s) => s.bookmarks) !=
            next.mapOrNull(success: (s) => s.bookmarks),
        builder: (context, bookmarkState) {
          final bookmarks =
              bookmarkState.mapOrNull(success: (s) => s.bookmarks) ?? [];
          final isBookmarked = bookmarks.any(
            (b) =>
                b.suratNomor == detail.info.nomor &&
                b.ayatNomor == ayat.nomorAyat,
          );

          return AyatSwipeCard(
            ayat: ayat,
            suratDetail: detail,
            isBookmarked: isBookmarked,
            onBookmarkToggle: () {
              if (isBookmarked) {
                unawaited(
                  context.read<BookmarkCubit>().removeBookmark(
                    suratNomor: detail.info.nomor,
                    ayatNomor: ayat.nomorAyat,
                  ),
                );
              } else {
                unawaited(
                  context.read<BookmarkCubit>().addBookmark(
                    Bookmark(
                      suratNomor: detail.info.nomor,
                      ayatNomor: ayat.nomorAyat,
                      namaLatin: detail.info.namaLatin,
                      teksArab: ayat.teksArab,
                      teksIndonesia: ayat.teksIndonesia,
                      savedAt: DateTime.now(),
                    ),
                  ),
                );
              }
            },
          );
        },
      );
    }

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.65,
        ),
        child: card,
      ),
    );
  }
}
