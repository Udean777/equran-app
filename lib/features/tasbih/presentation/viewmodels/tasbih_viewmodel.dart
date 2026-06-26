import 'package:equran_app/core/utils/failure_extension.dart';
import 'package:equran_app/features/tasbih/domain/entities/tasbih_preset.dart';
import 'package:equran_app/features/tasbih/domain/entities/tasbih_session.dart';
import 'package:equran_app/features/tasbih/domain/usecases/clear_tasbih_sessions.dart';
import 'package:equran_app/features/tasbih/domain/usecases/delete_tasbih_session.dart';
import 'package:equran_app/features/tasbih/domain/usecases/get_tasbih_sessions.dart';
import 'package:equran_app/features/tasbih/domain/usecases/save_tasbih_session.dart';
import 'package:equran_app/features/tasbih/presentation/providers.dart';
import 'package:equran_app/features/tasbih/presentation/viewmodels/tasbih_state.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Abstraksi haptic agar bisa di-mock di unit test.
typedef HapticCallback = Future<void> Function();

class TasbihViewModel extends Notifier<TasbihState> {
  GetTasbihSessions get _getSessions => ref.read(getTasbihSessionsProvider);
  SaveTasbihSession get _saveSession => ref.read(saveTasbihSessionProvider);
  DeleteTasbihSession get _deleteSession =>
      ref.read(deleteTasbihSessionProvider);
  ClearTasbihSessions get _clearSessions =>
      ref.read(clearTasbihSessionsProvider);

  final HapticCallback _lightImpact = HapticFeedback.lightImpact;
  final HapticCallback _heavyImpact = HapticFeedback.heavyImpact;

  @override
  TasbihState build() {
    return TasbihState(
      selectedPreset: TasbihPreset.defaults.first,
      target: TasbihPreset.defaults.first.defaultTarget,
    );
  }

  // ─── Counter ────────────────────────────────────────────────────────────────

  /// Tambah hitungan satu per satu. Trigger haptic jika aktif.
  Future<void> increment() async {
    if (state.isCompleted) return;

    if (state.hapticEnabled) {
      await _lightImpact();
    }

    final newCount = state.count + 1;
    final completed = newCount >= state.target;

    state = state.copyWith(count: newCount, isCompleted: completed);

    if (completed) {
      await _heavyImpact();
      await _persistSession();
    }
  }

  /// Reset hitungan ke 0, bersihkan status completed.
  void reset() {
    state = state.copyWith(count: 0, isCompleted: false, errorMessage: null);
  }

  // ─── Preset & Target ────────────────────────────────────────────────────────

  /// Ganti preset dzikir aktif, reset counter.
  void selectPreset(TasbihPreset preset) {
    state = state.copyWith(
      selectedPreset: preset,
      target: preset.defaultTarget,
      count: 0,
      isCompleted: false,
      errorMessage: null,
    );
  }

  /// Set target custom (misal 200x), reset counter.
  void setTarget(int target) {
    if (target <= 0) return;
    state = state.copyWith(
      target: target,
      count: 0,
      isCompleted: false,
      errorMessage: null,
    );
  }

  // ─── Settings ───────────────────────────────────────────────────────────────

  /// Toggle haptic feedback on/off.
  void toggleHaptic() {
    state = state.copyWith(hapticEnabled: !state.hapticEnabled);
  }

  // ─── Riwayat ────────────────────────────────────────────────────────────────

  /// Load semua riwayat sesi dari Hive.
  Future<void> loadSessions() async {
    final result = await _getSessions();
    result.fold(
      (failure) =>
          state = state.copyWith(errorMessage: failure.toUserMessage()),
      (sessions) =>
          state = state.copyWith(sessions: sessions, errorMessage: null),
    );
  }

  /// Hapus satu sesi dari riwayat.
  Future<void> deleteSession(String id) async {
    final result = await _deleteSession(id);
    result.fold(
      (failure) =>
          state = state.copyWith(errorMessage: failure.toUserMessage()),
      (_) => loadSessions(),
    );
  }

  /// Hapus semua riwayat sesi.
  Future<void> clearAllSessions() async {
    final result = await _clearSessions();
    result.fold(
      (failure) =>
          state = state.copyWith(errorMessage: failure.toUserMessage()),
      (_) => state = state.copyWith(sessions: [], errorMessage: null),
    );
  }

  // ─── Private ────────────────────────────────────────────────────────────────

  /// Simpan sesi yang baru selesai ke Hive.
  Future<void> _persistSession() async {
    state = state.copyWith(isSaving: true);

    final session = TasbihSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      presetId: state.selectedPreset.id,
      presetName: state.selectedPreset.name,
      count: state.count,
      target: state.target,
      createdAt: DateTime.now(),
    );

    final result = await _saveSession(session);
    result.fold(
      (failure) => state = state.copyWith(
        isSaving: false,
        errorMessage: failure.toUserMessage(),
      ),
      (_) {
        final updated = [session, ...state.sessions];
        state = state.copyWith(isSaving: false, sessions: updated);
      },
    );
  }
}
