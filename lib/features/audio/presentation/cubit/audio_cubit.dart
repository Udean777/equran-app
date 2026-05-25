import 'dart:async';

import 'package:equran_app/features/audio/domain/entities/audio_state_entity.dart';
import 'package:equran_app/features/audio/domain/repositories/audio_repository.dart';
import 'package:equran_app/features/audio/domain/usecases/pause_audio.dart';
import 'package:equran_app/features/audio/domain/usecases/play_audio.dart';
import 'package:equran_app/features/audio/domain/usecases/resume_audio.dart';
import 'package:equran_app/features/audio/domain/usecases/seek_audio.dart';
import 'package:equran_app/features/audio/domain/usecases/stop_audio.dart';
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

  void _listenToStream() {
    _subscription = _repository.stateStream.listen(emit);
  }

  /// Play audio ayat. Jika ayat yang sama sedang play → toggle pause/resume.
  Future<void> playOrToggle({
    required String url,
    required int ayatNomor,
    required Qari qari,
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

    // Play ayat baru
    await _playAudio(PlayAudioParams(url: url, ayatNomor: ayatNomor, qari: qari));
  }

  Future<void> pause() => _pauseAudio();
  Future<void> resume() => _resumeAudio();
  Future<void> stop() => _stopAudio();
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

    await _playAudio(
      PlayAudioParams(url: url, ayatNomor: currentAyat, qari: qari),
    );
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    await super.close();
  }
}
