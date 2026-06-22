import 'package:freezed_annotation/freezed_annotation.dart';

part 'last_read_dto.freezed.dart';
part 'last_read_dto.g.dart';

@freezed
abstract class LastReadDto with _$LastReadDto {
  const factory LastReadDto({
    required int suratNomor,
    required int ayatNomor,
    required String namaLatin,
    required String readAt,
    @Default(0.0) double scrollPercent,
    @Default(0.0) double maxScrollPercent,
    @Default(0) int totalAyat,
  }) = _LastReadDto;

  factory LastReadDto.fromJson(Map<String, dynamic> json) =>
      _$LastReadDtoFromJson(json);
}
