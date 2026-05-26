part of 'hafalan_cubit.dart';

/// Filter untuk tampilan list hafalan di HafalanPage.
enum HafalanFilter { semua, sedangDihafal, sudahHafal, perluMurajaah }

@freezed
sealed class HafalanState with _$HafalanState {
  const factory HafalanState.initial() = HafalanInitial;
  const factory HafalanState.loading() = HafalanLoading;

  const factory HafalanState.success({
    required List<HafalanSurat> hafalanList,
    required HafalanStats stats,
    /// Merged: semua 114 surat + data hafalan yang ada. Dihitung di cubit.
    @Default([]) List<HafalanSurat> mergedList,
    /// Filtered: mergedList setelah filter diterapkan. Dihitung di cubit.
    @Default([]) List<HafalanSurat> filteredList,
    @Default(HafalanFilter.semua) HafalanFilter filter,
    String? errorMessage,
  }) = HafalanSuccess;

  const factory HafalanState.failure(String message) = HafalanFailure;
}

extension HafalanSuccessX on HafalanSuccess {
  /// Surat yang jatuh tempo muraja'ah — untuk home card.
  List<HafalanSurat> get suratMurajaahHariIni => hafalanList
      .where((h) => h.status == HafalanStatus.perluMurajaah)
      .toList();
}
