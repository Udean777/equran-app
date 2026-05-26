import 'dart:async';

import 'package:equran_app/core/widgets/app_drawer.dart';
import 'package:equran_app/features/tasbih/presentation/cubit/tasbih_cubit.dart';
import 'package:equran_app/features/tasbih/presentation/widgets/dzikir_info_section.dart';
import 'package:equran_app/features/tasbih/presentation/widgets/tasbih_bottom_controls.dart';
import 'package:equran_app/features/tasbih/presentation/widgets/tasbih_counter_button.dart';
import 'package:equran_app/injection/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
              DzikirInfoSection(state: state),

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
              TasbihBottomControls(state: state),
            ],
          );
        },
      ),
    );
  }

  void _openHistory(BuildContext context) {
    unawaited(context.push('/tasbih/history'));
  }
}
