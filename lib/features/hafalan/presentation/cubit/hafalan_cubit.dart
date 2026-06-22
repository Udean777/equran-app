import 'dart:async';

import 'package:equran_app/core/notifications/hafalan_reminder_scheduler.dart';
import 'package:equran_app/core/utils/failure_extension.dart';
import 'package:equran_app/features/hafalan/constants/murajaah_intervals.dart';
import 'package:equran_app/features/hafalan/domain/entities/hafalan_stats.dart';
import 'package:equran_app/features/hafalan/domain/entities/hafalan_surat.dart';
import 'package:equran_app/features/hafalan/domain/usecases/delete_hafalan_surat.dart';
import 'package:equran_app/features/hafalan/domain/usecases/get_all_hafalan.dart';
import 'package:equran_app/features/hafalan/domain/usecases/get_hafalan_stats.dart';
import 'package:equran_app/features/hafalan/domain/usecases/save_hafalan_surat.dart';
import 'package:equran_app/features/surat_detail/constants/juz_mapping.dart';
import 'package:equran_app/features/surat_list/domain/entities/surat.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'hafalan_cubit.freezed.dart';
part 'hafalan_state.dart';

@lazySingleton
class HafalanCubit extends Cubit<HafalanState> {
  HafalanCubit(
    this._getAllHafalan,
    this._saveHafalanSurat,
    this._deleteHafalanSurat,
    this._getHafalanStats,
    this._reminderScheduler,
  ) : super(const HafalanState.initial());

  final GetAllHafalan _getAllHafalan;
  final SaveHafalanSurat _saveHafalanSurat;
  final DeleteHafalanSurat _deleteHafalanSurat;
  final GetHafalanStats _getHafalanStats;
  final HafalanReminderScheduler _reminderScheduler;

  /// Cache semua surat — di-set dari HafalanPage via [setAllSurat].
  List<Surat> _allSurat = [];

  // ─── Load ────────────────────────────────────────────────────────────────────

  /// Set daftar semua surat — dipanggil dari HafalanPage saat SuratListCubit success.
  /// Trigger recompute mergedList + filteredList jika state sudah success.
  void setAllSurat(List<Surat> allSurat) {
    if (_allSurat.isNotEmpty) return;
    _allSurat = allSurat;
    final current = _currentState;
    if (current != null) {
      emit(_withComputedLists(current));
    }
  }

  /// Load semua hafalan dan statistik dari Hive.
  Future<void> load() async {
    emit(const HafalanState.loading());

    final hafalanResult = await _getAllHafalan();
    final statsResult = await _getHafalanStats();

    hafalanResult.fold(
      (failure) => emit(HafalanState.failure(failure.toUserMessage())),
      (list) => statsResult.fold(
        (failure) => emit(HafalanState.failure(failure.toUserMessage())),
        (stats) {
          final base =
              HafalanState.success(
                    hafalanList: list,
                    stats: stats,
                    filter: _currentState?.filter ?? HafalanFilter.semua,
                  )
                  as HafalanSuccess;
          emit(_withComputedLists(base));
        },
      ),
    );
  }

  // ─── Toggle Ayat ─────────────────────────────────────────────────────────────

  /// Toggle ayat hafal/belum hafal.
  /// Jika surat belum ada di Hive, buat entry baru dari [suratInfo].
  Future<void> toggleAyat({
    required int suratNomor,
    required int ayatNomor,
    required HafalanSurat suratInfo,
  }) async {
    final current = _currentState;
    if (current == null) return;

    final existing =
        getSurat(suratNomor) ??
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

  /// Update seluruh list ayat hafal untuk surat tertentu dalam satu operasi.
  /// Dipanggil saat menyimpan hasil setoran untuk mencegah race condition.
  Future<void> saveAyatHafalList({
    required int suratNomor,
    required List<int> newAyatHafal,
    required HafalanSurat suratInfo,
  }) async {
    final current = _currentState;
    if (current == null) return;

    final existing =
        getSurat(suratNomor) ??
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

  // ─── Set Status ──────────────────────────────────────────────────────────────

  /// Override status hafalan secara manual.
  Future<void> setStatus({
    required int suratNomor,
    required HafalanStatus status,
  }) async {
    final existing = getSurat(suratNomor);
    if (existing == null) return;

    // Jika di-set ke sudahHafal manual, tandai semua ayat & set tanggal selesai
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

  // ─── Muraja'ah ───────────────────────────────────────────────────────────────

  /// Tandai surat sudah dimuraja'ah → naik level, hitung tanggal berikutnya.
  Future<void> tandaiSudahMurajaah(int suratNomor) async {
    final existing = getSurat(suratNomor);
    if (existing == null) return;

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

  /// Override tanggal muraja'ah secara manual.
  Future<void> setMurajaahDate({
    required int suratNomor,
    required DateTime tanggal,
  }) async {
    final existing = getSurat(suratNomor);
    if (existing == null) return;

    final updated = existing.copyWith(
      tanggalMurajaahBerikutnya: tanggal,
    );

    await _saveAndReload(updated);
  }

  // ─── Save (public) ───────────────────────────────────────────────────────────

  /// Simpan hafalan langsung — digunakan untuk update catatan dari detail page.
  Future<void> saveHafalanSurat(HafalanSurat hafalan) =>
      _saveAndReload(hafalan);

  // ─── Delete ──────────────────────────────────────────────────────────────────

  /// Hapus data hafalan surat dari Hive.
  Future<void> deleteSurat(int suratNomor) async {
    await _reminderScheduler.cancelReminder(suratNomor);
    final result = await _deleteHafalanSurat(suratNomor);
    result.fold(
      (failure) => _emitError(failure.toUserMessage()),
      (_) => load(),
    );
  }

  // ─── Filter ──────────────────────────────────────────────────────────────────

  /// Set filter tampilan list hafalan — recompute filteredList + juzGroups di cubit.
  void setFilter(HafalanFilter filter) {
    final current = _currentState;
    if (current == null) return;
    emit(_withComputedLists(current.copyWith(filter: filter)));
  }

  /// Set search query — recompute filteredList + juzGroups di cubit.
  void setSearchQuery(String query) {
    final current = _currentState;
    if (current == null) return;
    emit(_withComputedLists(current.copyWith(searchQuery: query)));
  }

  /// Set juz yang dipilih — null berarti semua juz.
  void setSelectedJuz(int? juz) {
    final current = _currentState;
    if (current == null) return;
    emit(_withComputedLists(current.copyWith(selectedJuz: juz)));
  }

  // ─── Helpers (public) ────────────────────────────────────────────────────────

  /// Ambil data hafalan surat tertentu dari state saat ini.
  /// Return null jika belum ada atau state bukan success.
  HafalanSurat? getSurat(int suratNomor) {
    final current = _currentState;
    if (current == null) return null;
    final matches = current.hafalanList.where(
      (h) => h.suratNomor == suratNomor,
    );
    return matches.isEmpty ? null : matches.first;
  }

  /// Cek apakah ayat tertentu sudah ditandai hafal.
  bool isAyatHafal({required int suratNomor, required int ayatNomor}) {
    return getSurat(suratNomor)?.ayatHafal.contains(ayatNomor) ?? false;
  }

  // ─── Helpers (private) ───────────────────────────────────────────────────────

  HafalanSuccess? get _currentState =>
      state is HafalanSuccess ? state as HafalanSuccess : null;

  void _emitError(String message) {
    final current = _currentState;
    if (current != null) {
      emit(current.copyWith(errorMessage: message));
    } else {
      emit(HafalanState.failure(message));
    }
  }

  /// Hitung mergedList + filteredList + juzGroups dan kembalikan state baru.
  HafalanSuccess _withComputedLists(HafalanSuccess base) {
    final merged = _mergeWithAllSurat(base.hafalanList);
    final filtered = _applyFilters(merged, base.filter, base.searchQuery);
    final juzGroups = _groupByJuz(filtered, base.selectedJuz);
    return base.copyWith(
      mergedList: merged,
      filteredList: filtered,
      juzGroups: juzGroups,
      sortedJuz: juzGroups.keys.toList()..sort(),
    );
  }

  /// Merge hafalanList dengan semua 114 surat dari [_allSurat].
  /// Surat yang belum ada di hafalanList dibuat sebagai HafalanSurat default.
  List<HafalanSurat> _mergeWithAllSurat(List<HafalanSurat> hafalanList) {
    if (_allSurat.isEmpty) return hafalanList;
    final hafalanMap = {for (final h in hafalanList) h.suratNomor: h};
    return _allSurat.map((surat) {
      return hafalanMap[surat.nomor] ??
          HafalanSurat(
            suratNomor: surat.nomor,
            namaLatin: surat.namaLatin,
            nama: surat.nama,
            jumlahAyat: surat.jumlahAyat,
          );
    }).toList();
  }

  /// Filter mergedList berdasarkan [filter] dan [searchQuery].
  List<HafalanSurat> _applyFilters(
    List<HafalanSurat> list,
    HafalanFilter filter,
    String searchQuery,
  ) {
    var result = switch (filter) {
      HafalanFilter.semua => list,
      HafalanFilter.sedangDihafal =>
        list.where((h) => h.status == HafalanStatus.sedangDihafal).toList(),
      HafalanFilter.sudahHafal =>
        list.where((h) => h.status == HafalanStatus.sudahHafal).toList(),
      HafalanFilter.perluMurajaah =>
        list.where((h) => h.status == HafalanStatus.perluMurajaah).toList(),
    };

    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      result = result.where((h) {
        return h.namaLatin.toLowerCase().contains(query) ||
            h.nama.toLowerCase().contains(query) ||
            h.suratNomor.toString().contains(query);
      }).toList();
    }

    return result;
  }

  /// Group filteredList berdasarkan juz menggunakan [kJuzToSurahMapping].
  /// Jika [selectedJuz] tidak null, hanya tampilkan juz tersebut.
  Map<int, List<HafalanSurat>> _groupByJuz(
    List<HafalanSurat> list,
    int? selectedJuz,
  ) {
    final hafalanMap = {for (final h in list) h.suratNomor: h};
    final juzGroups = <int, List<HafalanSurat>>{};

    for (final entry in kJuzToSurahMapping.entries) {
      final juzNomor = entry.key;
      if (selectedJuz != null && selectedJuz != juzNomor) continue;

      final suratsInJuz = <HafalanSurat>[];
      for (final nomor in entry.value) {
        final hafalan = hafalanMap[nomor];
        if (hafalan != null) suratsInJuz.add(hafalan);
      }

      if (suratsInJuz.isNotEmpty) {
        juzGroups[juzNomor] = suratsInJuz;
      }
    }

    return juzGroups;
  }

  /// Simpan hafalan ke Hive lalu reload state + schedule/cancel notifikasi.
  Future<void> _saveAndReload(HafalanSurat hafalan) async {
    final result = await _saveHafalanSurat(hafalan);
    result.fold(
      (failure) => _emitError(failure.toUserMessage()),
      (_) async {
        // Schedule atau cancel notifikasi muraja'ah
        if (hafalan.tanggalMurajaahBerikutnya != null &&
            !hafalan.isMurajaahSelesai) {
          await _reminderScheduler.scheduleReminder(hafalan);
        } else {
          await _reminderScheduler.cancelReminder(hafalan.suratNomor);
        }
        if (!isClosed) await load();
      },
    );
  }
}
