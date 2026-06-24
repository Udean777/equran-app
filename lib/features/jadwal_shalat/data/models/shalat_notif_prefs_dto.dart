import 'package:freezed_annotation/freezed_annotation.dart';

part 'shalat_notif_prefs_dto.freezed.dart';
part 'shalat_notif_prefs_dto.g.dart';

@freezed
abstract class ShalatNotifPrefsDto with _$ShalatNotifPrefsDto {
  const factory ShalatNotifPrefsDto({
    @Default(true) bool subuh,
    @Default(true) bool dzuhur,
    @Default(true) bool ashar,
    @Default(true) bool maghrib,
    @Default(true) bool isya,
    @Default(0) int menitSebelum,
  }) = _ShalatNotifPrefsDto;

  factory ShalatNotifPrefsDto.fromJson(Map<String, dynamic> json) =>
      _$ShalatNotifPrefsDtoFromJson(json);
}
