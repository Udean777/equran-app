import 'package:equran_app/core/constants/notification_ids.dart';
import 'package:equran_app/core/notifications/notification_service.dart';
import 'package:equran_app/features/statistik_shalat/domain/entities/shalat_log.dart';
import 'package:equran_app/features/statistik_shalat/domain/usecases/get_shalat_by_date.dart';
import 'package:hive_ce/hive.dart';
import 'package:intl/intl.dart';

class ShalatRecapNotificationService {
  ShalatRecapNotificationService(
    this._notifService,
    this._settingsBox,
    this._getShalatByDate,
  );

  final NotificationService _notifService;
  final Box<String> _settingsBox;
  final GetShalatByDate _getShalatByDate;

  static const String _recapEnabledKey = 'shalat_recap_enabled';
  static const String _recapHourKey = 'shalat_recap_hour';
  static const String _recapMinuteKey = 'shalat_recap_minute';

  bool get isEnabled =>
      _settingsBox.get(_recapEnabledKey) != 'false'; // Default ON

  int get hour =>
      int.tryParse(_settingsBox.get(_recapHourKey) ?? '21') ?? 21; // Default 21
  int get minute =>
      int.tryParse(_settingsBox.get(_recapMinuteKey) ?? '0') ?? 0; // Default 0

  Future<void> setEnabled({required bool value}) async {
    await _settingsBox.put(_recapEnabledKey, value.toString());
  }

  Future<void> setTime(int h, int m) async {
    await _settingsBox.put(_recapHourKey, h.toString());
    await _settingsBox.put(_recapMinuteKey, m.toString());
  }

  /// Memperbarui jadwal notifikasi rekap.
  /// Panggil fungsi ini setiap kali ada perubahan data shalat hari ini atau saat setting diubah.
  Future<void> updateSchedule([ShalatDayStats? stats]) async {
    // 1. Batalkan notifikasi lama
    await _notifService.cancelById(NotificationIds.shalatRecap);

    // 2. Jika fitur dimatikan, return
    if (!isEnabled) return;

    var todayStats = stats;
    if (todayStats == null) {
      final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final result = await _getShalatByDate(todayStr);
      todayStats = result.fold((l) => null, (r) => r);
    }

    // 3. Tentukan pesan berdasarkan performa hari ini
    var title = 'Rekap Shalat Harian';
    var body = 'Yuk catat shalatmu hari ini agar terekam dengan baik!';

    if (todayStats != null && todayStats.hasData) {
      if (todayStats.isSempurna) {
        title = 'Alhamdulillah 5 Waktu Tuntas! 🌟';
        body = 'MasyaAllah, kerja bagus! Terus konsisten dan jaga shalatmu ya!';
      } else if (todayStats.jumlahQadha > 2) {
        title = 'Catatan Shalat Hari Ini';
        body =
            'Hari ini cukup banyak shalat yang terqadha. Besok usahakan lebih tepat waktu ya, pasti bisa! 💪';
      } else if (todayStats.jumlahShalat == 0) {
        title = 'Belum Ada Shalat Terjadwal?';
        body =
            'Hari ini sepertinya sibuk sekali. Jika masih ada waktu, yuk tunaikan kewajibanmu.';
      } else if (todayStats.jumlahTepatWaktu > 0) {
        title = 'Sudah ${todayStats.jumlahTepatWaktu} Waktu Tercatat';
        body =
            'Sedikit lagi sempurna! Mari perbaiki shalat yang masih bolong esok hari.';
      }
    }

    // 4. Jadwalkan notifikasi
    await _notifService.scheduleDailyRecap(
      id: NotificationIds.shalatRecap,
      title: title,
      body: body,
      hour: hour,
      minute: minute,
    );
  }
}
