import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/tasbih/data/datasources/tasbih_local_data_source.dart';
import 'package:equran_app/features/tasbih/data/mappers/tasbih_session_mapper.dart';
import 'package:equran_app/features/tasbih/domain/entities/tasbih_session.dart';
import 'package:equran_app/features/tasbih/domain/repositories/tasbih_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: TasbihRepository)
class TasbihRepositoryImpl implements TasbihRepository {
  const TasbihRepositoryImpl(this._local);

  final TasbihLocalDataSource _local;

  @override
  Future<Either<Failure, Unit>> saveSession(TasbihSession session) async {
    try {
      await _local.saveSession(session.toDto());
      return right(unit);
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TasbihSession>>> getSessions() async {
    try {
      final dtos = await _local.getSessions();
      return right(dtos.map((e) => e.toEntity()).toList());
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteSession(String id) async {
    try {
      await _local.deleteSession(id);
      return right(unit);
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> clearSessions() async {
    try {
      await _local.clearSessions();
      return right(unit);
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }
}
