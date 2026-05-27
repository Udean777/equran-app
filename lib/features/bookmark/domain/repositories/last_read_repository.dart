import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/bookmark/domain/entities/last_read.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class LastReadRepository {
  Future<Either<Failure, LastRead?>> getLastRead();
  Future<Either<Failure, Unit>> saveLastRead(LastRead lastRead);
}
