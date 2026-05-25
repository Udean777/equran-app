import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:flutter/material.dart';

/// Handle bar di bagian atas bottom sheet untuk indikasi bisa di-drag.
class BottomSheetHandle extends StatelessWidget {
  const BottomSheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.outlineVariant,
          borderRadius: BorderRadius.circular(AppDimens.radiusFull),
        ),
      ),
    );
  }
}
