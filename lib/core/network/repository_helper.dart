import 'package:dio/dio.dart';
import 'package:equran_app/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

/// Helper untuk wrap request Dio ke `Either<Failure, T>`.
/// Digunakan di semua repository implementation.
Future<Either<Failure, T>> executeRequest<T>(
  Future<T> Function() request,
) async {
  try {
    return right(await request());
  } on DioException catch (e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.connectionTimeout) {
      return left(const Failure.network());
    }
    return left(
      Failure.server(statusCode: e.response?.statusCode ?? 0),
    );
  } on Object catch (e) {
    return left(Failure.unknown(message: e.toString()));
  }
}
