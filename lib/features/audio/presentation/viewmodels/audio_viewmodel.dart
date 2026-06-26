import 'dart:async';

import 'package:equran_app/features/audio/domain/services/audio_playlist_manager.dart';
import 'package:equran_app/features/audio/domain/usecases/get_audio_state_stream.dart';
import 'package:equran_app/features/audio/domain/usecases/pause_audio.dart';
import 'package:equran_app/features/audio/domain/usecases/play_audio.dart';
import 'package:equran_app/features/audio/domain/usecases/resume_audio.dart';
import 'package:equran_app/features/audio/domain/usecases/seek_audio.dart';
import 'package:equran_app/features/audio/domain/usecases/stop_audio.dart';
import 'package:equran_app/features/audio/presentation/providers.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AudioViewModel extends Notifier<AudioPlayerState> {
  @override
  AudioPlayerState build() {
    _listenToStream();
    ref.onDispose(() => unawaited(_subscription?.cancel()));
    return const AudioPlayerState.idle();
  }

  PlayAudio get _playAudio => ref.read(playAudioProvider);
  PauseAudio get _pauseAudio => ref.read(pauseAudioProvider);
  ResumeAudio get _resumeAudio => ref.read(resumeAudioProvider);
  StopAudio get _stopAudio => ref.read(stopAudioProvider);
  SeekAudio get _seekAudio => ref.read(seekAudioProvider);
  GetAudioStateStream get _getAudioStateStream => ref.read(getAudioStateStreamProvider);

  final AudioPlaylistManager _playlistManager = AudioPlaylistManager();

  StreamSubscription<AudioPlayerState>? _subscription;

  VoidCallback? get onPlaylistCompleted => _playlistManager.onPlaylistCompleted;
  set onPlaylistCompleted(VoidCallback? value) =>
      _playlistManager.onPlaylistCompleted = value;

  Qari get currentQari => state.currentQari;
  int? get currentAyat => state.currentAyat;

  bool get isPlaylistMode => _playlistManager.isPlaylistMode;
  int get playlistIndex => _playlistManager.index;
  int? get playlistSuratNomor => _playlistManager.suratNomor;
  String? get playlistSuratName => _playlistManager.suratName;
  List<Ayat> get playlist => _playlistManager.list;
  bool get shouldUpdateLastRead => _playlistManager.shouldUpdateLastRead;
  Map<String, String> get lastAudioMap => _playlistManager.lastAudioMap;

  void _listenToStream() {
    _subscription = _getAudioStateStream().listen((audioState) {
      if ((audioState.isPlaying || audioState.isPaused) &&
          audioState.currentAyat != null) {
        _playlistManager.discoverDuration(
          audioState.currentAyat!,
          audioState.duration,
        );
      }

      final pendingSeek = _playlistManager.consumePendingSeek();
      if (audioState.isPlaying && pendingSeek != null) {
        unawaited(_seekAudio(pendingSeek));
      }

      state = audioState;

      if (audioState.isIdle && isPlaylistMode) {
        unawaited(_advanceInPlaylist());
      }
    });
  }

  Future<void> _advanceInPlaylist() async {
    final next = _playlistManager.advanceToNext();
    if (next != null) {
      await _playAtIndex(next);
    }
  }

  Future<void> playOrToggle({
    required String url,
    required int ayatNomor,
    required Qari qari,
    int? suratNomor,
    Map<String, String> audioMap = const {},
  }) async {
    final current = state;

    if (audioMap.isNotEmpty) {
      _playlistManager.setLastAudioMap(audioMap);
    }

    if (current.currentAyat == ayatNomor) {
      if (current.isPlaying) {
        await _pauseAudio();
      } else if (current.isPaused) {
        await _resumeAudio();
      }
      return;
    }

    _playlistManager.clear();
    await _playAudio(
      PlayAudioParams(
        url: url,
        ayatNomor: ayatNomor,
        qari: qari,
        suratNomor: suratNomor,
      ),
    );
  }

  Future<void> pause() => _pauseAudio();
  Future<void> resume() => _resumeAudio();

  Future<void> stop() async {
    _playlistManager.clear();
    await _stopAudio();
  }

  Future<void> seek(Duration position) async {
    if (!isPlaylistMode) {
      await _seekAudio(position);
      return;
    }
    await _seekPlaylist(position);
  }

  Future<void> changeQari({
    required Qari qari,
    required Map<String, String> audioMap,
  }) async {
    final currentAyat = state.currentAyat;
    if (currentAyat == null) return;

    final url = audioMap[qari.id];
    if (url == null) return;

    if (isPlaylistMode) {
      _playlistManager.setQari(qari);
    }

    await _playAudio(
      PlayAudioParams(url: url, ayatNomor: currentAyat, qari: qari),
    );
  }

  Future<void> playFullSurat({
    required List<Ayat> ayatList,
    required int startIndex,
    required Qari qari,
    required int suratNomor,
    required String suratName,
    Map<String, String> audioMap = const {},
    bool updateLastRead = true,
  }) async {
    if (ayatList.isEmpty || startIndex >= ayatList.length) return;

    _playlistManager.setPlaylist(
      ayatList: ayatList,
      startIndex: startIndex,
      qari: qari,
      suratNomor: suratNomor,
      suratName: suratName,
      audioMap: audioMap,
      updateLastRead: updateLastRead,
    );

    await _playAtIndex(startIndex);
  }

  Future<void> nextAyat() async {
    if (!isPlaylistMode) return;
    if (_playlistManager.isAtEnd) {
      _playlistManager.clear();
      await _stopAudio();
      return;
    }
    final next = _playlistManager.advanceToNext();
    if (next != null) {
      await _playAtIndex(next);
    }
  }

  Future<void> previousAyat() async {
    if (!isPlaylistMode) return;
    final prev = _playlistManager.goToPrevious();
    if (prev != null) {
      await _playAtIndex(prev);
    }
  }

  Future<void> _playAtIndex(int index) async {
    final ayat = _playlistManager.list.elementAtOrNull(index);
    if (ayat == null) return;
    final url = _playlistManager.getUrlForCurrentAyat();
    if (url == null) {
      debugPrint('AudioViewModel: no URL for ayat ${ayat.nomorAyat}');
      return;
    }
    await _playAudio(
      PlayAudioParams(
        url: url,
        ayatNomor: ayat.nomorAyat,
        qari: _playlistManager.qari,
        suratNomor: _playlistManager.suratNomor,
      ),
    );
  }

  Duration get playlistTotalDuration => _playlistManager.totalDuration;

  Duration get playlistCurrentPosition =>
      _playlistManager.currentPosition(state.position);

  Future<void> _seekPlaylist(Duration globalPosition) async {
    final result = _playlistManager.seekToGlobal(globalPosition);
    if (result == null) return;

    if (result.index == _playlistManager.index) {
      await _seekAudio(result.localOffset);
    } else {
      _playlistManager
        ..setPendingSeek(result.localOffset)
        ..jumpToIndex(result.index);
      await _playAtIndex(result.index);
    }
  }
}
