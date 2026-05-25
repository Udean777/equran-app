import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/audio/data/datasources/audio_download_data_source.dart';
import 'package:equran_app/features/audio/data/datasources/audio_player_data_source.dart';
import 'package:equran_app/features/audio/domain/entities/audio_state_entity.dart';
import 'package:equran_app/features/audio/domain/repositories/audio_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: AudioRepository)
class AudioRepositoryImpl implements AudioRepository {
  const AudioRepositoryImpl(this._dataSource, this._downloadDataSource);

  final AudioPlayerDataSource _dataSource;
  final AudioDownloadDataSource _downloadDataSource;

  @override
  Future<Either<Failure, Unit>> play({
    required String url,
    required int ayatNomor,
    required Qari qari,
    int? suratNomor,
  }) async {
    try {
      // Cek file lokal dulu — fallback ke CDN streaming
      var resolvedUrl = url;
      if (suratNomor != null) {
        final localPath = await _downloadDataSource.getLocalPath(
          suratNomor: suratNomor,
          ayatNomor: ayatNomor,
          qari: qari,
        );
        if (localPath != null) {
          resolvedUrl = 'file://$localPath';
        }
      }

      await _dataSource.play(
        url: resolvedUrl,
        ayatNomor: ayatNomor,
        qari: qari,
      );
      return right(unit);
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> pause() async {
    try {
      await _dataSource.pause();
      return right(unit);
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> resume() async {
    try {
      await _dataSource.resume();
      return right(unit);
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> stop() async {
    try {
      await _dataSource.stop();
      return right(unit);
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> seek(Duration position) async {
    try {
      await _dataSource.seek(position);
      return right(unit);
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Stream<AudioPlayerState> get stateStream => _dataSource.stateStream;
}
