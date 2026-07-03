import 'package:adhan/adhan.dart' as adhan;
import 'package:equran_app/features/jadwal_shalat/domain/entities/jadwal_shalat.dart';
import 'package:equran_app/features/jadwal_shalat/domain/entities/jadwal_shalat_entry.dart';

class OfflineJadwalShalatService {
  const OfflineJadwalShalatService();

  static const _monthNames = [
    '',
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  static const _dayNames = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];

  JadwalShalat calculate({
    required double latitude,
    required double longitude,
    required int bulan,
    required int tahun,
    String provinsi = 'Offline',
    String kabkota = 'Lokal',
  }) {
    final coords = adhan.Coordinates(latitude, longitude);
    final params = adhan.CalculationMethod.muslim_world_league.getParameters()
      ..madhab = adhan.Madhab.shafi;

    final entries = <JadwalShalatEntry>[];
    final daysInMonth = DateTime(tahun, bulan + 1, 0).day;

    for (var day = 1; day <= daysInMonth; day++) {
      final date = DateTime(tahun, bulan, day);
      final dateComponents = adhan.DateComponents.from(date);
      final prayerTimes = adhan.PrayerTimes(coords, dateComponents, params);

      final dayOfWeek = date.weekday - 1;

      String fmt(DateTime t) {
        return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
      }

      entries.add(
        JadwalShalatEntry(
          tanggal: day,
          tanggalLengkap: '$day ${_monthNames[bulan]} $tahun',
          hari: _dayNames[dayOfWeek >= 0 ? dayOfWeek : 6],
          imsak: fmt(prayerTimes.fajr.subtract(const Duration(minutes: 10))),
          subuh: fmt(prayerTimes.fajr),
          terbit: fmt(prayerTimes.sunrise),
          dhuha: fmt(prayerTimes.sunrise.add(const Duration(minutes: 15))),
          dzuhur: fmt(prayerTimes.dhuhr),
          ashar: fmt(prayerTimes.asr),
          maghrib: fmt(prayerTimes.maghrib),
          isya: fmt(prayerTimes.isha),
        ),
      );
    }

    return JadwalShalat(
      provinsi: provinsi,
      kabkota: kabkota,
      bulan: bulan,
      tahun: tahun,
      bulanNama: _monthNames[bulan],
      jadwal: entries,
    );
  }
}
