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

  // --- Playlist timeline ---
  /// Durasi aktual per ayat setelah ter-discover (key = nomorAyat, 1-based).
  final Map<int, Duration> _discoveredDurations = {};

  /// Seek pending — diapply saat audio ayat target pertama kali playing.
  Duration? _pendingSeek;

  static const double _msPerArabChar = 220;
  static const Duration _minAyatDuration = Duration(seconds: 2);
  static const Duration _maxAyatDuration = Duration(seconds: 30);

  /// Callback dipanggil saat playlist selesai semua ayat.
  /// Diset oleh UI yang membutuhkan notifikasi selesai (misal auto-read mode).
  VoidCallback? onPlaylistCompleted;

  /// audioMap terakhir yang dipakai saat play — disimpan agar global
  /// AudioPlayerBar bisa ganti qari tanpa perlu data dari API response.
  Map<String, String> _lastAudioMap = {};

  bool get isPlaylistMode => _playlist.isNotEmpty;
  int get playlistIndex => _playlistIndex;
  int? get playlistSuratNomor => _playlistSuratNomor;
  List<Ayat> get playlist => List.unmodifiable(_playlist);
  String? get playlistSuratName => _playlistSuratName;

  /// audioMap terakhir yang dipakai — untuk global AudioPlayerBar.
  Map<String, String> get lastAudioMap => Map.unmodifiable(_lastAudioMap);

  void _listenToStream() {
    _subscription = _repository.stateStream.listen((audioState) {
      // 1. Discover durasi aktual per ayat
      if ((audioState.isPlaying || audioState.isPaused) &&
          audioState.currentAyat != null &&
          audioState.duration > Duration.zero) {
        _discoveredDurations[audioState.currentAyat!] = audioState.duration;
      }

      // 2. Apply pending seek saat audio baru pertama kali playing
      if (audioState.isPlaying && _pendingSeek != null) {
        final seekTo = _pendingSeek!;
        _pendingSeek = null; // clear dulu sebelum call agar tidak re-trigger
        unawaited(_seekAudio(seekTo));
      }

      emit(audioState);

      // 3. Auto-advance ke ayat berikutnya saat selesai (playlist mode)
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
    Map<String, String> audioMap = const {},
  }) async {
    final current = state;

    // Simpan audioMap untuk global bar
    if (audioMap.isNotEmpty) _lastAudioMap = audioMap;

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

  Future<void> seek(Duration position) async {
    if (!isPlaylistMode) {
      await _seekAudio(position);
      return;
    }
    await _seekPlaylist(position);
  }

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
    Map<String, String> audioMap = const {},
  }) async {
    if (ayatList.isEmpty || startIndex >= ayatList.length) return;

    // Simpan audioMap untuk global bar
    if (audioMap.isNotEmpty) _lastAudioMap = audioMap;

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
      onPlaylistCompleted?.call();
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

  // ---------------------------------------------------------------------------
  // Playlist timeline helpers
  // ---------------------------------------------------------------------------

  /// Estimasi durasi ayat berdasarkan panjang teks Arab.
  Duration _estimateDuration(Ayat ayat) {
    final ms = (ayat.teksArab.length * _msPerArabChar).round();
    final estimated = Duration(milliseconds: ms);
    if (estimated < _minAyatDuration) return _minAyatDuration;
    if (estimated > _maxAyatDuration) return _maxAyatDuration;
    return estimated;
  }

  /// Durasi aktual jika sudah ter-discover, estimasi jika belum.
  Duration _durationFor(Ayat ayat) =>
      _discoveredDurations[ayat.nomorAyat] ?? _estimateDuration(ayat);

  /// Total durasi seluruh playlist (aktual + estimasi).
  Duration get playlistTotalDuration {
    if (!isPlaylistMode) return Duration.zero;
    return _playlist.fold(Duration.zero, (sum, ayat) => sum + _durationFor(ayat));
  }

  /// Posisi saat ini dalam timeline playlist.
  Duration get playlistCurrentPosition {
    if (!isPlaylistMode) return Duration.zero;
    var offset = Duration.zero;
    for (var i = 0; i < _playlistIndex; i++) {
      offset += _durationFor(_playlist[i]);
    }
    return offset + state.position;
  }

  /// Seek global dalam playlist — cari ayat target lalu apply seek lokal.
  Future<void> _seekPlaylist(Duration globalPosition) async {
    if (_playlist.isEmpty) return;

    var accumulated = Duration.zero;
    var targetIndex = 0;
    var localOffset = Duration.zero;

    for (var i = 0; i < _playlist.length; i++) {
      final dur = _durationFor(_playlist[i]);
      if (accumulated + dur > globalPosition || i == _playlist.length - 1) {
        targetIndex = i;
        localOffset = globalPosition - accumulated;
        // Clamp agar tidak negatif atau melebihi durasi ayat
        if (localOffset < Duration.zero) localOffset = Duration.zero;
        if (localOffset > dur) {
          localOffset = dur - const Duration(milliseconds: 100);
        }
        break;
      }
      accumulated += dur;
    }

    if (targetIndex == _playlistIndex) {
      // Ayat sama — seek lokal langsung
      await _seekAudio(localOffset);
    } else {
      // Ayat berbeda — set pending seek, lalu play ayat target
      _pendingSeek = localOffset;
      _playlistIndex = targetIndex;
      await _playAtIndex(targetIndex);
    }
  }

  void _clearPlaylist() {
    _playlist = [];
    _playlistIndex = -1;
    _playlistSuratNomor = null;
    _playlistSuratName = null;
    _discoveredDurations.clear();
    _pendingSeek = null;
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    await super.close();
  }
}
