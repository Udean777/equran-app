import 'dart:async';

import 'package:equran_app/core/utils/failure_extension.dart';
import 'package:equran_app/core/widgets/shalat_widget.dart';
import 'package:equran_app/features/statistik_shalat/domain/entities/shalat_log.dart';
import 'package:equran_app/features/statistik_shalat/domain/usecases/delete_shalat_by_date.dart';
import 'package:equran_app/features/statistik_shalat/domain/usecases/get_shalat_by_date.dart';
import 'package:equran_app/features/statistik_shalat/domain/usecases/get_shalat_stats.dart';
import 'package:equran_app/features/statistik_shalat/domain/usecases/params/get_shalat_stats_params.dart';
import 'package:equran_app/features/statistik_shalat/domain/usecases/save_shalat_log.dart';
import 'package:equran_app/features/statistik_shalat/presentation/constants/statistik_shalat_constants.dart';
import 'package:equran_app/features/statistik_shalat/presentation/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'statistik_shalat_state.dart';
part 'statistik_shalat_viewmodel.freezed.dart';

class StatistikShalatViewModel extends StateNotifier<StatistikShalatState> {
  StatistikShalatViewModel(this._ref)
    : super(const StatistikShalatState.initial());

  final Ref _ref;

  GetShalatByDate get _getShalatByDate => _ref.read(getShalatByDateProvider);
  GetShalatStats get _getShalatStats => _ref.read(getShalatStatsProvider);
  SaveShalatLog get _saveShalatLog => _ref.read(saveShalatLogProvider);
  DeleteShalatByDate get _deleteShalatByDate =>
      _ref.read(deleteShalatByDateProvider);

  static final _dateFormat = DateFormat('yyyy-MM-dd');

  Future<void> load() async {
    state = const StatistikShalatState.loading();

    final today = _dateFormat.format(DateTime.now());

    // Sync any check-ins made via home screen widget
    await _syncWidgetCheckins(today);

    final last30 = _generateDateRange(
      today,
      StatistikShalatConstants.statsDaysRange,
    );

    final todayResult = await _getShalatByDate(today);
    final statsResult = await _getShalatStats(
      GetShalatStatsParams(dates: last30, today: today),
    );

    todayResult.fold(
      (failure) =>
          state = StatistikShalatState.failure(failure.toUserMessage()),
      (todayStats) => statsResult.fold(
        (failure) =>
            state = StatistikShalatState.failure(failure.toUserMessage()),
        (stats) {
          state = StatistikShalatState.success(
            today: todayStats ?? ShalatDayStats(date: today),
            stats: stats,
          );
          // Update home screen widget with latest data
          unawaited(
            updateShalatWidget(
              todayStats ?? ShalatDayStats(date: today),
              StatistikShalatConstants.totalWaktuShalat,
            ),
          );
        },
      ),
    );
  }

  /// Sync check-ins made via home screen widget to Hive storage.
  Future<void> _syncWidgetCheckins(String today) async {
    final widgetStatuses = await readWidgetCheckinStatuses();
    if (widgetStatuses == null) return;

    for (final entry in widgetStatuses.entries) {
      if (entry.value == 'belumDicatat') continue;
      try {
        final waktu = WaktuShalat.values.firstWhere(
          (e) => e.name == entry.key,
        );
        final status = _widgetStatusToShalatStatus(entry.value);
        if (status != null) {
          await _saveShalatLog(ShalatLog(
            date: today,
            waktu: waktu,
            status: status,
            updatedAt: DateTime.now(),
          ));
        }
      } on Object catch (_) {}
    }
  }

  ShalatStatus? _widgetStatusToShalatStatus(String s) => switch (s) {
    'tepatWaktu' => ShalatStatus.tepatWaktu,
    'qadha' => ShalatStatus.qadha,
    'tidakShalat' => ShalatStatus.tidakShalat,
    _ => null,
  };

  Future<void> updateShalat({
    required WaktuShalat waktu,
    required ShalatStatus status,
    String? catatan,
  }) async {
    final today = _dateFormat.format(DateTime.now());

    final log = ShalatLog(
      date: today,
      waktu: waktu,
      status: status,
      catatan: catatan,
      updatedAt: DateTime.now(),
    );

    final result = await _saveShalatLog(log);
    result.fold(
      (failure) => state = StatistikShalatState.failure(
        failure.toUserMessage(),
      ),
      (_) => load(),
    );
  }

  Future<void> updateShalatForDate({
    required String date,
    required WaktuShalat waktu,
    required ShalatStatus status,
    String? catatan,
  }) async {
    final log = ShalatLog(
      date: date,
      waktu: waktu,
      status: status,
      catatan: catatan,
      updatedAt: DateTime.now(),
    );

    final result = await _saveShalatLog(log);
    result.fold(
      (failure) => state = StatistikShalatState.failure(
        failure.toUserMessage(),
      ),
      (_) => load(),
    );
  }

  Future<void> deleteShalatForDate(String date) async {
    final result = await _deleteShalatByDate(date);
    result.fold(
      (failure) => state = StatistikShalatState.failure(
        failure.toUserMessage(),
      ),
      (_) => load(),
    );
  }

  List<String> _generateDateRange(String today, int days) {
    final base = DateTime.parse(today);
    return List.generate(
      days,
      (i) => _dateFormat.format(base.subtract(Duration(days: days - 1 - i))),
    );
  }
}
