import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/statistik_shalat/data/datasources/shalat_log_local_data_source.dart';
import 'package:equran_app/features/statistik_shalat/domain/entities/shalat_log.dart';
import 'package:equran_app/features/statistik_shalat/domain/repositories/statistik_shalat_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

@LazySingleton(as: StatistikShalatRepository)
class StatistikShalatRepositoryImpl implements StatistikShalatRepository {
  const StatistikShalatRepositoryImpl(this._dataSource);

  final ShalatLogLocalDataSource _dataSource;

  static final _dateFormat = DateFormat('yyyy-MM-dd');

  @override
  Either<Failure, ShalatDayStats?> getByDate(String date) {
    try {
      return Right(_dataSource.getByDate(date));
    } on Object catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Either<Failure, List<ShalatDayStats>> getByDateRange(List<String> dates) {
    try {
      return Right(_dataSource.getByDateRange(dates));
    } on Object catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveLog(ShalatLog log) async {
    try {
      await _dataSource.saveLog(log);
      return const Right(unit);
    } on Object catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteByDate(String date) async {
    try {
      await _dataSource.deleteByDate(date);
      return const Right(unit);
    } on Object catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Either<Failure, ShalatStats> getStats({
    required List<String> dates,
    required String today,
  }) {
    try {
      final allDayStats = _dataSource.getByDateRange(dates);
      final statsMap = {for (final s in allDayStats) s.date: s};

      var totalTepatWaktu = 0;
      var totalQadha = 0;
      var totalTidakShalat = 0;
      var totalHariDenganData = 0;

      for (final date in dates) {
        final day = statsMap[date];
        if (day == null || !day.hasData) continue;
        totalHariDenganData++;
        totalTepatWaktu += day.jumlahTepatWaktu;
        totalQadha += day.jumlahQadha;
        totalTidakShalat += day.logs.values
            .where((l) => l.status == ShalatStatus.tidakShalat)
            .length;
      }

      final totalDicatat = totalTepatWaktu + totalQadha + totalTidakShalat;
      final persentase = totalDicatat == 0
          ? 0.0
          : totalTepatWaktu / totalDicatat;

      // Hitung streak: hari berturut-turut dengan 5 waktu shalat (tepatWaktu/qadha)
      final streak = _computeStreak(today);

      // 7 hari terakhir untuk chart
      final last7 = _getLast7Days(
        today,
      ).map((d) => statsMap[d] ?? ShalatDayStats(date: d)).toList();

      return Right(
        ShalatStats(
          totalHariDenganData: totalHariDenganData,
          totalTepatWaktu: totalTepatWaktu,
          totalQadha: totalQadha,
          totalTidakShalat: totalTidakShalat,
          streak: streak,
          persentaseTepatWaktu: persentase.clamp(0.0, 1.0),
          dailyStats: last7,
        ),
      );
    } on Object catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  // ─── Helpers ────────────────────────────────────────────────────────────────

  /// Hitung streak: berapa hari berturut-turut dengan minimal 1 shalat dicatat.
  int _computeStreak(String today) {
    var streak = 0;
    var current = DateTime.parse(today);

    while (true) {
      final dateStr = _dateFormat.format(current);
      final day = _dataSource.getByDate(dateStr);

      if (day == null || !day.hasData) break;
      streak++;
      current = current.subtract(const Duration(days: 1));
    }

    return streak;
  }

  /// Generate list 7 hari terakhir (termasuk today), ascending.
  List<String> _getLast7Days(String today) {
    final base = DateTime.parse(today);
    return List.generate(
      7,
      (i) => _dateFormat.format(base.subtract(Duration(days: 6 - i))),
    );
  }
}
