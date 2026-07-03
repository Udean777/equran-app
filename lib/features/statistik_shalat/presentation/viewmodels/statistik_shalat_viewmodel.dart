import 'dart:async';

import 'package:equran_app/core/utils/failure_extension.dart';
import 'package:equran_app/core/widgets/shalat_widget.dart';
import 'package:equran_app/features/jadwal_shalat/domain/entities/jadwal_shalat_entry.dart';
import 'package:equran_app/features/jadwal_shalat/presentation/providers.dart';

import 'package:equran_app/features/statistik_shalat/domain/entities/shalat_log.dart';
import 'package:equran_app/features/statistik_shalat/domain/services/shalat_recap_notification_service.dart';
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

class StatistikShalatViewModel
    extends AutoDisposeNotifier<StatistikShalatState> {
  @override
  StatistikShalatState build() => const StatistikShalatState.initial();

  GetShalatByDate get _getShalatByDate => ref.read(getShalatByDateProvider);
  GetShalatStats get _getShalatStats => ref.read(getShalatStatsProvider);
  SaveShalatLog get _saveShalatLog => ref.read(saveShalatLogProvider);
  DeleteShalatByDate get _deleteShalatByDate =>
      ref.read(deleteShalatByDateProvider);
  ShalatRecapNotificationService get _recapNotificationService =>
      ref.read(shalatRecapNotificationServiceProvider);

  static final _dateFormat = DateFormat('yyyy-MM-dd');

  Future<void> load() async {
    state = const StatistikShalatState.loading();

    final today = _dateFormat.format(DateTime.now());

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
          final jadwalState = ref.read(jadwalShalatViewModelProvider);
          Map<String, String>? jadwalMap;
          if (jadwalState is JadwalShalatSuccess) {
            final todayJadwal = jadwalState.jadwal.entryByTanggal(
              DateTime.now().day,
            );
            if (todayJadwal != null) {
              String cleanTime(String t) =>
                  t.replaceAll(RegExp('[^0-9:]'), '').trim();
              jadwalMap = {
                'subuh': cleanTime(todayJadwal.subuh),
                'dzuhur': cleanTime(todayJadwal.dzuhur),
                'ashar': cleanTime(todayJadwal.ashar),
                'maghrib': cleanTime(todayJadwal.maghrib),
                'isya': cleanTime(todayJadwal.isya),
              };
            }
          }

          unawaited(
            updateShalatWidget(
              todayStats ?? ShalatDayStats(date: today),
              StatistikShalatConstants.totalWaktuShalat,
              jadwalMap,
            ),
          );
          unawaited(
            _recapNotificationService.updateSchedule(
              todayStats ?? ShalatDayStats(date: today),
            ),
          );
        },
      ),
    );
  }

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

  bool _hasAutoMarked = false;

  Future<void> autoMarkMissedPrayers(JadwalShalatEntry todayJadwal) async {
    if (_hasAutoMarked) return;
    _hasAutoMarked = true;

    final today = _dateFormat.format(DateTime.now());
    final result = await _getShalatByDate(today);

    await result.fold((_) async {}, (todayStats) async {
      final stats = todayStats ?? ShalatDayStats(date: today);
      var hasChanges = false;
      final now = DateTime.now();

      final times = [
        todayJadwal.subuh,
        todayJadwal.dzuhur,
        todayJadwal.ashar,
        todayJadwal.maghrib,
        todayJadwal.isya,
      ];

      for (var i = 0; i < WaktuShalat.values.length; i++) {
        final waktu = WaktuShalat.values[i];
        final log = stats.logFor(waktu);

        if (log.status == ShalatStatus.belumDicatat) {
          if (i < 4) {
            final nextTimeStr = times[i + 1];
            final timeParts = nextTimeStr.split(':');
            if (timeParts.length == 2) {
              final nextHour = int.tryParse(timeParts[0]) ?? 0;
              final nextMinute = int.tryParse(timeParts[1]) ?? 0;
              final nextPrayerTime = DateTime(
                now.year,
                now.month,
                now.day,
                nextHour,
                nextMinute,
              );

              if (now.isAfter(nextPrayerTime)) {
                await _saveShalatLog(
                  ShalatLog(
                    date: today,
                    waktu: waktu,
                    status: ShalatStatus.tidakShalat,
                    updatedAt: DateTime.now(),
                  ),
                );
                hasChanges = true;
              }
            }
          }
        }
      }
      if (hasChanges) {
        unawaited(load());
      }
    });
  }
}
