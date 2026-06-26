import 'package:equran_app/features/hafalan/domain/entities/hafalan_filter.dart';
import 'package:equran_app/features/hafalan/domain/entities/hafalan_stats.dart';
import 'package:equran_app/features/hafalan/domain/entities/hafalan_surat.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'hafalan_list_state.freezed.dart';

@freezed
sealed class HafalanListState with _$HafalanListState {
  const factory HafalanListState.initial() = HafalanListInitial;
  const factory HafalanListState.loading() = HafalanListLoading;

  const factory HafalanListState.success({
    required List<HafalanSurat> hafalanList,
    required HafalanStats stats,
    @Default([]) List<HafalanSurat> mergedList,
    @Default([]) List<HafalanSurat> filteredList,
    @Default(HafalanFilter.semua) HafalanFilter filter,
    @Default('') String searchQuery,
    @Default(null) int? selectedJuz,
    @Default({}) Map<int, List<HafalanSurat>> juzGroups,
    @Default([]) List<int> sortedJuz,
    String? errorMessage,
  }) = HafalanListSuccess;

  const factory HafalanListState.failure(String message) = HafalanListFailure;
}

extension HafalanListSuccessX on HafalanListSuccess {
  List<HafalanSurat> get suratMurajaahHariIni => hafalanList
      .where((h) => h.status == HafalanStatus.perluMurajaah)
      .toList();
}
