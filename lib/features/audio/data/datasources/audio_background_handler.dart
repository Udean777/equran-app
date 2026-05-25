import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:equran_app/features/audio/domain/entities/audio_state_entity.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

/// AudioHandler yang wrap just_audio untuk background playback.
/// Diregister via [AudioService.init()] di main.dart.
class AudioBackgroundHandler extends BaseAudioHandler {
  AudioBackgroundHandler() {
    unawaited(_init());
  }

  final AudioPlayer _player = AudioPlayer();
  final _stateController = StreamController<AudioPlayerState>.broadcast();

  int? _currentAyat;
  Qari _currentQari = Qari.misyariRasyidAlAfasi;

  /// Stream state audio untuk dikonsumsi AudioCubit.
  Stream<AudioPlayerState> get audioStateStream => _stateController.stream;

  Future<void> _init() async {
    // Setup audio session untuk music (background support)
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    // Handle audio interruption (telepon masuk, dll)
    session.interruptionEventStream.listen((event) {
      if (event.begin) unawaited(pause());
    });

    // Listen player state → emit ke stateController + update playbackState
    _player.playerStateStream.listen(_onPlayerStateChanged);

    // Listen position updates untuk progress bar
    _player.positionStream.listen(_onPositionChanged);
  }

  void _onPlayerStateChanged(PlayerState playerState) {
    final ayat = _currentAyat;
    if (ayat == null) return;

    final position = _player.position;
    final duration = _player.duration ?? Duration.zero;

    if (playerState.processingState == ProcessingState.loading ||
        playerState.processingState == ProcessingState.buffering) {
      _stateController.add(
        AudioPlayerState.loading(ayatNomor: ayat, qari: _currentQari),
      );
      _updatePlaybackState(playing: false, position: position);
    } else if (playerState.playing) {
      _stateController.add(
        AudioPlayerState.playing(
          ayatNomor: ayat,
          qari: _currentQari,
          position: position,
          duration: duration,
        ),
      );
      _updatePlaybackState(playing: true, position: position);
    } else if (playerState.processingState == ProcessingState.completed) {
      _stateController.add(const AudioPlayerState.idle());
      _currentAyat = null;
      _updatePlaybackState(playing: false, position: Duration.zero);
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
      _updatePlaybackState(playing: false, position: position);
    }
  }

  void _onPositionChanged(Duration position) {
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
  }

  void _updatePlaybackState({
    required bool playing,
    required Duration position,
  }) {
    playbackState.add(
      playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.stop,
          MediaControl.skipToNext,
        ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },
        androidCompactActionIndices: const [0, 1, 3],
        processingState: playing
            ? AudioProcessingState.ready
            : AudioProcessingState.idle,
        playing: playing,
        updatePosition: position,
        bufferedPosition: position,
        speed: 1,
      ),
    );
  }

  /// Play audio dari URL atau file lokal.
  Future<void> playUrl({
    required String url,
    required int ayatNomor,
    required Qari qari,
    String? suratName,
    String? ayatText,
  }) async {
    try {
      _currentAyat = ayatNomor;
      _currentQari = qari;

      // Update media item untuk lock screen / notification
      mediaItem.add(
        MediaItem(
          id: url,
          title: 'Ayat $ayatNomor',
          artist: qari.name,
          album: suratName ?? 'Al-Quran',
          displayTitle: 'Ayat $ayatNomor',
          displaySubtitle: qari.name,
        ),
      );

      _stateController.add(
        AudioPlayerState.loading(ayatNomor: ayatNomor, qari: qari),
      );

      await _player.setUrl(url);
      await _player.play();
    } on Object catch (e) {
      _stateController.add(AudioPlayerState.error(message: e.toString()));
      debugPrint('AudioBackgroundHandler playUrl error: $e');
    }
  }

  @override
  Future<void> play() async {
    try {
      await _player.play();
    } on Object catch (e) {
      debugPrint('AudioBackgroundHandler play error: $e');
    }
  }

  @override
  Future<void> pause() async {
    try {
      await _player.pause();
    } on Object catch (e) {
      debugPrint('AudioBackgroundHandler pause error: $e');
    }
  }

  @override
  Future<void> stop() async {
    try {
      await _player.stop();
      _currentAyat = null;
      _stateController.add(const AudioPlayerState.idle());
      await super.stop();
    } on Object catch (e) {
      debugPrint('AudioBackgroundHandler stop error: $e');
    }
  }

  @override
  Future<void> seek(Duration position) async {
    try {
      await _player.seek(position);
    } on Object catch (e) {
      debugPrint('AudioBackgroundHandler seek error: $e');
    }
  }

  @override
  Future<void> skipToNext() async {
    // Diimplementasi di Phase A4 (playlist mode)
  }

  @override
  Future<void> skipToPrevious() async {
    // Diimplementasi di Phase A4 (playlist mode)
  }

  /// Dispose resources.
  Future<void> disposeHandler() async {
    await _player.dispose();
    await _stateController.close();
  }
}
