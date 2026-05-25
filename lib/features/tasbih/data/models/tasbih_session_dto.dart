import 'package:freezed_annotation/freezed_annotation.dart';

part 'tasbih_session_dto.freezed.dart';
part 'tasbih_session_dto.g.dart';

@freezed
abstract class TasbihSessionDto with _$TasbihSessionDto {
  const factory TasbihSessionDto({
    required String id,
    required String presetId,
    required String presetName,
    required int count,
    required int target,
    required String createdAt,
  }) = _TasbihSessionDto;

  factory TasbihSessionDto.fromJson(Map<String, dynamic> json) =>
      _$TasbihSessionDtoFromJson(json);
}
