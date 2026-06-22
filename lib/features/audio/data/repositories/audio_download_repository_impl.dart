import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/audio/data/datasources/audio_download_data_source.dart';
import 'package:equran_app/features/audio/domain/entities/qari.dart';
import 'package:equran_app/features/audio/domain/repositories/audio_download_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AudioDownloadRepository)
class AudioDownloadRepositoryImpl implements AudioDownloadRepository {
  const AudioDownloadRepositoryImpl(this._dataSource);

  final AudioDownloadDataSource _dataSource;

  @override
  Stream<Either<Failure, double>> downloadAyat({
    required int suratNomor,
    required int ayatNomor,
    required Qari qari,
    required String url,
  }) async* {
    try {
      await for (final progress in _dataSource.downloadAyat(
        suratNomor: suratNomor,
        ayatNomor: ayatNomor,
        qari: qari,
        url: url,
      )) {
        yield right(progress);
      }
    } on Object catch (e) {
      yield left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteAyat({
    required int suratNomor,
    required int ayatNomor,
    required Qari qari,
  }) async {
    try {
      await _dataSource.deleteAyat(
        suratNomor: suratNomor,
        ayatNomor: ayatNomor,
        qari: qari,
      );
      return right(unit);
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DownloadedAyatInfo>>> getDownloadedAyats() async {
    try {
      final result = await _dataSource.getDownloadedAyats();
      return right(result);
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteAll() async {
    try {
      await _dataSource.deleteAll();
      return right(unit);
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }
}
