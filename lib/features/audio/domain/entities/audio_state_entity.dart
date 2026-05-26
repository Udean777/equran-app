import 'package:equran_app/features/audio/domain/entities/qari.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

export 'qari.dart';

part 'audio_state_entity.freezed.dart';

@freezed
sealed class AudioPlayerState with _$AudioPlayerState {
  /// Tidak ada audio yang dipilih
  const factory AudioPlayerState.idle() = AudioIdle;

  /// Sedang load audio
  const factory AudioPlayerState.loading({
    required int ayatNomor,
    required Qari qari,
  }) = AudioLoading;

  /// Sedang play
  const factory AudioPlayerState.playing({
    required int ayatNomor,
    required Qari qari,
    required Duration position,
    required Duration duration,
  }) = AudioPlaying;

  /// Pause
  const factory AudioPlayerState.paused({
    required int ayatNomor,
    required Qari qari,
    required Duration position,
    required Duration duration,
  }) = AudioPaused;

  /// Error
  const factory AudioPlayerState.error({
    required String message,
  }) = AudioError;
}

extension AudioPlayerStateX on AudioPlayerState {
  bool get isIdle => this is AudioIdle;
  bool get isLoading => this is AudioLoading;
  bool get isPlaying => this is AudioPlaying;
  bool get isPaused => this is AudioPaused;

  int? get currentAyat => mapOrNull(
    loading: (s) => s.ayatNomor,
    playing: (s) => s.ayatNomor,
    paused: (s) => s.ayatNomor,
  );

  Qari get currentQari => maybeMap(
    loading: (s) => s.qari,
    playing: (s) => s.qari,
    paused: (s) => s.qari,
    orElse: () => Qari.misyariRasyidAlAfasi,
  );

  Duration get position => maybeMap(
    playing: (s) => s.position,
    paused: (s) => s.position,
    orElse: () => Duration.zero,
  );

  Duration get duration => maybeMap(
    playing: (s) => s.duration,
    paused: (s) => s.duration,
    orElse: () => Duration.zero,
  );
}
