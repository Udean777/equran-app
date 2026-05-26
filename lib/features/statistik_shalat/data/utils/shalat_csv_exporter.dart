import 'dart:io';

import 'package:equran_app/features/statistik_shalat/domain/entities/shalat_log.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

abstract final class ShalatCsvExporter {
  static final _dateFormat = DateFormat('yyyy-MM-dd');
  static final _displayFormat = DateFormat('d MMMM yyyy', 'id_ID');

  /// Generate dan share CSV dari list [dayStatsList].
  static Future<void> exportAndShare(
    List<ShalatDayStats> dayStatsList,
  ) async {
    final csv = _generateCsv(dayStatsList);
    final file = await _saveTempFile(csv);
    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'text/csv')],
      subject: 'Statistik Shalat eQuran',
      text: 'Data statistik shalat dari eQuran App',
    );
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────────

  static String _generateCsv(List<ShalatDayStats> dayStatsList) {
    final buffer = StringBuffer()
      ..writeln(
        'Tanggal,Hari,Subuh,Dzuhur,Ashar,Maghrib,Isya,'
        'Total Tepat Waktu,Total Qadha,Total Tidak Shalat',
      );

    // Sort ascending by date
    final sorted = List<ShalatDayStats>.from(dayStatsList)
      ..sort((a, b) => a.date.compareTo(b.date));
    for (final day in sorted) {
      final date = DateTime.tryParse(day.date);
      if (date == null) continue;

      final tanggal = _displayFormat.format(date);
      final hari = DateFormat('EEEE', 'id_ID').format(date);

      final subuh = _statusLabel(day.logFor(WaktuShalat.subuh).status);
      final dzuhur = _statusLabel(day.logFor(WaktuShalat.dzuhur).status);
      final ashar = _statusLabel(day.logFor(WaktuShalat.ashar).status);
      final maghrib = _statusLabel(day.logFor(WaktuShalat.maghrib).status);
      final isya = _statusLabel(day.logFor(WaktuShalat.isya).status);

      buffer.writeln(
        '$tanggal,$hari,$subuh,$dzuhur,$ashar,$maghrib,$isya,'
        '${day.jumlahTepatWaktu},${day.jumlahQadha},'
        '${day.logs.values.where((l) => l.status == ShalatStatus.tidakShalat).length}',
      );
    }

    return buffer.toString();
  }

  static Future<File> _saveTempFile(String content) async {
    final dir = await getTemporaryDirectory();
    final now = _dateFormat.format(DateTime.now());
    final file = File('${dir.path}/statistik_shalat_$now.csv');
    await file.writeAsString(content, flush: true);
    return file;
  }

  static String _statusLabel(ShalatStatus status) {
    switch (status) {
      case ShalatStatus.tepatWaktu:
        return 'Tepat Waktu';
      case ShalatStatus.qadha:
        return 'Qadha';
      case ShalatStatus.tidakShalat:
        return 'Tidak Shalat';
      case ShalatStatus.belumDicatat:
        return '-';
    }
  }
}
