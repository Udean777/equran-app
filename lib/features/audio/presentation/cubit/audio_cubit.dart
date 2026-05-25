import 'dart:async';

import 'package:equran_app/features/audio/domain/entities/audio_state_entity.dart';
import 'package:equran_app/features/audio/domain/repositories/audio_repository.dart';
import 'package:equran_app/features/audio/domain/usecases/pause_audio.dart';
import 'package:equran_app/features/audio/domain/usecases/play_audio.dart';
import 'package:equran_app/features/audio/domain/usecases/resume_audio.dart';
import 'package:equran_app/features/audio/domain/usecases/seek_audio.dart';
import 'package:equran_app/features/audio/domain/usecases/stop_audio.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'audio_cubit_state.dart';

/// AudioCubit bersifat singleton — audio tetap play saat navigasi antar screen.
@singleton
class AudioCubit extends Cubit<AudioPlayerState> {
  AudioCubit(
    this._playAudio,
    this._pauseAudio,
    this._resumeAudio,
    this._stopAudio,
    this._seekAudio,
    this._repository,
  ) : super(const AudioPlayerState.idle()) {
    _listenToStream();
  }

  final PlayAudio _playAudio;
  final PauseAudio _pauseAudio;
  final ResumeAudio _resumeAudio;
  final StopAudio _stopAudio;
  final SeekAudio _seekAudio;
  final AudioRepository _repository;

  StreamSubscription<AudioPlayerState>? _subscription;

  // --- Playlist state ---
  List<Ayat> _playlist = [];
  int _playlistIndex = -1;
  int? _playlistSuratNomor;
  String? _playlistSuratName;
  Qari _playlistQari = Qari.misyariRasyidAlAfasi;

  bool get isPlaylistMode => _playlist.isNotEmpty;
  int get playlistIndex => _playlistIndex;
  List<Ayat> get playlist => List.unmodifiable(_playlist);
  String? get playlistSuratName => _playlistSuratName;

  void _listenToStream() {
    _subscription = _repository.stateStream.listen((audioState) {
      emit(audioState);

      // Auto-advance ke ayat berikutnya saat selesai (playlist mode)
      if (audioState.isIdle && isPlaylistMode) {
        unawaited(_playNextInPlaylist());
      }
    });
  }

  /// Play audio ayat. Jika ayat yang sama sedang play → toggle pause/resume.
  Future<void> playOrToggle({
    required String url,
    required int ayatNomor,
    required Qari qari,
    int? suratNomor,
  }) async {
    final current = state;

    // Toggle pause/resume jika ayat sama
    if (current.currentAyat == ayatNomor) {
      if (current.isPlaying) {
        await _pauseAudio();
      } else if (current.isPaused) {
        await _resumeAudio();
      }
      return;
    }

    // Clear playlist mode jika play manual
    _clearPlaylist();

    // Play ayat baru
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
    _clearPlaylist();
    await _stopAudio();
  }

  Future<void> seek(Duration position) => _seekAudio(position);

  /// Ganti qari — replay ayat yang sedang aktif dengan qari baru.
  Future<void> changeQari({
    required Qari qari,
    required Map<String, String> audioMap,
  }) async {
    final currentAyat = state.currentAyat;
    if (currentAyat == null) return;

    final url = audioMap[qari.id];
    if (url == null) return;

    if (isPlaylistMode) {
      _playlistQari = qari;
    }

    await _playAudio(
      PlayAudioParams(url: url, ayatNomor: currentAyat, qari: qari),
    );
  }

  // ---------------------------------------------------------------------------
  // Playlist mode
  // ---------------------------------------------------------------------------

  /// Play surat penuh mulai dari [startIndex].
  Future<void> playFullSurat({
    required List<Ayat> ayatList,
    required int startIndex,
    required Qari qari,
    required int suratNomor,
    required String suratName,
  }) async {
    if (ayatList.isEmpty || startIndex >= ayatList.length) return;

    _playlist = List.of(ayatList);
    _playlistIndex = startIndex;
    _playlistQari = qari;
    _playlistSuratNomor = suratNomor;
    _playlistSuratName = suratName;

    await _playAtIndex(startIndex);
  }

  /// Play ayat berikutnya dalam playlist.
  Future<void> nextAyat() async {
    if (!isPlaylistMode) return;
    if (_playlistIndex >= _playlist.length - 1) {
      // Sudah di akhir surat
      _clearPlaylist();
      await _stopAudio();
      return;
    }
    _playlistIndex++;
    await _playAtIndex(_playlistIndex);
  }

  /// Play ayat sebelumnya dalam playlist.
  Future<void> previousAyat() async {
    if (!isPlaylistMode) return;
    if (_playlistIndex <= 0) return;
    _playlistIndex--;
    await _playAtIndex(_playlistIndex);
  }

  Future<void> _playNextInPlaylist() async {
    if (_playlistIndex >= _playlist.length - 1) {
      // Selesai semua ayat
      _clearPlaylist();
      return;
    }
    _playlistIndex++;
    await _playAtIndex(_playlistIndex);
  }

  Future<void> _playAtIndex(int index) async {
    if (index < 0 || index >= _playlist.length) return;
    final ayat = _playlist[index];
    final url = ayat.audio[_playlistQari.id] ?? ayat.audio.values.firstOrNull;
    if (url == null) {
      debugPrint('AudioCubit: no URL for ayat ${ayat.nomorAyat}');
      return;
    }
    await _playAudio(
      PlayAudioParams(
        url: url,
        ayatNomor: ayat.nomorAyat,
        qari: _playlistQari,
        suratNomor: _playlistSuratNomor,
      ),
    );
  }

  void _clearPlaylist() {
    _playlist = [];
    _playlistIndex = -1;
    _playlistSuratNomor = null;
    _playlistSuratName = null;
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    await super.close();
  }
}
