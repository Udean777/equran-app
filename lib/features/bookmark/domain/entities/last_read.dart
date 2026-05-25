import 'package:freezed_annotation/freezed_annotation.dart';

part 'last_read.freezed.dart';

@freezed
abstract class LastRead with _$LastRead {
  const factory LastRead({
    required int suratNomor,
    required int ayatNomor,
    required String namaLatin,
    required DateTime readAt,
  }) = _LastRead;
}
