import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/bookmark/data/datasources/last_read_local_data_source.dart';
import 'package:equran_app/features/bookmark/data/mappers/bookmark_mapper.dart';
import 'package:equran_app/features/bookmark/domain/entities/last_read.dart';
import 'package:equran_app/features/bookmark/domain/repositories/last_read_repository.dart';
import 'package:fpdart/fpdart.dart';

class LastReadRepositoryImpl implements LastReadRepository {
  const LastReadRepositoryImpl(this._local);

  final LastReadLocalDataSource _local;

  @override
  Future<Either<Failure, LastRead?>> getLastRead() async {
    try {
      final dto = await _local.getLastRead();
      return right(dto?.toEntity());
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveLastRead(LastRead lastRead) async {
    try {
      await _local.saveLastRead(lastRead.toDto());
      return right(unit);
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }
}
