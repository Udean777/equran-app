import 'package:freezed_annotation/freezed_annotation.dart';

part 'imsak_alarm_prefs.freezed.dart';

@freezed
abstract class ImsakAlarmPrefs with _$ImsakAlarmPrefs {
  const factory ImsakAlarmPrefs({
    @Default(false) bool imsakEnabled,
    @Default(false) bool sahurEnabled,
    @Default(60) int menitSebelumImsak,
  }) = _ImsakAlarmPrefs;
}
