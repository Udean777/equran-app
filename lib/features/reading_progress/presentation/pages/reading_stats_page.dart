import 'dart:async';

import 'package:equran_app/core/widgets/error_state_widget.dart';
import 'package:equran_app/core/widgets/loading_widget.dart';
import 'package:equran_app/core/widgets/luxury_app_bar.dart';
import 'package:equran_app/features/quran_reminder/presentation/providers.dart';
import 'package:equran_app/features/reading_progress/domain/entities/reading_history.dart';
import 'package:equran_app/features/reading_progress/presentation/constants/reading_progress_strings.dart';
import 'package:equran_app/features/reading_progress/presentation/providers.dart';
import 'package:equran_app/features/reading_progress/presentation/viewmodels/reading_progress_state.dart';
import 'package:equran_app/features/reading_progress/presentation/widgets/juz_progress_section.dart';
import 'package:equran_app/features/reading_progress/presentation/widgets/reading_heatmap.dart';
import 'package:equran_app/features/reading_progress/presentation/widgets/reading_stats_header_card.dart';
import 'package:equran_app/features/reading_progress/presentation/widgets/top_surat_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReadingStatsPage extends ConsumerStatefulWidget {
  const ReadingStatsPage({super.key});

  @override
  ConsumerState<ReadingStatsPage> createState() => _ReadingStatsPageState();
}

class _ReadingStatsPageState extends ConsumerState<ReadingStatsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(ref.read(readingProgressViewModelProvider.notifier).load());
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(readingProgressViewModelProvider);

    return Scaffold(
      appBar: const LuxuryAppBar(title: ReadingProgressStrings.title),
      body: state.when(
        initial: LoadingWidget.new,
        loading: LoadingWidget.new,
        failure: (message) => ErrorStateWidget(
          message: message,
          onRetry: () =>
              ref.read(readingProgressViewModelProvider.notifier).load(),
        ),
        success: (stats) => _ReadingStatsContent(stats: stats),
      ),
    );
  }
}

class _ReadingStatsContent extends ConsumerWidget {
  const _ReadingStatsContent({required this.stats});

  final ReadingStats stats;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streak =
        ref
            .watch(quranStreakViewModelProvider)
            .mapOrNull(
              loaded: (s) => s.streak,
            ) ??
        0;

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
