import 'package:freezed_annotation/freezed_annotation.dart';

part 'bookmark_dto.freezed.dart';
part 'bookmark_dto.g.dart';

@freezed
abstract class BookmarkDto with _$BookmarkDto {
  const factory BookmarkDto({
    required int suratNomor,
    required int ayatNomor,
    required String namaLatin,
    required String teksArab,
    required String teksIndonesia,
    required String savedAt,
  }) = _BookmarkDto;

  factory BookmarkDto.fromJson(Map<String, dynamic> json) =>
      _$BookmarkDtoFromJson(json);
}

@freezed
abstract class LastReadDto with _$LastReadDto {
  const factory LastReadDto({
    required int suratNomor,
    required int ayatNomor,
    required String namaLatin,
    required String readAt,
  }) = _LastReadDto;

  factory LastReadDto.fromJson(Map<String, dynamic> json) =>
      _$LastReadDtoFromJson(json);
}
