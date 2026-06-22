import 'dart:async';

import 'package:equran_app/core/router/app_routes.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/bookmark/domain/entities/bookmark.dart';
import 'package:equran_app/features/bookmark/presentation/cubit/bookmark_cubit.dart';
import 'package:equran_app/features/surat_detail/constants/card_swipe_config.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:equran_app/features/surat_detail/presentation/controllers/card_stack_controller.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/ayat_swipe_card.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/surat_completion_card.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/surat_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Side-by-Side Horizontal Card View
class SuratCardStack extends StatelessWidget {
  const SuratCardStack({
    required this.detail,
    required this.controller,
    required this.dragOffset,
    this.onStartAutoRead,
    super.key,
  });

  final SuratDetail detail;
  final CardStackController controller;
  final double dragOffset;
  final VoidCallback? onStartAutoRead;

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
    final rotationAngle =
        dragRatio * CardSwipeConfig.rotationFactor; // max ~17 degrees

    // Tumble scale: shrink slightly
    final scale = 1.0 - dragRatio.abs() * CardSwipeConfig.scaleFactor;

    // Tumble opacity: fade slightly
    final opacity = (1.0 - dragRatio.abs() * CardSwipeConfig.opacityFactor)
        .clamp(0.0, 1.0);

    // Tumble translation: horizontal + slight downward drop
    final translateY = dragRatio.abs() * CardSwipeConfig.translateYFactor;

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

  Widget _buildSideCard(
    BuildContext context,
    int index, {
    required bool isLeft,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final step = screenWidth - AppDimens.pagePadding;
    final baseOffset = isLeft ? -step : step;
    final offset = baseOffset + dragOffset;

    // progress: 0.0 when fully centered, 1.0 when fully off-screen
    final progress = (offset.abs() / step).clamp(0.0, 1.0);
    final activeFactor =
        1.0 - progress; // 1.0 when centered, 0.0 when off-screen

    // Tumble rotation for side card: tilts when off-screen, upright when centered
    final tiltSign = isLeft ? -1.0 : 1.0;
    final rotationAngle =
        tiltSign *
        CardSwipeConfig.sideCardRotation *
        (1.0 - activeFactor); // ~11 degrees off-screen tilt

    // Tumble scale: 0.92 when off-screen, 1.0 when centered
    final scale =
        CardSwipeConfig.sideCardScale +
        CardSwipeConfig.scaleFactor * activeFactor;

    // Tumble opacity: 0.6 when off-screen, 1.0 when centered
    final opacity =
        (CardSwipeConfig.sideCardOpacity +
                CardSwipeConfig.opacityFactor * activeFactor)
            .clamp(0.0, 1.0);

    // Tumble translation: horizontal + slight vertical position adjustment
    final translateY =
        CardSwipeConfig.sideCardTranslateY * (1.0 - activeFactor);

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
      final isCompleted =
          context.watch<BookmarkCubit>().state.mapOrNull(
            success: (s) => s.suratProgressMap[detail.info.nomor] == 1.0,
          ) ??
          false;
      card = SuratInfoCard(
        detail: detail,
        isCompleted: isCompleted,
        onStartAutoRead: onStartAutoRead,
      );
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
          maxHeight:
              MediaQuery.of(context).size.height *
              CardSwipeConfig.cardMaxHeightRatio,
        ),
        child: card,
      ),
    );
  }
}
