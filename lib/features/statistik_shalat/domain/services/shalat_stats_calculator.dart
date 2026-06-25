import 'package:equran_app/features/statistik_shalat/data/datasources/shalat_log_local_data_source.dart';
import 'package:equran_app/features/statistik_shalat/domain/entities/shalat_log.dart';
import 'package:equran_app/features/statistik_shalat/presentation/constants/statistik_shalat_constants.dart';
import 'package:intl/intl.dart';

class ShalatStatsCalculator {
  const ShalatStatsCalculator(this._dataSource);
  final ShalatLogLocalDataSource _dataSource;

  static final _dateFormat = DateFormat('yyyy-MM-dd');

  /// Hitung statistik dari range tanggal.
  Future<ShalatStats> calculateStats({
    required List<String> dates,
    required String today,
    required List<ShalatDayStats> allDayStats,
  }) async {
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
    final persentase = totalDicatat == 0 ? 0.0 : totalTepatWaktu / totalDicatat;

    // Hitung streak: hari berturut-turut dengan minimal 1 shalat dicatat
    final streak = await computeStreak(today);

    // 7 hari terakhir untuk chart
    final last7 = getLast7Days(
      today,
    ).map((d) => statsMap[d] ?? ShalatDayStats(date: d)).toList();

    return ShalatStats(
      totalHariDenganData: totalHariDenganData,
      totalTepatWaktu: totalTepatWaktu,
      totalQadha: totalQadha,
      totalTidakShalat: totalTidakShalat,
      streak: streak,
      persentaseTepatWaktu: persentase.clamp(0.0, 1.0),
      dailyStats: last7,
    );
  }

  /// Hitung streak: berapa hari berturut-turut dengan minimal 1 shalat dicatat.
  Future<int> computeStreak(String today) async {
    var streak = 0;
    var current = DateTime.parse(today);

    while (true) {
      final dateStr = _dateFormat.format(current);
      final day = await _dataSource.getByDate(dateStr);

      if (day == null || !day.hasData) break;
      streak++;
      current = current.subtract(const Duration(days: 1));
    }

    return streak;
  }

  /// Generate list 7 hari terakhir (termasuk today), ascending.
  List<String> getLast7Days(String today) {
    final base = DateTime.parse(today);
    return List.generate(
      StatistikShalatConstants.weeklyChartDays,
      (i) => _dateFormat.format(
        base.subtract(
          Duration(days: StatistikShalatConstants.weeklyChartDays - 1 - i),
        ),
      ),
    );
  }
}
