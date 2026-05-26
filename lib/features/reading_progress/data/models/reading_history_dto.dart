import 'package:freezed_annotation/freezed_annotation.dart';

part 'reading_history_dto.freezed.dart';
part 'reading_history_dto.g.dart';

/// DTO untuk satu hari riwayat baca.
/// Set disimpan sebagai List di JSON.
@freezed
abstract class ReadingHistoryDto with _$ReadingHistoryDto {
  const factory ReadingHistoryDto({
    required String date,

    /// Disimpan sebagai List di JSON (Set tidak support JSON langsung).
    @Default(<String>[]) List<String> ayatRead,
  }) = _ReadingHistoryDto;

  factory ReadingHistoryDto.fromJson(Map<String, dynamic> json) =>
      _$ReadingHistoryDtoFromJson(json);
}
