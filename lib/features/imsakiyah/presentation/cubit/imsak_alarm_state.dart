part of 'imsak_alarm_cubit.dart';

@freezed
sealed class ImsakAlarmState with _$ImsakAlarmState {
  /// Initial state — belum load
  const factory ImsakAlarmState.initial() = ImsakAlarmInitial;

  /// Prefs berhasil dimuat
  const factory ImsakAlarmState.loaded({
    required ImsakAlarmPrefs prefs,
  }) = ImsakAlarmLoaded;
}
