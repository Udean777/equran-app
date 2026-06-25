import 'package:equran_app/features/tasbih/domain/entities/tasbih_preset.dart';
import 'package:equran_app/features/tasbih/domain/entities/tasbih_session.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tasbih_state.freezed.dart';

@freezed
sealed class TasbihState with _$TasbihState {
  const factory TasbihState({
    /// Preset dzikir yang sedang aktif.
    required TasbihPreset selectedPreset,

    /// Target hitungan saat ini (bisa custom atau dari preset).
    required int target,

    /// Hitungan saat ini.
    @Default(0) int count,

    /// Apakah target sudah tercapai.
    @Default(false) bool isCompleted,

    /// Toggle haptic feedback.
    @Default(true) bool hapticEnabled,

    /// Status loading saat simpan/load riwayat.
    @Default(false) bool isSaving,

    /// Riwayat sesi yang sudah tersimpan.
    @Default([]) List<TasbihSession> sessions,

    /// Pesan error jika ada.
    String? errorMessage,
  }) = _TasbihState;
}

extension TasbihStateX on TasbihState {
  /// Progress 0.0 - 1.0 untuk progress indicator.
  double get progress => target == 0 ? 0 : (count / target).clamp(0.0, 1.0);

  /// Sisa hitungan menuju target.
  int get remaining => (target - count).clamp(0, target);
}
