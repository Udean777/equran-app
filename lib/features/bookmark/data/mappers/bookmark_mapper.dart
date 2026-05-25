import 'package:equran_app/features/bookmark/data/models/bookmark_dto.dart';
import 'package:equran_app/features/bookmark/domain/entities/bookmark.dart';
import 'package:equran_app/features/bookmark/domain/entities/last_read.dart';

extension BookmarkDtoMapper on BookmarkDto {
  Bookmark toEntity() => Bookmark(
        suratNomor: suratNomor,
        ayatNomor: ayatNomor,
        namaLatin: namaLatin,
        teksArab: teksArab,
        teksIndonesia: teksIndonesia,
        savedAt: DateTime.parse(savedAt),
      );
}

extension BookmarkMapper on Bookmark {
  BookmarkDto toDto() => BookmarkDto(
        suratNomor: suratNomor,
        ayatNomor: ayatNomor,
        namaLatin: namaLatin,
        teksArab: teksArab,
        teksIndonesia: teksIndonesia,
        savedAt: savedAt.toIso8601String(),
      );
}

extension LastReadDtoMapper on LastReadDto {
  LastRead toEntity() => LastRead(
        suratNomor: suratNomor,
        ayatNomor: ayatNomor,
        namaLatin: namaLatin,
        readAt: DateTime.parse(readAt),
      );
}

extension LastReadMapper on LastRead {
  LastReadDto toDto() => LastReadDto(
        suratNomor: suratNomor,
        ayatNomor: ayatNomor,
        namaLatin: namaLatin,
        readAt: readAt.toIso8601String(),
      );
}
