import 'package:equran_app/features/tasbih/data/models/tasbih_session_dto.dart';
import 'package:equran_app/features/tasbih/domain/entities/tasbih_session.dart';

extension TasbihSessionDtoMapper on TasbihSessionDto {
  TasbihSession toEntity() => TasbihSession(
        id: id,
        presetId: presetId,
        presetName: presetName,
        count: count,
        target: target,
        createdAt: DateTime.parse(createdAt),
      );
}

extension TasbihSessionMapper on TasbihSession {
  TasbihSessionDto toDto() => TasbihSessionDto(
        id: id,
        presetId: presetId,
        presetName: presetName,
        count: count,
        target: target,
        createdAt: createdAt.toIso8601String(),
      );
}
