import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/widgets/error_state_widget.dart';
import 'package:equran_app/core/widgets/loading_widget.dart';
import 'package:equran_app/features/quran_reminder/presentation/cubit/quran_streak_cubit.dart';
import 'package:equran_app/features/reading_progress/domain/entities/reading_history.dart';
import 'package:equran_app/features/reading_progress/presentation/cubit/reading_progress_cubit.dart';
import 'package:equran_app/features/reading_progress/presentation/widgets/juz_progress_section.dart';
import 'package:equran_app/features/reading_progress/presentation/widgets/reading_heatmap.dart';
import 'package:equran_app/features/reading_progress/presentation/widgets/reading_stats_header_card.dart';
import 'package:equran_app/features/reading_progress/presentation/widgets/top_surat_section.dart';
import 'package:equran_app/injection/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReadingStatsPage extends StatelessWidget {
  const ReadingStatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = getIt<ReadingProgressCubit>();
        unawaited(cubit.load());
        return cubit;
      },
      child: const _ReadingStatsView(),
    );
  }
}

class _ReadingStatsView extends StatelessWidget {
  const _ReadingStatsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistik Baca'),
      ),
      body: BlocBuilder<ReadingProgressCubit, ReadingProgressState>(
        builder: (context, state) {
          return state.when(
            initial: () => const LoadingWidget(),
            loading: () => const LoadingWidget(),
            failure: (message) => ErrorStateWidget(
              message: message,
              onRetry: () => context.read<ReadingProgressCubit>().load(),
            ),
            success: (stats) => _SuccessView(stats: stats),
          );
        },
      ),
    );
  }
}

class _SuccessView extends StatelessWidget {
  const _SuccessView({required this.stats});

  final ReadingStats stats;

  @override
  Widget build(BuildContext context) {
    final streak = context.watch<QuranStreakCubit>().state;

    if (stats.isEmpty) {
      return _EmptyView(streak: streak);
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async => context.read<ReadingProgressCubit>().load(),
      child: ListView(
        children: [
          ReadingStatsHeaderCard(stats: stats, streak: streak),
          ReadingHeatmap(last90Days: stats.last90Days),
          JuzProgressSection(progressPerJuz: stats.progressPerJuz),
          if (stats.topSurat.isNotEmpty)
            TopSuratSection(topSurat: stats.topSurat),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.streak});

  final int streak;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.menu_book_outlined,
              size: 72,
              color: AppColors.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Belum Ada Data',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Mulai membaca Al-Quran untuk melihat statistik progress kamu.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            if (streak > 0) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.local_fire_department_rounded,
                      color: Colors.orange,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$streak hari streak',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
