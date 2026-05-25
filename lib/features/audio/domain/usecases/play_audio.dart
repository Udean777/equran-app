import 'package:equatable/equatable.dart';
import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/audio/domain/entities/audio_state_entity.dart';
import 'package:equran_app/features/audio/domain/entities/qari.dart';
import 'package:equran_app/features/audio/domain/repositories/audio_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

class PlayAudioParams extends Equatable {
  const PlayAudioParams({
    required this.url,
    required this.ayatNomor,
    required this.qari,
    this.suratNomor,
  });

  final String url;
  final int ayatNomor;
  final Qari qari;

  /// Opsional — jika disediakan, repository akan cek file lokal dulu
  /// sebelum streaming dari CDN.
  final int? suratNomor;

  @override
  List<Object?> get props => [url, ayatNomor, qari, suratNomor];
}

@injectable
class PlayAudio implements UseCase<Unit, PlayAudioParams> {
  const PlayAudio(this._repository);

  final AudioRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(PlayAudioParams params) =>
      _repository.play(
        url: params.url,
        ayatNomor: params.ayatNomor,
        qari: params.qari,
        suratNomor: params.suratNomor,
      );
}
