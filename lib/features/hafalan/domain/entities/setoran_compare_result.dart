import 'package:freezed_annotation/freezed_annotation.dart';

part 'setoran_compare_result.freezed.dart';
part 'setoran_compare_result.g.dart';

@freezed
abstract class SetoranCompareResult with _$SetoranCompareResult {
  const factory SetoranCompareResult({
    required double score,
    required bool passed,
    required double threshold,
    required String transcribed,
    required String target,
    required double cer,
    required int durationMs,
    @Default([]) List<WordError> wordErrors,
  }) = _SetoranCompareResult;

  const SetoranCompareResult._();

  factory SetoranCompareResult.fromJson(Map<String, dynamic> json) =>
      SetoranCompareResult(
        score: (json['score'] as num).toDouble(),
        passed: json['passed'] as bool,
        threshold: (json['threshold'] as num).toDouble(),
        transcribed: json['transcribed'] as String,
        target: json['target'] as String,
        cer: (json['cer'] as num).toDouble(),
        wordErrors: (json['word_errors'] as List<dynamic>?)
                ?.map((e) => WordError.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        durationMs: json['duration_ms'] as int,
      );
}

@freezed
abstract class WordError with _$WordError {
  const factory WordError({
    required String expected,
    required String actual,
    required int position,
  }) = _WordError;

  factory WordError.fromJson(Map<String, dynamic> json) => WordError(
        expected: json['expected'] as String,
        actual: json['actual'] as String,
        position: json['position'] as int,
      );
}
