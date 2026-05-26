import 'dart:async';

import 'package:equran_app/features/jadwal_shalat/domain/entities/shalat_notif_prefs.dart';
import 'package:equran_app/features/jadwal_shalat/domain/usecases/get_shalat_notif_prefs.dart';
import 'package:equran_app/features/jadwal_shalat/domain/usecases/save_shalat_notif_prefs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@singleton
class ShalatNotifCubit extends Cubit<ShalatNotifPrefs> {
  ShalatNotifCubit(
    this._getPrefs,
    this._savePrefs,
  ) : super(const ShalatNotifPrefs());

  final GetShalatNotifPrefs _getPrefs;
  final SaveShalatNotifPrefs _savePrefs;

  /// Load preferensi dari Hive saat pertama kali dibuka.
  void load() {
    unawaited(
      _getPrefs().then((result) {
        result.fold(
          (_) => emit(const ShalatNotifPrefs()),
          emit,
        );
      }),
    );
  }

  /// Toggle notifikasi untuk waktu shalat tertentu.
  Future<void> toggleSubuh() => _update(state.copyWith(subuh: !state.subuh));
  Future<void> toggleDzuhur() =>
      _update(state.copyWith(dzuhur: !state.dzuhur));
  Future<void> toggleAshar() => _update(state.copyWith(ashar: !state.ashar));
  Future<void> toggleMaghrib() =>
      _update(state.copyWith(maghrib: !state.maghrib));
  Future<void> toggleIsya() => _update(state.copyWith(isya: !state.isya));

  /// Update menit sebelum notifikasi.
  Future<void> setMenitSebelum(int menit) =>
      _update(state.copyWith(menitSebelum: menit));

  Future<void> _update(ShalatNotifPrefs prefs) async {
    emit(prefs);
    await _savePrefs(prefs);
  }
}
