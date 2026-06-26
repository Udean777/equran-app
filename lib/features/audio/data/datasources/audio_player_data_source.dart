import 'package:equran_app/features/audio/data/datasources/audio_background_handler.dart';
import 'package:equran_app/features/audio/domain/entities/audio_state_entity.dart';

abstract interface class AudioPlayerDataSource {
  Future<void> play({
    required String url,
    required int ayatNomor,
    required Qari qari,
  });
  Future<void> pause();
  Future<void> resume();
  Future<void> stop();
  Future<void> seek(Duration position);
  Stream<AudioPlayerState> get stateStream;
  void dispose();
}

class AudioPlayerDataSourceImpl implements AudioPlayerDataSource {
  AudioPlayerDataSourceImpl(this._handler);

  final AudioCompositeHandler _handler;

  @override
  Future<void> play({
    required String url,
    required int ayatNomor,
    required Qari qari,
  }) => _handler.playUrl(url: url, ayatNomor: ayatNomor, qari: qari);

  @override
  Future<void> pause() => _handler.pause();

  @override
  Future<void> resume() => _handler.play();

  @override
  Future<void> stop() => _handler.stop();

  @override
  Future<void> seek(Duration position) => _handler.seek(position);

  @override
  Stream<AudioPlayerState> get stateStream => _handler.audioStateStream;

  @override
  void dispose() => _handler.disposeHandler();
}
