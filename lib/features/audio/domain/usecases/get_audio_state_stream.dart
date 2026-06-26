import 'package:equran_app/features/audio/domain/entities/audio_state_entity.dart';
import 'package:equran_app/features/audio/domain/repositories/audio_repository.dart';

class GetAudioStateStream {
  const GetAudioStateStream(this.repository);

  final AudioRepository repository;

  Stream<AudioPlayerState> call() {
    return repository.stateStream;
  }
}
