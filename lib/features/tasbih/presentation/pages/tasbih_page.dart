import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/widgets/app_drawer.dart';
import 'package:equran_app/features/tasbih/presentation/cubit/tasbih_cubit.dart';
import 'package:equran_app/features/tasbih/presentation/pages/tasbih_history_page.dart';
import 'package:equran_app/features/tasbih/presentation/widgets/preset_selector_sheet.dart';
import 'package:equran_app/features/tasbih/presentation/widgets/tasbih_counter_button.dart';
import 'package:equran_app/injection/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TasbihPage extends StatelessWidget {
  const TasbihPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TasbihCubit>(),
      child: const _TasbihView(),
    );
  }
}

class _TasbihView extends StatelessWidget {
  const _TasbihView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Tasbih Digital'),
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu_rounded),
            tooltip: 'Menu',
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        actions: [
          // Toggle haptic
          BlocBuilder<TasbihCubit, TasbihState>(
            builder: (context, state) => IconButton(
              icon: Icon(
                state.hapticEnabled
                    ? Icons.vibration_rounded
                    : Icons.phone_android_rounded,
              ),
              tooltip: state.hapticEnabled
                  ? 'Matikan getaran'
                  : 'Aktifkan getaran',
              onPressed: () => context.read<TasbihCubit>().toggleHaptic(),
            ),
          ),
          // Riwayat
          IconButton(
            icon: const Icon(Icons.history_rounded),
            tooltip: 'Riwayat',
            onPressed: () => _openHistory(context),
          ),
        ],
      ),
      body: BlocBuilder<TasbihCubit, TasbihState>(
        builder: (context, state) {
          return Column(
            children: [
              // Info dzikir
              _DzikirInfoSection(state: state),

              // Counter button — tengah layar
              Expanded(
                child: Center(
                  child: TasbihCounterButton(
                    count: state.count,
                    progress: state.progress,
                    isCompleted: state.isCompleted,
                    onTap: () => context.read<TasbihCubit>().increment(),
                  ),
                ),
              ),

              // Bottom controls
              _BottomControls(state: state),
            ],
          );
        },
      ),
    );
  }

  void _openHistory(BuildContext context) {
    final cubit = context.read<TasbihCubit>();
    unawaited(
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) => BlocProvider.value(
            value: cubit,
            child: const TasbihHistoryPage(),
          ),
        ),
      ),
    );
  }
}

// ─── Dzikir Info Section ──────────────────────────────────────────────────────

class _DzikirInfoSection extends StatelessWidget {
  const _DzikirInfoSection({required this.state});

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
              _InfoChip(
                label: 'Target',
                value: '${state.target}x',
              ),
              const SizedBox(width: AppDimens.spaceSM),
              _InfoChip(
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
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppDimens.radiusLG),
          ),
        ),
        builder: (_) => BlocProvider.value(
          value: context.read<TasbihCubit>(),
          child: const PresetSelectorSheet(),
        ),
      ),
    );
  }
}

// ─── Info Chip ────────────────────────────────────────────────────────────────

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceMD,
        vertical: AppDimens.spaceSM,
      ),
      decoration: BoxDecoration(
        color: highlight
            ? AppColors.secondary.withValues(alpha: 0.15)
            : AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppDimens.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: highlight ? AppColors.secondary : AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Bottom Controls ──────────────────────────────────────────────────────────

class _BottomControls extends StatelessWidget {
  const _BottomControls({required this.state});

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
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppDimens.radiusLG),
          ),
        ),
        builder: (_) => BlocProvider.value(
          value: context.read<TasbihCubit>(),
          child: const PresetSelectorSheet(),
        ),
      ),
    );
  }
}
