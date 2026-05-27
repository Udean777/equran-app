import 'dart:async';

import 'package:equran_app/core/widgets/error_state_widget.dart';
import 'package:equran_app/core/widgets/loading_widget.dart';
import 'package:equran_app/core/widgets/luxury_app_bar.dart';
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
      appBar: const LuxuryAppBar(title: 'Statistik Bacaan'),
      body: BlocBuilder<ReadingProgressCubit, ReadingProgressState>(
        builder: (context, state) => state.when(
          initial: () => const LoadingWidget(),
          loading: () => const LoadingWidget(),
          failure: (message) => ErrorStateWidget(
            message: message,
            onRetry: context.read<ReadingProgressCubit>().load,
          ),
          success: (stats) => _ReadingStatsContent(stats: stats),
        ),
      ),
    );
  }
}

class _ReadingStatsContent extends StatelessWidget {
  const _ReadingStatsContent({required this.stats});

  final ReadingStats stats;

  @override
  Widget build(BuildContext context) {
    final streak = context.watch<QuranStreakCubit>().state.mapOrNull(loaded: (s) => s.streak) ?? 0;

    return ListView(
      padding: const EdgeInsets.only(bottom: 32),
      children: [
        ReadingStatsHeaderCard(stats: stats, streak: streak),
        ReadingHeatmap(last90Days: stats.last90Days),
        JuzProgressSection(progressPerJuz: stats.progressPerJuz),
        TopSuratSection(topSurat: stats.topSurat),
      ],
    );
  }
}
