import 'dart:convert';

import 'package:equran_app/features/statistik_shalat/domain/entities/shalat_log.dart';
import 'package:home_widget/home_widget.dart';

class ShalatWidgetData {
  ShalatWidgetData({
    required this.totalCount,
    required this.totalWaktu,
    required this.statuses,
  });

  factory ShalatWidgetData.fromDayStats(
    int jumlahShalat,
    int totalWaktu,
    Map<String, String> statuses,
  ) {
    return ShalatWidgetData(
      totalCount: jumlahShalat,
      totalWaktu: totalWaktu,
      statuses: statuses,
    );
  }

  factory ShalatWidgetData.fromJson(String str) {
    final map = jsonDecode(str) as Map<String, dynamic>;
    return ShalatWidgetData(
      totalCount: map['totalCount'] as int,
      totalWaktu: map['totalWaktu'] as int,
      statuses: Map<String, String>.from(map['statuses'] as Map),
    );
  }

  final int totalCount;
  final int totalWaktu;
  final Map<String, String> statuses;

  String toJson() => jsonEncode({
    'totalCount': totalCount,
    'totalWaktu': totalWaktu,
    'statuses': statuses,
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

/// Read widget check-in statuses from SharedPreferences.
/// Returns null if no data or parse error.
Future<Map<String, String>?> readWidgetCheckinStatuses() async {
  final jsonStr = await HomeWidget.getWidgetData<String>('shalat_widget_data');
  if (jsonStr == null) return null;
  try {
    return ShalatWidgetData.fromJson(jsonStr).statuses;
  } on FormatException catch (_) {
    return null;
  }
}

/// Update the home screen widget with current shalat data.
Future<void> updateShalatWidget(ShalatDayStats today, int totalWaktu) async {
  final statuses = ShalatWidgetData.statusesFromDay(today);
  final data = ShalatWidgetData.fromDayStats(
    today.jumlahShalat,
    totalWaktu,
    statuses,
  );
  await HomeWidget.saveWidgetData('shalat_widget_data', data.toJson());
  await HomeWidget.updateWidget(
    name: 'ShalatWidgetProvider',
    androidName: 'ShalatWidgetProvider',
  );
}
