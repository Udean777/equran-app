import 'package:equran_app/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

/// Base use case with params.
abstract interface class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

/// Base use case without params.
abstract interface class UseCaseNoParams<T> {
  Future<Either<Failure, T>> call();
}
