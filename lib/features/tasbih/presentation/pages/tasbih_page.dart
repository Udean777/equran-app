import 'dart:async';

import 'package:equran_app/core/router/app_routes.dart';
import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/widgets/app_drawer.dart';
import 'package:equran_app/core/widgets/luxury_app_bar.dart';
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

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
      drawer: const AppDrawer(),
      appBar: LuxuryAppBar(
        title: 'Tasbih & Dzikir',
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            tooltip: 'Riwayat',
            onPressed: () => context.push(AppRoutes.tasbihHistory),
          ),
        ],
      ),
      body: BlocBuilder<TasbihCubit, TasbihState>(
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.pagePadding,
                    vertical: AppDimens.spaceLG,
                  ),
                  child: Column(
                    children: [
                      DzikirInfoSection(state: state),
                      const SizedBox(height: AppDimens.spaceLG),
                      TasbihCounterButton(
                        count: state.count,
                        progress: state.target > 0
                            ? state.count / state.target
                            : 0.0,
                        isCompleted: state.isCompleted,
                        onTap: () =>
                            unawaited(context.read<TasbihCubit>().increment()),
                      ),
                    ],
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
