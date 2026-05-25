import 'package:freezed_annotation/freezed_annotation.dart';

part 'quran_reminder_prefs.freezed.dart';

/// Preferensi reminder baca Quran harian.
///
/// Menyimpan status aktif/nonaktif dan jam reminder.
@freezed
abstract class QuranReminderPrefs with _$QuranReminderPrefs {
  const factory QuranReminderPrefs({
    /// Apakah reminder aktif.
    @Default(false) bool enabled,

    /// Jam reminder (0–23). Default: 20 (pukul 20:00).
    @Default(20) int hour,

    /// Menit reminder (0–59). Default: 0.
    @Default(0) int minute,
  }) = _QuranReminderPrefs;
}
