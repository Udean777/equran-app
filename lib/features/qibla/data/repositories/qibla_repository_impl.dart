import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/qibla/data/datasources/qibla_data_source.dart';
import 'package:equran_app/features/qibla/domain/entities/qibla_direction.dart';
import 'package:equran_app/features/qibla/domain/repositories/qibla_repository.dart';
import 'package:fpdart/fpdart.dart';

class QiblaRepositoryImpl implements QiblaRepository {
  const QiblaRepositoryImpl(this._dataSource);

  final QiblaDataSource _dataSource;

  @override
  Future<Either<Failure, Unit>> init() => _dataSource.init();

  @override
  Either<Failure, Stream<QiblaDirection>> watch() => _dataSource.watch();
}
