import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:equran_app/features/audio/data/datasources/audio_background_handler.dart' show AudioCompositeHandler;
import 'package:equran_app/features/audio/domain/entities/audio_state_entity.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

/// Delegate yang handle playback audio Quran (ayat per ayat dari URL).
/// Digunakan oleh [AudioCompositeHandler].
class QuranPlayerDelegate {
  QuranPlayerDelegate({
    required this.onStateChanged,
    required this.onPlaybackStateChanged,
    required this.onMediaItemChanged,
  });

  /// Callback ke composite handler saat state berubah.
  final void Function(AudioPlayerState state) onStateChanged;
  final void Function({required bool playing, required Duration position})
  onPlaybackStateChanged;
  final void Function(MediaItem? item) onMediaItemChanged;

  final AudioPlayer _player = AudioPlayer();

  int? _currentAyat;
  Qari _currentQari = Qari.misyariRasyidAlAfasi;

  /// Posisi terakhir sebelum di-interrupt adzan.
  Duration? _savedPosition;
  bool _wasPlaying = false;

  Future<void> init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    session.interruptionEventStream.listen((event) {
      if (event.begin) unawaited(pause());
    });

    _player.playerStateStream.listen(_onPlayerStateChanged);
    _player.positionStream.listen(_onPositionChanged);
  }

  void _onPlayerStateChanged(PlayerState playerState) {
    final ayat = _currentAyat;
    if (ayat == null) return;

    final position = _player.position;
    final duration = _player.duration ?? Duration.zero;

    if (playerState.processingState == ProcessingState.loading ||
        playerState.processingState == ProcessingState.buffering) {
      onStateChanged(
        AudioPlayerState.loading(ayatNomor: ayat, qari: _currentQari),
      );
      onPlaybackStateChanged(playing: false, position: position);
    } else if (playerState.processingState == ProcessingState.completed) {
      onStateChanged(const AudioPlayerState.idle());
      _currentAyat = null;
      onPlaybackStateChanged(playing: false, position: Duration.zero);
    } else if (playerState.playing) {
      onStateChanged(
        AudioPlayerState.playing(
          ayatNomor: ayat,
          qari: _currentQari,
          position: position,
          duration: duration,
        ),
      );
      onPlaybackStateChanged(playing: true, position: position);
    } else {
      onStateChanged(
        AudioPlayerState.paused(
          ayatNomor: ayat,
          qari: _currentQari,
          position: position,
          duration: duration,
        ),
      );
      onPlaybackStateChanged(playing: false, position: position);
    }
  }

  void _onPositionChanged(Duration position) {
    final ayat = _currentAyat;
    if (ayat == null || !_player.playing) return;
    final duration = _player.duration ?? Duration.zero;
    onStateChanged(
      AudioPlayerState.playing(
        ayatNomor: ayat,
        qari: _currentQari,
        position: position,
        duration: duration,
      ),
    );
  }

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

      onMediaItemChanged(
        MediaItem(
          id: url,
          title: 'Ayat $ayatNomor',
          artist: qari.name,
          album: suratName ?? 'Al-Quran',
          displayTitle: 'Ayat $ayatNomor',
          displaySubtitle: qari.name,
        ),
      );

      onStateChanged(
        AudioPlayerState.loading(ayatNomor: ayatNomor, qari: qari),
      );

      await _player.setUrl(url);
      await _player.play();
    } on Object catch (e) {
      onStateChanged(AudioPlayerState.error(message: e.toString()));
      debugPrint('QuranPlayerDelegate playUrl error: $e');
    }
  }

  Future<void> play() async {
    try {
      await _player.play();
    } on Object catch (e) {
      debugPrint('QuranPlayerDelegate play error: $e');
    }
  }

  Future<void> pause() async {
    try {
      await _player.pause();
    } on Object catch (e) {
      debugPrint('QuranPlayerDelegate pause error: $e');
    }
  }

  Future<void> stop() async {
    try {
      await _player.stop();
      _currentAyat = null;
      onStateChanged(const AudioPlayerState.idle());
    } on Object catch (e) {
      debugPrint('QuranPlayerDelegate stop error: $e');
    }
  }

  Future<void> seek(Duration position) async {
    try {
      await _player.seek(position);
    } on Object catch (e) {
      debugPrint('QuranPlayerDelegate seek error: $e');
    }
  }

  /// Simpan state sebelum adzan interrupt.
  void saveStateForInterrupt() {
    _wasPlaying = _player.playing;
    _savedPosition = _player.position;
  }

  /// Resume setelah adzan selesai (hanya jika sebelumnya sedang playing).
  Future<void> resumeAfterInterrupt() async {
    if (!_wasPlaying || _currentAyat == null) return;
    final pos = _savedPosition;
    if (pos != null) {
      await _player.seek(pos);
    }
    await _player.play();
    _savedPosition = null;
    _wasPlaying = false;
  }

  bool get isPlaying => _player.playing;
  int? get currentAyat => _currentAyat;

  Future<void> dispose() async {
    await _player.dispose();
  }
}
