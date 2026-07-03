import 'package:equran_app/core/providers.dart';
import 'package:equran_app/features/statistik_shalat/data/datasources/shalat_log_local_data_source.dart';
import 'package:equran_app/features/statistik_shalat/data/repositories/statistik_shalat_repository_impl.dart';
import 'package:equran_app/features/statistik_shalat/domain/entities/shalat_badge.dart';
import 'package:equran_app/features/statistik_shalat/domain/entities/shalat_log.dart';
import 'package:equran_app/features/statistik_shalat/domain/repositories/statistik_shalat_repository.dart';
import 'package:equran_app/features/statistik_shalat/domain/services/shalat_recap_notification_service.dart';
import 'package:equran_app/features/statistik_shalat/domain/services/shalat_stats_calculator.dart';
import 'package:equran_app/features/statistik_shalat/domain/usecases/delete_shalat_by_date.dart';
import 'package:equran_app/features/statistik_shalat/domain/usecases/get_shalat_by_date.dart';
import 'package:equran_app/features/statistik_shalat/domain/usecases/get_shalat_stats.dart';
import 'package:equran_app/features/statistik_shalat/domain/usecases/save_shalat_log.dart';
import 'package:equran_app/features/statistik_shalat/presentation/viewmodels/statistik_shalat_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// =============================================================================
// DATA SOURCE PROVIDER
// =============================================================================

final shalatLogLocalDataSourceProvider = Provider<ShalatLogLocalDataSource>((
  ref,
) {
  return ShalatLogLocalDataSourceImpl(ref.watch(statistikShalatBoxProvider));
});

// =============================================================================
// REPOSITORY PROVIDER
// =============================================================================

final statistikShalatRepositoryProvider = Provider<StatistikShalatRepository>((
  ref,
) {
  final dataSource = ref.watch(shalatLogLocalDataSourceProvider);
  return StatistikShalatRepositoryImpl(dataSource);
});

// =============================================================================
// SERVICE PROVIDER
// =============================================================================

final shalatStatsCalculatorProvider = Provider<ShalatStatsCalculator>((ref) {
  return const ShalatStatsCalculator();
});

final shalatRecapNotificationServiceProvider =
    Provider<ShalatRecapNotificationService>((ref) {
      return ShalatRecapNotificationService(
        ref.watch(notificationServiceProvider),
        ref.watch(settingsBoxProvider),
        ref.watch(getShalatByDateProvider),
      );
    });

// =============================================================================
// USE CASE PROVIDERS
// =============================================================================

final getShalatByDateProvider = Provider<GetShalatByDate>((ref) {
  final repository = ref.watch(statistikShalatRepositoryProvider);
  return GetShalatByDate(repository);
});

final getShalatStatsProvider = Provider<GetShalatStats>((ref) {
  final repository = ref.watch(statistikShalatRepositoryProvider);
  final calculator = ref.watch(shalatStatsCalculatorProvider);
  return GetShalatStats(repository, calculator);
});

final saveShalatLogProvider = Provider<SaveShalatLog>((ref) {
  final repository = ref.watch(statistikShalatRepositoryProvider);
  return SaveShalatLog(repository);
});

final deleteShalatByDateProvider = Provider<DeleteShalatByDate>((ref) {
  final repository = ref.watch(statistikShalatRepositoryProvider);
  return DeleteShalatByDate(repository);
});

// =============================================================================
// VIEWMODEL PROVIDER
// =============================================================================

final AutoDisposeNotifierProvider<
  StatistikShalatViewModel,
  StatistikShalatState
>
statistikShalatViewModelProvider =
    NotifierProvider.autoDispose<
      StatistikShalatViewModel,
      StatistikShalatState
    >(
      StatistikShalatViewModel.new,
    );

// =============================================================================
// BADGES PROVIDER (computed on-the-fly from stats state)
// =============================================================================

final badgesProvider = Provider<List<BadgeType>>((ref) {
  final state = ref.watch(statistikShalatViewModelProvider);
  return state.maybeWhen(
    success: (today, stats) => _computeBadges(
      stats.streak,
      stats.persentaseTepatWaktu,
      stats.dailyStats,
    ),
    orElse: () => [],
  );
});

final streakCountProvider = Provider<int>((ref) {
  final state = ref.watch(statistikShalatViewModelProvider);
  return state.maybeWhen(
    success: (today, stats) => stats.streak,
    orElse: () => 0,
  );
});

List<BadgeType> _computeBadges(
  int streak,
  double persentase,
  List<ShalatDayStats> dailyStats,
) {
  final badges = <BadgeType>{};

  if (dailyStats.any((d) => d.hasData)) {
    badges.add(BadgeType.pertamaKali);
  }

  if (streak >= 7) badges.add(BadgeType.konsisten7);
  if (streak >= 30) badges.add(BadgeType.konsisten30);

  if (persentase >= 0.7 && dailyStats.any((d) => d.hasData)) {
    badges.add(BadgeType.tepatWaktu70);
  }

  final todayStats = dailyStats.isNotEmpty ? dailyStats.last : null;
  if (todayStats != null && todayStats.isSempurna) {
    badges.add(BadgeType.sempurnaHariIni);
  }

  if (dailyStats.any(
    (d) => d.logs.values.any((l) => l.status == ShalatStatus.qadha),
  )) {
    badges.add(BadgeType.qadhaPertama);
  }

  final subuhConsecutive = _countConsecutiveSubuh(dailyStats);
  if (subuhConsecutive >= 7) badges.add(BadgeType.pejuangSubuh7);

  final last7NoMiss =
      dailyStats.length >= 7 &&
      dailyStats.reversed.take(7).every((d) {
        final subuh = d.logFor(WaktuShalat.subuh);
        return subuh.status == ShalatStatus.tepatWaktu;
      });
  if (last7NoMiss) badges.add(BadgeType.allSubuh);

  return badges.toList();
}

int _countConsecutiveSubuh(List<ShalatDayStats> dailyStats) {
  var count = 0;
  for (final day in dailyStats.reversed) {
    final subuh = day.logFor(WaktuShalat.subuh);
    if (subuh.status != ShalatStatus.tepatWaktu) break;
    count++;
  }
  return count;
}
