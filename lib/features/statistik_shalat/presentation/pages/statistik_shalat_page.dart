import 'dart:async';

import 'package:equran_app/core/router/app_routes.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/utils/bottom_sheet_utils.dart';
import 'package:equran_app/core/widgets/error_state_widget.dart';
import 'package:equran_app/core/widgets/loading_widget.dart';
import 'package:equran_app/core/widgets/luxury_app_bar.dart';
import 'package:equran_app/features/jadwal_shalat/domain/entities/jadwal_shalat_entry.dart';
import 'package:equran_app/features/jadwal_shalat/presentation/providers.dart';
import 'package:equran_app/features/statistik_shalat/domain/entities/shalat_log.dart';
import 'package:equran_app/features/statistik_shalat/presentation/constants/statistik_shalat_strings.dart';
import 'package:equran_app/features/statistik_shalat/presentation/providers.dart';
import 'package:equran_app/features/statistik_shalat/presentation/viewmodels/statistik_shalat_viewmodel.dart';
import 'package:equran_app/features/statistik_shalat/presentation/widgets/shalat_calendar_section.dart';
import 'package:equran_app/features/statistik_shalat/presentation/widgets/shalat_checklist_section.dart';
import 'package:equran_app/features/statistik_shalat/presentation/widgets/shalat_detail_sheet.dart';
import 'package:equran_app/features/statistik_shalat/presentation/widgets/shalat_streak_card.dart';
import 'package:equran_app/features/statistik_shalat/presentation/widgets/shalat_weekly_stats_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class StatistikShalatPage extends ConsumerStatefulWidget {
  const StatistikShalatPage({super.key});

  @override
  ConsumerState<StatistikShalatPage> createState() =>
      _StatistikShalatPageState();
}

class _StatistikShalatPageState extends ConsumerState<StatistikShalatPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(ref.read(statistikShalatViewModelProvider.notifier).load());
      unawaited(ref.read(jadwalShalatViewModelProvider.notifier).init());
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(statistikShalatViewModelProvider);
    final jadwalState = ref.watch(jadwalShalatViewModelProvider);

    JadwalShalatEntry? todayJadwal;
    if (jadwalState is JadwalShalatSuccess) {
      todayJadwal = jadwalState.jadwal.entryByTanggal(DateTime.now().day);
      if (todayJadwal != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            unawaited(
              ref
                  .read(statistikShalatViewModelProvider.notifier)
                  .autoMarkMissedPrayers(todayJadwal!),
            );
          }
        });
      }
    }

    return Scaffold(
      appBar: LuxuryAppBar(
        title: StatistikShalatStrings.pageTitle,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () =>
              context.canPop() ? context.pop() : context.go(AppRoutes.home),
        ),
      ),
      body: state.when(
        initial: () => const LoadingWidget(),
        loading: () => const LoadingWidget(),
        failure: (message) => ErrorStateWidget(
          message: message,
          onRetry: ref.read(statistikShalatViewModelProvider.notifier).load,
        ),
        success: (today, stats) => _StatistikContent(
          today: today,
          stats: stats,
          todayJadwal: todayJadwal,
        ),
      ),
    );
  }
}

class _StatistikContent extends ConsumerWidget {
  const _StatistikContent({
    required this.today,
    required this.stats,
    required this.todayJadwal,
  });

  final ShalatDayStats today;
  final ShalatStats stats;
  final JadwalShalatEntry? todayJadwal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.only(bottom: AppDimens.spaceXL),
      children: [
        ShalatStreakCard(streak: stats.streak, today: today),
        // Checklist langsung di bawah streak card — primary action pertama dilihat
        ShalatChecklistSection(
          today: today,
          todayJadwal: todayJadwal,
          onStatusChanged: (waktu, status) => unawaited(
            ref
                .read(statistikShalatViewModelProvider.notifier)
                .updateShalat(
                  waktu: waktu,
                  status: status,
                ),
          ),
        ),

        const SizedBox(height: AppDimens.spaceSM),

        ShalatCalendarSection(
          statsByDate: {
            for (final d in stats.dailyStats) d.date: d,
          },
          onDayTap: (date, dayStats) =>
              _showDetail(context, ref, date, dayStats),
        ),

        const SizedBox(height: AppDimens.spaceSM),

        ShalatWeeklyStatsSection(
          dailyStats: stats.dailyStats,
          totalTepatWaktu: stats.totalTepatWaktu,
          totalQadha: stats.totalQadha,
          totalTidakShalat: stats.totalTidakShalat,
          persentaseTepatWaktu: stats.persentaseTepatWaktu,
        ),
      ],
    );
  }

  void _showDetail(
    BuildContext context,
    WidgetRef ref,
    DateTime date,
    ShalatDayStats dayStats,
  ) {
    unawaited(
      showAppBottomSheet<void>(
        context,
        builder: (_) => ShalatDetailSheet(date: date, dayStats: dayStats),
      ),
    );
  }
}
