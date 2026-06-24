import 'dart:async';

import 'package:equran_app/features/hafalan/constants/murajaah_intervals.dart';
import 'package:equran_app/features/hafalan/domain/entities/hafalan_surat.dart';
import 'package:equran_app/features/hafalan/domain/usecases/delete_hafalan_surat.dart';
import 'package:equran_app/features/hafalan/domain/usecases/get_hafalan_by_surat.dart';
import 'package:equran_app/features/hafalan/domain/usecases/params/hafalan_params.dart';
import 'package:equran_app/features/hafalan/domain/usecases/params/save_hafalan_params.dart';
import 'package:equran_app/features/hafalan/domain/usecases/save_hafalan_surat.dart';
import 'package:equran_app/features/hafalan/notifications/hafalan_reminder_scheduler.dart';
import 'package:equran_app/features/hafalan/presentation/cubit/hafalan_detail_state.dart';
import 'package:equran_app/features/hafalan/presentation/cubit/hafalan_list_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class HafalanDetailCubit extends Cubit<HafalanDetailState> {
  HafalanDetailCubit(
    this._getHafalanBySurat,
    this._saveHafalanSurat,
    this._deleteHafalanSurat,
    this._reminderScheduler,
    this._listCubit,
  ) : super(const HafalanDetailState.initial());

  final GetHafalanBySurat _getHafalanBySurat;
  final SaveHafalanSurat _saveHafalanSurat;
  final DeleteHafalanSurat _deleteHafalanSurat;
  final HafalanReminderScheduler _reminderScheduler;
  final HafalanListCubit _listCubit;

  Future<void> loadDetail(int suratNomor) async {
    emit(const HafalanDetailState.loading());

    final result = await _getHafalanBySurat(HafalanSuratParams(suratNomor));
    result.fold(
      (failure) =>
          emit(const HafalanDetailState.failure('Gagal memuat detail')),
      (hafalan) => emit(HafalanDetailState.success(hafalan: hafalan)),
    );
  }

  Future<void> toggleAyat({
    required int suratNomor,
    required int ayatNomor,
    required HafalanSurat suratInfo,
  }) async {
    final current = _currentState;
    if (current == null) return;

    final existing =
        current.hafalan ??
        HafalanSurat(
          suratNomor: suratInfo.suratNomor,
          namaLatin: suratInfo.namaLatin,
          nama: suratInfo.nama,
          jumlahAyat: suratInfo.jumlahAyat,
          status: HafalanStatus.sedangDihafal,
          tanggalMulai: DateTime.now(),
        );

    final updated = existing.withToggledAyat(ayatNomor);
    await _saveAndReload(updated);
  }

  Future<void> saveAyatHafalList({
    required int suratNomor,
    required List<int> newAyatHafal,
    required HafalanSurat suratInfo,
  }) async {
    final current = _currentState;
    if (current == null) return;

    final existing =
        current.hafalan ??
        HafalanSurat(
          suratNomor: suratInfo.suratNomor,
          namaLatin: suratInfo.namaLatin,
          nama: suratInfo.nama,
          jumlahAyat: suratInfo.jumlahAyat,
          status: HafalanStatus.sedangDihafal,
          tanggalMulai: DateTime.now(),
        );

    final updated = existing.withAyatHafalList(newAyatHafal);
    await _saveAndReload(updated);
  }

  Future<void> setStatus({
    required int suratNomor,
    required HafalanStatus status,
  }) async {
    final current = _currentState;
    if (current?.hafalan == null) return;

    final existing = current!.hafalan!;
    final updated = status == HafalanStatus.sudahHafal
        ? existing.copyWith(
            status: HafalanStatus.sudahHafal,
            ayatHafal: List.generate(existing.jumlahAyat, (i) => i + 1),
            tanggalSelesai: existing.tanggalSelesai ?? DateTime.now(),
            murajaahLevel: existing.murajaahLevel,
            tanggalMurajaahBerikutnya:
                existing.tanggalMurajaahBerikutnya ??
                existing.nextMurajaahDate(existing.murajaahLevel),
          )
        : existing.copyWith(status: status);

    await _saveAndReload(updated);
  }

  Future<void> tandaiSudahMurajaah(int suratNomor) async {
    final current = _currentState;
    if (current?.hafalan == null) return;

    final existing = current!.hafalan!;
    final newLevel = (existing.murajaahLevel + 1).clamp(0, kMurajaahMaxLevel);
    final nextDate = newLevel >= kMurajaahMaxLevel
        ? null
        : existing.nextMurajaahDate(newLevel);

    final updated = existing.copyWith(
      status: HafalanStatus.sudahHafal,
      murajaahLevel: newLevel,
      tanggalMurajaahBerikutnya: nextDate,
    );

    await _saveAndReload(updated);
  }

  Future<void> setMurajaahDate({
    required int suratNomor,
    required DateTime tanggal,
  }) async {
    final current = _currentState;
    if (current?.hafalan == null) return;

    final updated = current!.hafalan!.copyWith(
      tanggalMurajaahBerikutnya: tanggal,
    );

    await _saveAndReload(updated);
  }

  Future<void> saveSetoranHasil({
    required int suratNomor,
    required Map<int, bool> hasil,
    required HafalanSurat suratInfo,
  }) async {
    final current = _currentState;
    final existing =
        current?.hafalan ??
        suratInfo.copyWith(
          status: HafalanStatus.sedangDihafal,
          tanggalMulai: DateTime.now(),
        );

    final ayatHafalBaru = <int>{...existing.ayatHafal};
    for (final entry in hasil.entries) {
      if (entry.value) {
        ayatHafalBaru.add(entry.key);
      } else {
        ayatHafalBaru.remove(entry.key);
      }
    }

    final updated = existing.withAyatHafalList(ayatHafalBaru.toList()..sort());
    await _saveAndReload(updated);
  }

  Future<void> saveHafalanSurat(HafalanSurat hafalan) =>
      _saveAndReload(hafalan);

  Future<void> deleteSurat(int suratNomor) async {
    await _reminderScheduler.cancelReminder(suratNomor);
    final result = await _deleteHafalanSurat(HafalanSuratParams(suratNomor));
    result.fold(
      (failure) =>
          emit(const HafalanDetailState.failure('Gagal menghapus data')),
      (_) async {
        emit(const HafalanDetailState.initial());
        if (!isClosed) await _listCubit.load();
      },
    );
  }

  HafalanDetailSuccess? get _currentState =>
      state is HafalanDetailSuccess ? state as HafalanDetailSuccess : null;

  Future<void> _saveAndReload(HafalanSurat hafalan) async {
    final result = await _saveHafalanSurat(SaveHafalanParams(hafalan));
    result.fold(
      (failure) =>
          emit(const HafalanDetailState.failure('Gagal menyimpan data')),
      (_) async {
        if (hafalan.tanggalMurajaahBerikutnya != null &&
            !hafalan.isMurajaahSelesai) {
          await _reminderScheduler.scheduleReminder(hafalan);
        } else {
          await _reminderScheduler.cancelReminder(hafalan.suratNomor);
        }
        if (!isClosed) {
          await loadDetail(hafalan.suratNomor);
          await _listCubit.load();
        }
      },
    );
  }
}
