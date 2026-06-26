import 'package:equran_app/features/qibla/domain/entities/qibla_direction.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'qibla_state.freezed.dart';

@freezed
sealed class QiblaState with _$QiblaState {
  /// State awal sebelum apapun dimulai.
  const factory QiblaState.initial() = QiblaInitial;

  /// Sedang request permission + ambil koordinat.
  const factory QiblaState.loading() = QiblaLoading;

  /// Stream aktif, data kompas masuk.
  const factory QiblaState.loaded({
    required QiblaDirection direction,
  }) = QiblaLoaded;

  /// Permission ditolak, GPS mati, atau error lainnya.
  const factory QiblaState.error({
    required String message,
  }) = QiblaError;

  /// Perangkat tidak memiliki sensor kompas.
  const factory QiblaState.noSensor() = QiblaNoSensor;
}
