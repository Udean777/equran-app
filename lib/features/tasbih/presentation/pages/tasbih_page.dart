import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;
    final iconColor = isDark ? AppColors.onSurfaceDark : AppColors.textPrimary;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: surfaceColor,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: AppDimens.appBarHeightLG,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: Icon(Icons.menu_rounded, color: iconColor),
            tooltip: 'Menu',
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Tasbih Digital',
              style: AppTypography.serifHeadingMedium.copyWith(
                color: iconColor,
                height: 1,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 3),
            Container(
              width: 20,
              height: 1.5,
              decoration: BoxDecoration(
                color: AppColors.gold,
                borderRadius: BorderRadius.circular(AppDimens.radiusFull),
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          BlocBuilder<TasbihCubit, TasbihState>(
            builder: (context, state) => IconButton(
              icon: Icon(
                state.hapticEnabled
                    ? Icons.vibration_rounded
                    : Icons.phone_android_rounded,
                color: iconColor,
              ),
              tooltip: state.hapticEnabled
                  ? 'Matikan getaran'
                  : 'Aktifkan getaran',
              onPressed: () => context.read<TasbihCubit>().toggleHaptic(),
            ),
          ),
          IconButton(
            icon: Icon(Icons.history_rounded, color: iconColor),
            tooltip: 'Riwayat',
            onPressed: () => unawaited(context.push('/tasbih/history')),
          ),
        ],
      ),
      body: BlocBuilder<TasbihCubit, TasbihState>(
        builder: (context, state) {
          return Column(
            children: [
              DzikirInfoSection(state: state),
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
              TasbihBottomControls(state: state),
            ],
          );
        },
      ),
    );
  }
}
