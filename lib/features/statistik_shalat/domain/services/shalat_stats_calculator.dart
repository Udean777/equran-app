import 'package:equran_app/features/statistik_shalat/domain/entities/shalat_log.dart';
import 'package:equran_app/features/statistik_shalat/presentation/constants/statistik_shalat_constants.dart';
import 'package:intl/intl.dart';

class ShalatStatsCalculator {
  const ShalatStatsCalculator();

  static final _dateFormat = DateFormat('yyyy-MM-dd');

  /// Hitung statistik dari range tanggal.
  ShalatStats calculateStats({
    required List<String> dates,
    required String today,
    required List<ShalatDayStats> allDayStats,
  }) {
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

    final streak = _computeStreak(today, dates, statsMap);

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

  /// Hitung streak dari data yang sudah ada di memory.
  int _computeStreak(
    String today,
    List<String> dates,
    Map<String, ShalatDayStats> statsMap,
  ) {
    final dateSet = dates.toSet();
    var streak = 0;
    var current = today;

    while (dateSet.contains(current)) {
      final day = statsMap[current];
      if (day == null || !day.hasData) break;
      streak++;
      final date = DateTime.parse(current);
      current = _dateFormat.format(date.subtract(const Duration(days: 1)));
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
