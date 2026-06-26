import 'package:equran_app/features/imsakiyah/domain/entities/imsak_alarm_prefs.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'imsak_alarm_state.freezed.dart';

@freezed
sealed class ImsakAlarmState with _$ImsakAlarmState {
  const factory ImsakAlarmState.initial() = ImsakAlarmInitial;

  const factory ImsakAlarmState.loaded({
    required ImsakAlarmPrefs prefs,
  }) = ImsakAlarmLoaded;
}
