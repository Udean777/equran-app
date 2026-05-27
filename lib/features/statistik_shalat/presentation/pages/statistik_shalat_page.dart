import 'dart:async';

import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/utils/bottom_sheet_utils.dart';
import 'package:equran_app/core/widgets/error_state_widget.dart';
import 'package:equran_app/core/widgets/loading_widget.dart';
import 'package:equran_app/core/widgets/luxury_app_bar.dart';
import 'package:equran_app/core/widgets/section_header.dart';
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
      appBar: const LuxuryAppBar(title: 'Statistik Shalat'),
      body: BlocBuilder<StatistikShalatCubit, StatistikShalatState>(
        builder: (context, state) => state.when(
          initial: () => const LoadingWidget(),
          loading: () => const LoadingWidget(),
          failure: (message) => ErrorStateWidget(
            message: message,
            onRetry: context.read<StatistikShalatCubit>().load,
          ),
          success: (today, stats) =>
              _StatistikContent(today: today, stats: stats),
        ),
      ),
    );
  }
}

class _StatistikContent extends StatelessWidget {
  const _StatistikContent({
    required this.today,
    required this.stats,
  });

  final ShalatDayStats today;
  final ShalatStats stats;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: AppDimens.spaceXL),
      children: [
        ShalatStreakCard(streak: stats.streak, today: today),
        const SectionHeader(
          label: 'Kalender',
          icon: Icons.calendar_month_rounded,
        ),
        ShalatCalendarSection(
          statsByDate: {
            for (final d in stats.dailyStats) d.date: d,
          },
          onDayTap: (date, dayStats) => _showDetail(context, date, dayStats),
        ),
        const SectionHeader(
          label: 'Statistik Mingguan',
          icon: Icons.bar_chart_rounded,
        ),
        ShalatWeeklyStatsSection(
          dailyStats: stats.dailyStats,
          totalTepatWaktu: stats.totalTepatWaktu,
          totalQadha: stats.totalQadha,
          totalTidakShalat: stats.totalTidakShalat,
          persentaseTepatWaktu: stats.persentaseTepatWaktu,
        ),
        const SectionHeader(
          label: 'Checklist Hari Ini',
          icon: Icons.checklist_rounded,
        ),
        ShalatChecklistSection(
          today: today,
          onStatusChanged: (waktu, status) => unawaited(
            context.read<StatistikShalatCubit>().updateShalat(
              waktu: waktu,
              status: status,
            ),
          ),
        ),
      ],
    );
  }

  void _showDetail(
    BuildContext context,
    DateTime date,
    ShalatDayStats dayStats,
  ) {
    unawaited(
      showAppBottomSheet<void>(
        context,
        builder: (_) => BlocProvider.value(
          value: context.read<StatistikShalatCubit>(),
          child: ShalatDetailSheet(date: date, dayStats: dayStats),
        ),
      ),
    );
  }
}
