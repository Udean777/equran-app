import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:equran_app/features/audio/domain/entities/audio_state_entity.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:just_audio/just_audio.dart';

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

@Singleton(as: AudioPlayerDataSource)
class AudioPlayerDataSourceImpl implements AudioPlayerDataSource {
  AudioPlayerDataSourceImpl() {
    unawaited(_init());
  }

  final AudioPlayer _player = AudioPlayer();
  final _stateController = StreamController<AudioPlayerState>.broadcast();

  int? _currentAyat;
  Qari _currentQari = Qari.misyariRasyidAlAfasi;

  Future<void> _init() async {
    // Setup audio session untuk handle interrupt
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());

    session.interruptionEventStream.listen((event) {
      if (event.begin) unawaited(pause());
    });

    // Listen player state changes
    _player.playerStateStream.listen((playerState) {
      final ayat = _currentAyat;
      if (ayat == null) return;

      final position = _player.position;
      final duration = _player.duration ?? Duration.zero;

      if (playerState.processingState == ProcessingState.loading ||
          playerState.processingState == ProcessingState.buffering) {
        _stateController.add(
          AudioPlayerState.loading(ayatNomor: ayat, qari: _currentQari),
        );
      } else if (playerState.playing) {
        _stateController.add(
          AudioPlayerState.playing(
            ayatNomor: ayat,
            qari: _currentQari,
            position: position,
            duration: duration,
          ),
        );
      } else if (playerState.processingState == ProcessingState.completed) {
        _stateController.add(const AudioPlayerState.idle());
        _currentAyat = null;
      } else if (!playerState.playing &&
          playerState.processingState == ProcessingState.ready) {
        _stateController.add(
          AudioPlayerState.paused(
            ayatNomor: ayat,
            qari: _currentQari,
            position: position,
            duration: duration,
          ),
        );
      }
    });

    // Listen position updates untuk progress bar
    _player.positionStream.listen((position) {
      final ayat = _currentAyat;
      if (ayat == null || !_player.playing) return;
      final duration = _player.duration ?? Duration.zero;
      _stateController.add(
        AudioPlayerState.playing(
          ayatNomor: ayat,
          qari: _currentQari,
          position: position,
          duration: duration,
        ),
      );
    });
  }

  @override
  Future<void> play({
    required String url,
    required int ayatNomor,
    required Qari qari,
  }) async {
    try {
      _currentAyat = ayatNomor;
      _currentQari = qari;
      _stateController.add(
        AudioPlayerState.loading(ayatNomor: ayatNomor, qari: qari),
      );
      await _player.setUrl(url);
      await _player.play();
    } on Object catch (e) {
      _stateController.add(AudioPlayerState.error(message: e.toString()));
      debugPrint('AudioPlayerDataSource play error: $e');
    }
  }

  @override
  Future<void> pause() async {
    try {
      await _player.pause();
    } on Object catch (e) {
      debugPrint('AudioPlayerDataSource pause error: $e');
    }
  }

  @override
  Future<void> resume() async {
    try {
      await _player.play();
    } on Object catch (e) {
      debugPrint('AudioPlayerDataSource resume error: $e');
    }
  }

  @override
  Future<void> stop() async {
    try {
      await _player.stop();
      _currentAyat = null;
      _stateController.add(const AudioPlayerState.idle());
    } on Object catch (e) {
      debugPrint('AudioPlayerDataSource stop error: $e');
    }
  }

  @override
  Future<void> seek(Duration position) async {
    try {
      await _player.seek(position);
    } on Object catch (e) {
      debugPrint('AudioPlayerDataSource seek error: $e');
    }
  }

  @override
  Stream<AudioPlayerState> get stateStream => _stateController.stream;

  @override
  void dispose() {
    unawaited(_player.dispose());
    unawaited(_stateController.close());
  }
}
