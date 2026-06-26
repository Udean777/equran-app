import 'dart:async';

import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/surat_detail/presentation/constants/card_swipe_config.dart';
import 'package:equran_app/features/surat_detail/presentation/viewmodels/auto_read_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CardViewGestureHandler {
  CardViewGestureHandler(this._state) {
    animController = AnimationController(
      vsync: _state as TickerProvider,
      duration: const Duration(milliseconds: 300),
    );
    snapAnimation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: animController, curve: Curves.easeOutCubic),
    );
  }

  final ConsumerState _state;
  late final AnimationController animController;
  late Animation<double> snapAnimation;
  bool isAnimating = false;

  WidgetRef get _ref => _state.ref;

  void dispose() {
    animController.dispose();
  }

  void onHorizontalDragUpdate(
    DragUpdateDetails details,
    int totalAyat,
  ) {
    if (isAnimating) return;
    if (!_state.mounted) return;

    final cardState = _ref.read(cardStackProvider(totalAyat));
    var newOffset = cardState.dragOffset + details.delta.dx;

    if (cardState.isFirst && newOffset > 0) {
      newOffset = 0;
    }

    if (cardState.isLast && newOffset < 0) {
      newOffset = (cardState.dragOffset + details.delta.dx * 0.2).clamp(
        -60.0,
        0.0,
      );
    }

    _ref.read(cardStackProvider(totalAyat).notifier).updateDrag(newOffset);
  }

  void onHorizontalDragEnd(
    DragEndDetails details, {
    required int totalAyat,
    required BuildContext context,
    VoidCallback? onStopAutoRead,
  }) {
    if (isAnimating) return;
    if (!_state.mounted) return;

    final cardState = _ref.read(cardStackProvider(totalAyat));
    final screenWidth = MediaQuery.of(context).size.width;
    final velocity = details.primaryVelocity ?? 0;
    final offset = cardState.dragOffset;
    final ratio = offset / screenWidth;

    if (ratio < -CardSwipeConfig.swipeThreshold ||
        velocity < -CardSwipeConfig.velocityThreshold) {
      if (!cardState.isLast) {
        onStopAutoRead?.call();
        _animateOut(
          toLeft: true,
          totalAyat: totalAyat,
          screenWidth: screenWidth,
        );
      } else {
        _snapBack(totalAyat);
      }
    } else if (ratio > CardSwipeConfig.swipeThreshold ||
        velocity > CardSwipeConfig.velocityThreshold) {
      if (!cardState.isFirst) {
        onStopAutoRead?.call();
        _animateOut(
          toLeft: false,
          totalAyat: totalAyat,
          screenWidth: screenWidth,
        );
      } else {
        _snapBack(totalAyat);
      }
    } else {
      _snapBack(totalAyat);
    }
  }

  void animateToIndex({
    required int targetIndex,
    required int totalAyat,
    required BuildContext context,
  }) {
    if (isAnimating) return;
    if (!_state.mounted) return;

    final cardState = _ref.read(cardStackProvider(totalAyat));
    if (targetIndex <= cardState.currentIndex) return;

    final screenWidth = MediaQuery.sizeOf(context).width;
    final step = screenWidth - AppDimens.pagePadding;

    isAnimating = true;
    snapAnimation =
        Tween<double>(
          begin: 0,
          end: -step,
        ).animate(
          CurvedAnimation(parent: animController, curve: Curves.easeOutCubic),
        );

    animController.reset();
    unawaited(
      animController.forward().then((_) {
        isAnimating = false;
        if (_state.mounted) {
          _ref.read(cardStackProvider(totalAyat).notifier).jumpTo(targetIndex);
        }
      }),
    );
  }

  void _animateOut({
    required bool toLeft,
    required int totalAyat,
    required double screenWidth,
  }) {
    final cardState = _ref.read(cardStackProvider(totalAyat));
    final step = screenWidth - AppDimens.pagePadding;
    final target = toLeft ? -step : step;

    isAnimating = true;
    snapAnimation =
        Tween<double>(
          begin: cardState.dragOffset,
          end: target,
        ).animate(
          CurvedAnimation(parent: animController, curve: Curves.easeOutCubic),
        );

    animController.reset();
    unawaited(
      animController.forward().then((_) {
        isAnimating = false;
        if (_state.mounted) {
          if (toLeft) {
            _ref.read(cardStackProvider(totalAyat).notifier).goNext();
          } else {
            _ref.read(cardStackProvider(totalAyat).notifier).goPrev();
          }
        }
      }),
    );
  }

  void _snapBack(int totalAyat) {
    final cardState = _ref.read(cardStackProvider(totalAyat));
    isAnimating = true;
    snapAnimation =
        Tween<double>(
          begin: cardState.dragOffset,
          end: 0,
        ).animate(
          CurvedAnimation(parent: animController, curve: Curves.elasticOut),
        );

    animController.reset();
    unawaited(
      animController.forward().then((_) {
        isAnimating = false;
        if (_state.mounted) {
          _ref.read(cardStackProvider(totalAyat).notifier).updateDrag(0);
        }
      }),
    );
  }
}
