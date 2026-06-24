import 'package:freezed_annotation/freezed_annotation.dart';

part 'imsak_alarm_prefs_dto.freezed.dart';
part 'imsak_alarm_prefs_dto.g.dart';

@freezed
abstract class ImsakAlarmPrefsDto with _$ImsakAlarmPrefsDto {
  const factory ImsakAlarmPrefsDto({
    @Default(false) bool imsakEnabled,
    @Default(false) bool sahurEnabled,
    @Default(60) int menitSebelumImsak,
  }) = _ImsakAlarmPrefsDto;

  factory ImsakAlarmPrefsDto.fromJson(Map<String, dynamic> json) =>
      _$ImsakAlarmPrefsDtoFromJson(json);
}
