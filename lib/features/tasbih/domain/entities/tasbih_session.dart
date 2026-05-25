import 'package:freezed_annotation/freezed_annotation.dart';

part 'tasbih_session.freezed.dart';

@freezed
abstract class TasbihSession with _$TasbihSession {
  const factory TasbihSession({
    required String id,
    required String presetId,
    required String presetName,
    required int count,
    required int target,
    required DateTime createdAt,
  }) = _TasbihSession;
}
