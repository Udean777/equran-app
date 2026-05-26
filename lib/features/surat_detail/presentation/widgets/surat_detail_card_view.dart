import 'dart:async';
import 'dart:math' as math;

import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/audio/domain/entities/audio_state_entity.dart';
import 'package:equran_app/features/audio/presentation/cubit/audio_cubit.dart';
import 'package:equran_app/features/audio/presentation/widgets/audio_player_bar.dart';
import 'package:equran_app/features/bookmark/domain/entities/bookmark.dart';
import 'package:equran_app/features/bookmark/presentation/cubit/bookmark_cubit.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:equran_app/features/surat_detail/presentation/controllers/card_stack_controller.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/ayat_swipe_card.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/surat_detail_app_bar.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/surat_info_card.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/swipe_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    widget.controller.updateDrag(
      widget.controller.dragOffset + details.delta.dx,
    );
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
      _animateOut(toLeft: true);
    } else if (ratio > threshold || velocity > 500) {
      _animateOut(toLeft: false);
    } else {
      _snapBack();
    }
  }

  void _animateOut({required bool toLeft}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final target = toLeft ? -screenWidth * 1.5 : screenWidth * 1.5;

    _isAnimating = true;
    _snapAnimation =
        Tween<double>(
          begin: widget.controller.dragOffset,
          end: target,
        ).animate(
          CurvedAnimation(parent: _animController, curve: Curves.easeInCubic),
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
                builder: (_, _) => SwipeNavBar(controller: controller),
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
// Card Stack — render 3 cards (current + 2 behind)
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

    // Render max 3 cards: current + 2 behind
    final cardCount = math.min(3, totalCards - currentIndex);

    return Stack(
      children: [
        // Cards behind (index +2, +1) — rendered first (bottom of stack)
        for (var i = cardCount - 1; i >= 1; i--)
          _buildBehindCard(context, currentIndex + i, i),

        // Current card (top of stack)
        _buildCurrentCard(context, currentIndex),
      ],
    );
  }

  Widget _buildCurrentCard(BuildContext context, int index) {
    final rotationAngle = dragOffset / 1200;
    final screenWidth = MediaQuery.of(context).size.width;
    final dragRatio = (dragOffset / screenWidth).clamp(-1.0, 1.0);

    return Transform(
      transform: Matrix4.translationValues(dragOffset, dragRatio.abs() * 8, 0)
        ..rotateZ(rotationAngle),
      alignment: Alignment.bottomCenter,
      child: _buildCard(context, index),
    );
  }

  Widget _buildBehindCard(BuildContext context, int index, int depth) {
    // Cards behind: sedikit lebih kecil dan offset ke bawah
    final scale = 1.0 - depth * 0.04;
    final translateY = depth * 12.0;
    // Saat drag, card belakang sedikit "naik" mendekati posisi aktif
    final dragRatio =
        (dragOffset.abs() / (MediaQuery.of(context).size.width * 0.5)).clamp(
          0.0,
          1.0,
        );
    final animatedScale = scale + (1.0 - scale) * dragRatio * 0.5;
    final animatedTranslateY = translateY * (1 - dragRatio * 0.3);

    return Transform(
      transform: Matrix4.translationValues(0, animatedTranslateY, 0),
      alignment: Alignment.topCenter,
      child: Transform.scale(
        scale: animatedScale,
        alignment: Alignment.topCenter,
        child: Opacity(
          opacity: 1.0 - depth * 0.15,
          child: _buildCard(context, index),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, int index) {
    if (index == 0) {
      return SuratInfoCard(detail: detail);
    }

    final ayatIndex = index - 1;
    if (ayatIndex >= detail.ayatList.length) return const SizedBox.shrink();

    final ayat = detail.ayatList[ayatIndex];

    return BlocBuilder<BookmarkCubit, BookmarkState>(
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
}
