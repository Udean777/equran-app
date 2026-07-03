import 'dart:convert';

import 'package:equran_app/features/statistik_shalat/domain/entities/shalat_log.dart';
import 'package:home_widget/home_widget.dart';

class ShalatWidgetData {
  ShalatWidgetData({
    required this.date,
    required this.totalCount,
    required this.totalWaktu,
    required this.statuses,
    required this.jadwal,
  });

  factory ShalatWidgetData.fromDayStats(
    String date,
    int jumlahShalat,
    int totalWaktu,
    Map<String, String> statuses,
    Map<String, String> jadwal,
  ) {
    return ShalatWidgetData(
      date: date,
      totalCount: jumlahShalat,
      totalWaktu: totalWaktu,
      statuses: statuses,
      jadwal: jadwal,
    );
  }

  factory ShalatWidgetData.fromJson(String str) {
    final map = jsonDecode(str) as Map<String, dynamic>;
    return ShalatWidgetData(
      date: map['date'] as String? ?? '',
      totalCount: map['totalCount'] as int,
      totalWaktu: map['totalWaktu'] as int,
      statuses: Map<String, String>.from(map['statuses'] as Map),
      jadwal: map['jadwal'] != null
          ? Map<String, String>.from(map['jadwal'] as Map)
          : {},
    );
  }

  final String date;
  final int totalCount;
  final int totalWaktu;
  final Map<String, String> statuses;
  final Map<String, String> jadwal;

  String toJson() => jsonEncode({
    'date': date,
    'totalCount': totalCount,
    'totalWaktu': totalWaktu,
    'statuses': statuses,
    'jadwal': jadwal,
  });

  static const _waktuKeys = [
    'subuh',
    'dzuhur',
    'ashar',
    'maghrib',
    'isya',
  ];

  static Map<String, String> statusesFromDay(ShalatDayStats today) {
    final map = <String, String>{};
    for (final waktu in _waktuKeys) {
      final w = WaktuShalat.values.firstWhere(
        (e) => e.name == waktu,
        orElse: () => WaktuShalat.subuh,
      );
      final log = today.logFor(w);
      final statusKey = switch (log.status) {
        ShalatStatus.tepatWaktu => 'tepatWaktu',
        ShalatStatus.qadha => 'qadha',
        ShalatStatus.tidakShalat => 'tidakShalat',
        ShalatStatus.belumDicatat => 'belumDicatat',
      };
      map[waktu] = statusKey;
    }
    return map;
  }
}

/// Update the home screen widget with current shalat data.
Future<void> updateShalatWidget(
  ShalatDayStats today,
  int totalWaktu,
  Map<String, String>? jadwal,
) async {
  final statuses = ShalatWidgetData.statusesFromDay(today);
  final data = ShalatWidgetData.fromDayStats(
    today.date,
    today.jumlahShalat,
    totalWaktu,
    statuses,
    jadwal ?? {},
  );
  await HomeWidget.saveWidgetData('shalat_widget_data', data.toJson());
  await HomeWidget.updateWidget(
    name: 'ShalatWidgetProvider',
    androidName: 'ShalatWidgetProvider',
  );
}
