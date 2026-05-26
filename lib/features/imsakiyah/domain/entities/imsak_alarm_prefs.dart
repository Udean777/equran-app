import 'package:freezed_annotation/freezed_annotation.dart';

part 'imsak_alarm_prefs.freezed.dart';
part 'imsak_alarm_prefs.g.dart';

@freezed
abstract class ImsakAlarmPrefs with _$ImsakAlarmPrefs {
  const factory ImsakAlarmPrefs({
    @Default(false) bool imsakEnabled,
    @Default(false) bool sahurEnabled,
    @Default(60) int menitSebelumImsak,
  }) = _ImsakAlarmPrefs;

  factory ImsakAlarmPrefs.fromJson(Map<String, dynamic> json) =>
      _$ImsakAlarmPrefsFromJson(json);
}
