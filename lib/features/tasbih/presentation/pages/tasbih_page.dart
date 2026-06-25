import 'dart:async';

import 'package:equran_app/core/router/app_routes.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/context_ext.dart';
import 'package:equran_app/core/widgets/app_drawer.dart';
import 'package:equran_app/core/widgets/luxury_app_bar.dart';
import 'package:equran_app/features/quran_reminder/presentation/widgets/streak_badge_slot.dart';
import 'package:equran_app/features/tasbih/presentation/providers.dart';
import 'package:equran_app/features/tasbih/presentation/widgets/dzikir_info_section.dart';
import 'package:equran_app/features/tasbih/presentation/widgets/tasbih_bottom_controls.dart';
import 'package:equran_app/features/tasbih/presentation/widgets/tasbih_counter_button.dart';
import 'package:equran_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TasbihPage extends ConsumerWidget {
  const TasbihPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(tasbihViewModelProvider);

    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      drawer: const AppDrawer(streakBadge: StreakBadgeSlot()),
      appBar: LuxuryAppBar(
        title: l10n.tasbihTitle,
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            tooltip: l10n.tasbihHistory,
            onPressed: () => context.push(AppRoutes.tasbihHistory),
          ),
        ],
      ),
      body: Column(
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
                    onTap: () => unawaited(
                      ref.read(tasbihViewModelProvider.notifier).increment(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          TasbihBottomControls(state: state),
        ],
      ),
    );
  }
}
