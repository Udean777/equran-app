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
    @Default(HafalanFilter.semua) HafalanFilter filter,
    String? errorMessage,
  }) = HafalanSuccess;

  const factory HafalanState.failure(String message) = HafalanFailure;
}

extension HafalanSuccessX on HafalanSuccess {
  /// List hafalan yang sudah difilter sesuai [filter].
  List<HafalanSurat> get filteredList {
    switch (filter) {
      case HafalanFilter.semua:
        return hafalanList;
      case HafalanFilter.sedangDihafal:
        return hafalanList
            .where((h) => h.status == HafalanStatus.sedangDihafal)
            .toList();
      case HafalanFilter.sudahHafal:
        return hafalanList
            .where((h) => h.status == HafalanStatus.sudahHafal)
            .toList();
      case HafalanFilter.perluMurajaah:
        return hafalanList
            .where((h) => h.status == HafalanStatus.perluMurajaah)
            .toList();
    }
  }

  /// Surat yang jatuh tempo muraja'ah — untuk home card.
  List<HafalanSurat> get suratMurajaahHariIni => hafalanList
      .where((h) => h.status == HafalanStatus.perluMurajaah)
      .toList();
}
