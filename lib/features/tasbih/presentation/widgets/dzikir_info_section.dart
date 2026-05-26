import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/utils/bottom_sheet_utils.dart';
import 'package:equran_app/features/tasbih/presentation/cubit/tasbih_cubit.dart';
import 'package:equran_app/features/tasbih/presentation/widgets/info_chip.dart';
import 'package:equran_app/features/tasbih/presentation/widgets/preset_selector_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Section info dzikir: nama, teks Arab, dan chip target/sisa.
class DzikirInfoSection extends StatelessWidget {
  const DzikirInfoSection({required this.state, super.key});

  final TasbihState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceMD,
        vertical: AppDimens.spaceLG,
      ),
      child: Column(
        children: [
          // Nama dzikir
          GestureDetector(
            onTap: () => _showPresetSheet(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  state.selectedPreset.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: AppDimens.spaceSM),
                const Icon(
                  Icons.expand_more_rounded,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppDimens.spaceSM),

          // Teks Arab
          Text(
            state.selectedPreset.arabic,
            style: const TextStyle(
              fontFamily: 'Amiri',
              fontSize: 24,
              height: 1.8,
            ),
            textDirection: TextDirection.rtl,
          ),

          const SizedBox(height: AppDimens.spaceSM),

          // Target info
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InfoChip(
                label: 'Target',
                value: '${state.target}x',
              ),
              const SizedBox(width: AppDimens.spaceSM),
              InfoChip(
                label: 'Sisa',
                value: state.isCompleted ? '0' : '${state.remaining}x',
                highlight: state.isCompleted,
              ),
            ],
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
