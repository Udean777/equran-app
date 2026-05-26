import 'package:equran_app/core/utils/failure_extension.dart';
import 'package:equran_app/features/statistik_shalat/domain/entities/shalat_log.dart';
import 'package:equran_app/features/statistik_shalat/domain/usecases/get_shalat_by_date.dart';
import 'package:equran_app/features/statistik_shalat/domain/usecases/get_shalat_stats.dart';
import 'package:equran_app/features/statistik_shalat/domain/usecases/save_shalat_log.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

part 'statistik_shalat_cubit.freezed.dart';
part 'statistik_shalat_state.dart';

@injectable
class StatistikShalatCubit extends Cubit<StatistikShalatState> {
  StatistikShalatCubit(
    this._getShalatByDate,
    this._getShalatStats,
    this._saveShalatLog,
  ) : super(const StatistikShalatState.initial());

  final GetShalatByDate _getShalatByDate;
  final GetShalatStats _getShalatStats;
  final SaveShalatLog _saveShalatLog;

  static final _dateFormat = DateFormat('yyyy-MM-dd');

  // ─── Load ────────────────────────────────────────────────────────────────────

  /// Load data hari ini + statistik 30 hari terakhir.
  Future<void> load() async {
    emit(const StatistikShalatState.loading());

    final today = _dateFormat.format(DateTime.now());
    final last30 = _generateDateRange(today, 30);

    final todayResult = _getShalatByDate(today);
    final statsResult = _getShalatStats(dates: last30, today: today);

    todayResult.fold(
      (failure) => emit(StatistikShalatState.failure(failure.toUserMessage())),
      (todayStats) => statsResult.fold(
        (failure) =>
            emit(StatistikShalatState.failure(failure.toUserMessage())),
        (stats) => emit(
          StatistikShalatState.success(
            today: todayStats ?? ShalatDayStats(date: today),
            stats: stats,
          ),
        ),
      ),
    );
  }

  // ─── Save Log ────────────────────────────────────────────────────────────────

  /// Simpan/update status shalat untuk waktu tertentu hari ini.
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
      (failure) => emit(StatistikShalatState.failure(failure.toUserMessage())),
      (_) => load(), // reload setelah save
    );
  }

  /// Update shalat untuk tanggal tertentu (edit historis).
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
      (failure) => emit(StatistikShalatState.failure(failure.toUserMessage())),
      (_) => load(),
    );
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────────

  /// Generate list tanggal N hari terakhir (termasuk today), ascending.
  List<String> _generateDateRange(String today, int days) {
    final base = DateTime.parse(today);
    return List.generate(
      days,
      (i) => _dateFormat.format(base.subtract(Duration(days: days - 1 - i))),
    );
  }
}
