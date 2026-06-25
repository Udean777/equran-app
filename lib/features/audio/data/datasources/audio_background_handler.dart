import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:equran_app/features/audio/data/datasources/adzan_player_delegate.dart';
import 'package:equran_app/features/audio/data/datasources/quran_player_delegate.dart';
import 'package:equran_app/features/audio/domain/entities/audio_state_entity.dart';
import 'package:flutter/foundation.dart';

/// Composite AudioHandler yang mengelola dua delegate:
/// - [QuranPlayerDelegate] untuk playback ayat Al-Quran
/// - [AdzanPlayerDelegate] untuk playback adzan dari local asset
///
/// Saat adzan fire:
///   1. Quran di-pause + posisi disimpan
///   2. Adzan play
///   3. Setelah adzan selesai → Quran auto-resume
///
/// Saat user tap Stop di notif adzan:
///   1. Adzan stop
///   2. Quran TIDAK auto-resume (user ingin silent)
class AudioCompositeHandler extends BaseAudioHandler {
  AudioCompositeHandler() {
    unawaited(_init());
  }

  late final QuranPlayerDelegate _quranDelegate;
  late final AdzanPlayerDelegate _adzanDelegate;

  final _stateController = StreamController<AudioPlayerState>.broadcast();

  /// Stream state audio untuk dikonsumsi AudioViewModel.
  Stream<AudioPlayerState> get audioStateStream => _stateController.stream;

  Future<void> _init() async {
    _quranDelegate = QuranPlayerDelegate(
      onStateChanged: (state) {
        if (!_stateController.isClosed) {
          _stateController.add(state);
        }
      },
      onPlaybackStateChanged: _updatePlaybackState,
      onMediaItemChanged: mediaItem.add,
    );

    _adzanDelegate = AdzanPlayerDelegate(
      onPlaybackStateChanged: ({required playing, required position}) {
        _updateAdzanPlaybackState(playing: playing);
      },
      onMediaItemChanged: mediaItem.add,
      onAdzanCompleted: _onAdzanCompleted,
      onAdzanPlayingChanged: ({required isPlaying}) =>
          _onAdzanPlayingChanged(isPlaying),
    );

    await _quranDelegate.init();
  }

  // ---------------------------------------------------------------------------
  // Adzan control (dipanggil dari AdzanAlarmCallback)
  // ---------------------------------------------------------------------------

  /// Play adzan. Pause Quran dulu jika sedang playing.
  Future<void> playAdzan({
    required bool isSubuh,
    required String waktuNama,
  }) async {
    // Simpan state Quran sebelum di-interrupt
    _quranDelegate.saveStateForInterrupt();

    // Pause Quran jika sedang playing
    if (_quranDelegate.isPlaying) {
      await _quranDelegate.pause();
    }

    // Play adzan
    await _adzanDelegate.playAdzan(
      isSubuh: isSubuh,
      waktuNama: waktuNama,
    );
  }

  /// Stop adzan manual (user tap "Hentikan").
  /// Quran TIDAK di-resume.
  Future<void> stopAdzan() async {
    await _adzanDelegate.stop();
    // Reset media item ke Quran jika ada
    if (_quranDelegate.currentAyat != null) {
      mediaItem.add(null);
    }
  }

  bool get isAdzanPlaying => _adzanDelegate.isPlaying;

  // ---------------------------------------------------------------------------
  // Quran control (existing API — tidak berubah)
  // ---------------------------------------------------------------------------

  Future<void> playUrl({
    required String url,
    required int ayatNomor,
    required Qari qari,
    String? suratName,
    String? ayatText,
  }) async {
    await _quranDelegate.playUrl(
      url: url,
      ayatNomor: ayatNomor,
      qari: qari,
      suratName: suratName,
      ayatText: ayatText,
    );
  }

  @override
  Future<void> play() async {
    if (_adzanDelegate.isPlaying) return; // Adzan prioritas
    await _quranDelegate.play();
  }

  @override
  Future<void> pause() async {
    if (_adzanDelegate.isPlaying) {
      await _adzanDelegate.stop();
      return;
    }
    await _quranDelegate.pause();
  }

  @override
  Future<void> stop() async {
    await _adzanDelegate.stop();
    await _quranDelegate.stop();
    if (!_stateController.isClosed) {
      _stateController.add(const AudioPlayerState.idle());
    }
    await super.stop();
  }

  @override
  Future<void> seek(Duration position) async {
    if (_adzanDelegate.isPlaying) return;
    await _quranDelegate.seek(position);
  }

  @override
  Future<void> skipToNext() async {
    // Diimplementasi di Phase A4 (playlist mode)
  }

  @override
  Future<void> skipToPrevious() async {
    // Diimplementasi di Phase A4 (playlist mode)
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  /// Dipanggil saat adzan selesai natural → auto-resume Quran.
  void _onAdzanCompleted() {
    debugPrint('AudioCompositeHandler: adzan selesai, resume Quran');
    unawaited(_quranDelegate.resumeAfterInterrupt());
  }

  /// Dipanggil saat state adzan berubah → switch controls di notif.
  void _onAdzanPlayingChanged(bool isPlaying) {
    if (isPlaying) {
      _updateAdzanPlaybackState(playing: true);
    } else {
      _updatePlaybackState(
        playing: _quranDelegate.isPlaying,
        position: Duration.zero,
      );
    }
  }

  /// Update playback state khusus adzan — hanya tombol Stop.
  void _updateAdzanPlaybackState({required bool playing}) {
    playbackState.add(
      playbackState.value.copyWith(
        controls: playing ? [MediaControl.stop] : [],
        systemActions: const {},
        androidCompactActionIndices: const [0],
        processingState: playing
            ? AudioProcessingState.ready
            : AudioProcessingState.idle,
        playing: playing,
        updatePosition: Duration.zero,
        bufferedPosition: Duration.zero,
        speed: 1,
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

  /// Dispose semua resources.
  Future<void> disposeHandler() async {
    await _quranDelegate.dispose();
    await _adzanDelegate.dispose();
    await _stateController.close();
  }
}
