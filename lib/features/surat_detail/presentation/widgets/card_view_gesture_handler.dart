import 'dart:async';

import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/surat_detail/constants/card_swipe_config.dart';
import 'package:equran_app/features/surat_detail/presentation/controllers/card_stack_controller.dart';
import 'package:flutter/material.dart';

class CardViewGestureHandler {
  CardViewGestureHandler(TickerProvider vsync) {
    animController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 300),
    );
    snapAnimation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: animController, curve: Curves.easeOutCubic),
    );
  }

  late final AnimationController animController;
  late final Animation<double> snapAnimation;
  bool isAnimating = false;

  void dispose() {
    animController.dispose();
  }

  void onHorizontalDragUpdate(
    DragUpdateDetails details,
    CardStackController controller,
  ) {
    if (isAnimating) return;
    var newOffset = controller.dragOffset + details.delta.dx;

    if (controller.isFirst && newOffset > 0) {
      newOffset = 0;
    }

    if (controller.isLast && newOffset < 0) {
      newOffset = (controller.dragOffset + details.delta.dx * 0.2).clamp(
        -60.0,
        0.0,
      );
    }

    controller.updateDrag(newOffset);
  }

  void onHorizontalDragEnd(
    DragEndDetails details,
    CardStackController controller, {
    required BuildContext context,
    VoidCallback? onStopAutoRead,
  }) {
    if (isAnimating) return;
    final screenWidth = MediaQuery.of(context).size.width;
    final velocity = details.primaryVelocity ?? 0;
    final offset = controller.dragOffset;
    final ratio = offset / screenWidth;

    if (ratio < -CardSwipeConfig.swipeThreshold ||
        velocity < -CardSwipeConfig.velocityThreshold) {
      if (!controller.isLast) {
        onStopAutoRead?.call();
        _animateOut(
          toLeft: true,
          controller: controller,
          screenWidth: screenWidth,
        );
      } else {
        _snapBack(controller);
      }
    } else if (ratio > CardSwipeConfig.swipeThreshold ||
        velocity > CardSwipeConfig.velocityThreshold) {
      if (!controller.isFirst) {
        onStopAutoRead?.call();
        _animateOut(
          toLeft: false,
          controller: controller,
          screenWidth: screenWidth,
        );
      } else {
        _snapBack(controller);
      }
    } else {
      _snapBack(controller);
    }
  }

  void animateToIndex({
    required int targetIndex,
    required CardStackController controller,
    required BuildContext context,
  }) {
    if (isAnimating) return;
    if (targetIndex <= controller.currentIndex) return;

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
        controller.jumpTo(targetIndex);
      }),
    );
  }

  void _animateOut({
    required bool toLeft,
    required CardStackController controller,
    required double screenWidth,
  }) {
    final step = screenWidth - AppDimens.pagePadding;
    final target = toLeft ? -step : step;

    isAnimating = true;
    snapAnimation =
        Tween<double>(
          begin: controller.dragOffset,
          end: target,
        ).animate(
          CurvedAnimation(parent: animController, curve: Curves.easeOutCubic),
        );

    animController.reset();
    unawaited(
      animController.forward().then((_) {
        isAnimating = false;
        if (toLeft) {
          controller.goNext();
        } else {
          controller.goPrev();
        }
      }),
    );
  }

  void _snapBack(CardStackController controller) {
    isAnimating = true;
    snapAnimation =
        Tween<double>(
          begin: controller.dragOffset,
          end: 0,
        ).animate(
          CurvedAnimation(parent: animController, curve: Curves.elasticOut),
        );

    animController.reset();
    unawaited(
      animController.forward().then((_) {
        isAnimating = false;
        controller.updateDrag(0);
      }),
    );
  }
}
