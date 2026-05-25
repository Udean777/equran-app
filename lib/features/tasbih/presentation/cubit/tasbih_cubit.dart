import 'package:equran_app/core/utils/failure_extension.dart';
import 'package:equran_app/features/tasbih/domain/entities/tasbih_preset.dart';
import 'package:equran_app/features/tasbih/domain/entities/tasbih_session.dart';
import 'package:equran_app/features/tasbih/domain/usecases/clear_tasbih_sessions.dart';
import 'package:equran_app/features/tasbih/domain/usecases/delete_tasbih_session.dart';
import 'package:equran_app/features/tasbih/domain/usecases/get_tasbih_sessions.dart';
import 'package:equran_app/features/tasbih/domain/usecases/save_tasbih_session.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'tasbih_cubit.freezed.dart';
part 'tasbih_state.dart';

/// Abstraksi haptic agar bisa di-mock di unit test.
typedef HapticCallback = Future<void> Function();

@lazySingleton
class TasbihCubit extends Cubit<TasbihState> {
  TasbihCubit(
    this._getSessions,
    this._saveSession,
    this._deleteSession,
    this._clearSessions,
  ) : _lightImpact = HapticFeedback.lightImpact,
      _heavyImpact = HapticFeedback.heavyImpact,
      super(
        TasbihState(
          selectedPreset: TasbihPreset.defaults.first,
          target: TasbihPreset.defaults.first.defaultTarget,
        ),
      );

  /// Constructor khusus untuk testing — inject haptic callback custom.
  @visibleForTesting
  TasbihCubit.withHaptic(
    this._getSessions,
    this._saveSession,
    this._deleteSession,
    this._clearSessions, {
    HapticCallback? lightImpact,
    HapticCallback? heavyImpact,
  }) : _lightImpact = lightImpact ?? HapticFeedback.lightImpact,
       _heavyImpact = heavyImpact ?? HapticFeedback.heavyImpact,
       super(
         TasbihState(
           selectedPreset: TasbihPreset.defaults.first,
           target: TasbihPreset.defaults.first.defaultTarget,
         ),
       );

  final GetTasbihSessions _getSessions;
  final SaveTasbihSession _saveSession;
  final DeleteTasbihSession _deleteSession;
  final ClearTasbihSessions _clearSessions;
  final HapticCallback _lightImpact;
  final HapticCallback _heavyImpact;

  // ─── Counter ────────────────────────────────────────────────────────────────

  /// Tambah hitungan satu per satu. Trigger haptic jika aktif.
  Future<void> increment() async {
    if (state.isCompleted) return;

    if (state.hapticEnabled) {
      await _lightImpact();
    }

    final newCount = state.count + 1;
    final completed = newCount >= state.target;

    emit(state.copyWith(count: newCount, isCompleted: completed));

    if (completed) {
      await _heavyImpact();
      await _persistSession();
    }
  }

  /// Reset hitungan ke 0, bersihkan status completed.
  void reset() {
    emit(state.copyWith(count: 0, isCompleted: false, errorMessage: null));
  }

  // ─── Preset & Target ────────────────────────────────────────────────────────

  /// Ganti preset dzikir aktif, reset counter.
  void selectPreset(TasbihPreset preset) {
    emit(
      state.copyWith(
        selectedPreset: preset,
        target: preset.defaultTarget,
        count: 0,
        isCompleted: false,
        errorMessage: null,
      ),
    );
  }

  /// Set target custom (misal 200x), reset counter.
  void setTarget(int target) {
    if (target <= 0) return;
    emit(
      state.copyWith(
        target: target,
        count: 0,
        isCompleted: false,
        errorMessage: null,
      ),
    );
  }

  // ─── Settings ───────────────────────────────────────────────────────────────

  /// Toggle haptic feedback on/off.
  void toggleHaptic() {
    emit(state.copyWith(hapticEnabled: !state.hapticEnabled));
  }

  // ─── Riwayat ────────────────────────────────────────────────────────────────

  /// Load semua riwayat sesi dari Hive.
  Future<void> loadSessions() async {
    final result = await _getSessions();
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.toUserMessage())),
      (sessions) =>
          emit(state.copyWith(sessions: sessions, errorMessage: null)),
    );
  }

  /// Hapus satu sesi dari riwayat.
  Future<void> deleteSession(String id) async {
    final result = await _deleteSession(id);
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.toUserMessage())),
      (_) => loadSessions(),
    );
  }

  /// Hapus semua riwayat sesi.
  Future<void> clearAllSessions() async {
    final result = await _clearSessions();
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.toUserMessage())),
      (_) => emit(state.copyWith(sessions: [], errorMessage: null)),
    );
  }

  // ─── Private ────────────────────────────────────────────────────────────────

  /// Simpan sesi yang baru selesai ke Hive.
  Future<void> _persistSession() async {
    emit(state.copyWith(isSaving: true));

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
      (failure) => emit(
        state.copyWith(isSaving: false, errorMessage: failure.toUserMessage()),
      ),
      (_) {
        final updated = [session, ...state.sessions];
        emit(state.copyWith(isSaving: false, sessions: updated));
      },
    );
  }
}
