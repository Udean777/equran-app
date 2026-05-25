import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

@freezed
sealed class Failure with _$Failure {
  const factory Failure.network() = NetworkFailure;
  const factory Failure.server({required int statusCode}) = ServerFailure;
  const factory Failure.unknown({required String message}) = UnknownFailure;
}
