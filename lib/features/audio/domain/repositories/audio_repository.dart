import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/audio/domain/entities/audio_state_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AudioRepository {
  Future<Either<Failure, Unit>> play({
    required String url,
    required int ayatNomor,
    required Qari qari,
    int? suratNomor,
  });
  Future<Either<Failure, Unit>> pause();
  Future<Either<Failure, Unit>> resume();
  Future<Either<Failure, Unit>> stop();
  Future<Either<Failure, Unit>> seek(Duration position);
  Stream<AudioPlayerState> get stateStream;
}
