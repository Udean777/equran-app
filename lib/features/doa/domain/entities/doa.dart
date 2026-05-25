import 'package:freezed_annotation/freezed_annotation.dart';

part 'doa.freezed.dart';

@freezed
abstract class Doa with _$Doa {
  const factory Doa({
    required int id,
    required String grup,
    required String nama,
    required String ar,
    required String tr,
    required String idn,
    required String tentang,
    required List<String> tag,
  }) = _Doa;
}
