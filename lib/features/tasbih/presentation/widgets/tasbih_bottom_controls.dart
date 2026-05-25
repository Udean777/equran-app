import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/utils/bottom_sheet_utils.dart';
import 'package:equran_app/features/tasbih/presentation/cubit/tasbih_cubit.dart';
import 'package:equran_app/features/tasbih/presentation/widgets/preset_selector_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Tombol bawah TasbihPage: Ganti Dzikir + Reset.
class TasbihBottomControls extends StatelessWidget {
  const TasbihBottomControls({required this.state, super.key});

  final TasbihState state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.spaceMD,
        AppDimens.spaceMD,
        AppDimens.spaceMD,
        AppDimens.spaceXL,
      ),
      child: Row(
        children: [
          // Ganti dzikir
          Expanded(
            child: OutlinedButton.icon(
              icon: const Icon(Icons.swap_horiz_rounded),
              label: const Text('Ganti Dzikir'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimens.spaceMD,
                ),
              ),
              onPressed: () => _showPresetSheet(context),
            ),
          ),

          const SizedBox(width: AppDimens.spaceMD),

          // Reset
          Expanded(
            child: FilledButton.icon(
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Reset'),
              style: FilledButton.styleFrom(
                backgroundColor: state.isCompleted
                    ? AppColors.secondary
                    : AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimens.spaceMD,
                ),
              ),
              onPressed: () => context.read<TasbihCubit>().reset(),
            ),
          ),
        ],
      ),
    );
  }

  void _showPresetSheet(BuildContext context) {
    unawaited(
      showAppBottomSheet<void>(
        context,
        builder: (_) => BlocProvider.value(
          value: context.read<TasbihCubit>(),
          child: const PresetSelectorSheet(),
        ),
      ),
    );
  }
}
