import 'package:freezed_annotation/freezed_annotation.dart';

part 'bookmark.freezed.dart';

@freezed
abstract class Bookmark with _$Bookmark {
  const factory Bookmark({
    required int suratNomor,
    required int ayatNomor,
    required String namaLatin,
    required String teksArab,
    required String teksIndonesia,
    required DateTime savedAt,
  }) = _Bookmark;
}
