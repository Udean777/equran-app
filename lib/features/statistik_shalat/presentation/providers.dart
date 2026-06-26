import 'package:equran_app/core/providers.dart';
import 'package:equran_app/features/statistik_shalat/data/datasources/shalat_log_local_data_source.dart';
import 'package:equran_app/features/statistik_shalat/data/repositories/statistik_shalat_repository_impl.dart';
import 'package:equran_app/features/statistik_shalat/domain/repositories/statistik_shalat_repository.dart';
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
