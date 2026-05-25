import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_state_entity.freezed.dart';

/// Daftar qari yang tersedia dari API equran.id
enum Qari {
  abdullahAlMatrood('01', 'Abdullah Al-Matrood'),
  abdurrahmanAsSudais('02', 'Abdurrahman As-Sudais'),
  muhammadAyyoob('03', 'Muhammad Ayyoob'),
  muhammadJibreel('04', 'Muhammad Jibreel'),
  misyariRasyidAlAfasi('05', 'Misyari Rasyid Al-Afasi');

  const Qari(this.id, this.name);

  final String id;
  final String name;

  static Qari fromId(String id) => Qari.values.firstWhere(
    (q) => q.id == id,
    orElse: () => Qari.misyariRasyidAlAfasi,
  );
}

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
