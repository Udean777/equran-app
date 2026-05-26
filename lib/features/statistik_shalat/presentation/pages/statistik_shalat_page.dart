import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/widgets/error_state_widget.dart';
import 'package:equran_app/core/widgets/loading_widget.dart';
import 'package:equran_app/features/statistik_shalat/data/utils/shalat_csv_exporter.dart';
import 'package:equran_app/features/statistik_shalat/domain/entities/shalat_log.dart';
import 'package:equran_app/features/statistik_shalat/presentation/cubit/statistik_shalat_cubit.dart';
import 'package:equran_app/features/statistik_shalat/presentation/widgets/shalat_calendar_section.dart';
import 'package:equran_app/features/statistik_shalat/presentation/widgets/shalat_checklist_section.dart';
import 'package:equran_app/features/statistik_shalat/presentation/widgets/shalat_detail_sheet.dart';
import 'package:equran_app/features/statistik_shalat/presentation/widgets/shalat_streak_card.dart';
import 'package:equran_app/features/statistik_shalat/presentation/widgets/shalat_weekly_stats_section.dart';
import 'package:equran_app/injection/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatistikShalatPage extends StatelessWidget {
  const StatistikShalatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = getIt<StatistikShalatCubit>();
        unawaited(cubit.load());
        return cubit;
      },
      child: const _StatistikShalatView(),
    );
  }
}

class _StatistikShalatView extends StatelessWidget {
  const _StatistikShalatView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistik Shalat'),
        actions: [
          BlocBuilder<StatistikShalatCubit, StatistikShalatState>(
            builder: (context, state) {
              final hasData = state.maybeWhen(
                success: (today, stats) => stats.totalHariDenganData > 0,
                orElse: () => false,
              );
              if (!hasData) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.download_rounded),
                tooltip: 'Export CSV',
                onPressed: () => _onExport(context, state),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<StatistikShalatCubit, StatistikShalatState>(
        builder: (context, state) {
          return state.when(
            initial: () => const LoadingWidget(),
            loading: () => const LoadingWidget(),
            failure: (message) => ErrorStateWidget(
              message: message,
              onRetry: () => context.read<StatistikShalatCubit>().load(),
            ),
            success: (today, stats) => _SuccessView(
              today: today,
              stats: stats,
            ),
          );
        },
      ),
    );
  }

  void _onExport(BuildContext context, StatistikShalatState state) {
    state.maybeWhen(
      success: (today, stats) {
        final allDays = <ShalatDayStats>[
          ...stats.dailyStats,
          if (!stats.dailyStats.any((d) => d.date == today.date)) today,
        ];
        unawaited(ShalatCsvExporter.exportAndShare(allDays));
      },
      orElse: () {},
    );
  }
}

class _SuccessView extends StatelessWidget {
  const _SuccessView({
    required this.today,
    required this.stats,
  });

  final ShalatDayStats today;
  final ShalatStats stats;

  @override
  Widget build(BuildContext context) {
    // Build map untuk kalender
    final statsByDate = <String, ShalatDayStats>{};
    for (final day in stats.dailyStats) {
      if (day.hasData) statsByDate[day.date] = day;
    }
    if (today.hasData) statsByDate[today.date] = today;

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async => context.read<StatistikShalatCubit>().load(),
      child: ListView(
        children: [
          // Header streak + progress hari ini
          ShalatStreakCard(
            streak: stats.streak,
            today: today,
          ),

          // Checklist 5 waktu hari ini
          ShalatChecklistSection(
            today: today,
            onStatusChanged: (waktu, status) {
              unawaited(
                context.read<StatistikShalatCubit>().updateShalat(
                  waktu: waktu,
                  status: status,
                ),
              );
            },
          ),

          const SizedBox(height: AppDimens.spaceSM),

          // Statistik mingguan + bar chart
          ShalatWeeklyStatsSection(
            dailyStats: stats.dailyStats,
            totalTepatWaktu: stats.totalTepatWaktu,
            totalQadha: stats.totalQadha,
            totalTidakShalat: stats.totalTidakShalat,
            persentaseTepatWaktu: stats.persentaseTepatWaktu,
          ),

          const SizedBox(height: AppDimens.spaceSM),

          // Kalender bulanan
          ShalatCalendarSection(
            statsByDate: statsByDate,
            onDayTap: (date, dayStats) {
              unawaited(
                ShalatDetailSheet.show(
                  context: context,
                  date: date,
                  dayStats: dayStats,
                ),
              );
            },
          ),

          const SizedBox(height: AppDimens.spaceLG),
        ],
      ),
    );
  }
}
