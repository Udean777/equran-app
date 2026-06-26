import 'dart:async';

import 'package:equran_app/core/constants/juz_constants.dart';
import 'package:equran_app/core/domain/entities/surat.dart';
import 'package:equran_app/core/utils/failure_extension.dart';
import 'package:equran_app/features/hafalan/domain/entities/hafalan_filter.dart';
import 'package:equran_app/features/hafalan/domain/entities/hafalan_stats.dart';
import 'package:equran_app/features/hafalan/domain/entities/hafalan_surat.dart';
import 'package:equran_app/features/hafalan/domain/usecases/get_all_hafalan.dart';
import 'package:equran_app/features/hafalan/domain/usecases/get_hafalan_stats.dart';
import 'package:equran_app/features/hafalan/presentation/viewmodels/hafalan_list_state.dart';
import 'package:equran_app/features/surat_list/domain/usecases/get_surat_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HafalanListViewModel extends StateNotifier<HafalanListState> {
  HafalanListViewModel(
    this._getAllHafalan,
    this._getHafalanStats,
    this._getSuratList,
  ) : super(const HafalanListState.initial());

  final GetAllHafalan _getAllHafalan;
  final GetHafalanStats _getHafalanStats;
  final GetSuratList _getSuratList;

  List<Surat> _allSurat = [];

  void setAllSurat(List<Surat> allSurat) {
    if (_allSurat.isNotEmpty) return;
    _allSurat = allSurat;
    final current = _currentState;
    if (current != null) {
      state = _withComputedLists(current);
    }
  }

  Future<void> load() async {
    state = const HafalanListState.loading();

    final hafalanResult = await _getAllHafalan();
    final statsResult = await _getHafalanStats();
    final suratResult = await _getSuratList();

    final failures = <String>[];
    List<HafalanSurat>? hafalanList;
    HafalanStats? stats;
    List<Surat>? suratList;

    hafalanResult.fold(
      (f) => failures.add(f.toUserMessage()),
      (r) => hafalanList = r,
    );
    statsResult.fold(
      (f) => failures.add(f.toUserMessage()),
      (r) => stats = r,
    );
    suratResult.fold(
      (f) => failures.add(f.toUserMessage()),
      (r) => suratList = r,
    );

    if (failures.isNotEmpty) {
      state = HafalanListState.failure(failures.first);
      return;
    }

    _allSurat = suratList!;
    final base =
        HafalanListState.success(
              hafalanList: hafalanList!,
              stats: stats!,
              filter: _currentState?.filter ?? HafalanFilter.semua,
            )
            as HafalanListSuccess;
    state = _withComputedLists(base);
  }

  void setFilter(HafalanFilter filter) {
    final current = _currentState;
    if (current == null) return;
    state = _withComputedLists(current.copyWith(filter: filter));
  }

  void setSearchQuery(String query) {
    final current = _currentState;
    if (current == null) return;
    state = _withComputedLists(current.copyWith(searchQuery: query));
  }

  void setSelectedJuz(int? juz) {
    final current = _currentState;
    if (current == null) return;
    state = _withComputedLists(current.copyWith(selectedJuz: juz));
  }

  HafalanSurat? getSurat(int suratNomor) {
    final current = _currentState;
    if (current == null) return null;
    final matches = current.hafalanList.where(
      (h) => h.suratNomor == suratNomor,
    );
    return matches.isEmpty ? null : matches.first;
  }

  HafalanListSuccess? get _currentState =>
      state is HafalanListSuccess ? state as HafalanListSuccess : null;

  HafalanListSuccess _withComputedLists(HafalanListSuccess base) {
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

  List<HafalanSurat> _mergeWithAllSurat(List<HafalanSurat> hafalanList) {
    if (_allSurat.isEmpty) return hafalanList;
    final hafalanMap = {for (final h in hafalanList) h.suratNomor: h};
    return _allSurat.map((surat) {
      return hafalanMap[surat.nomor] ?? HafalanSurat.fromSurat(surat);
    }).toList();
  }

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

  Map<int, List<HafalanSurat>> _groupByJuz(
    List<HafalanSurat> list,
    int? selectedJuz,
  ) {
    final hafalanMap = {for (final h in list) h.suratNomor: h};
    final juzGroups = <int, List<HafalanSurat>>{};

    for (final entry in JuzConstants.surahPerJuz.entries) {
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
}
