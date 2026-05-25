part of 'doa_list_cubit.dart';

@freezed
sealed class DoaListState with _$DoaListState {
  const factory DoaListState.initial() = DoaListInitial;
  const factory DoaListState.loading() = DoaListLoading;
  const factory DoaListState.success({
    required List<Doa> allDoa,
    required List<String> grupList,
    required List<String> tagList,
    @Default('') String query,
    String? activeGrup,
    String? activeTag,
  }) = DoaListSuccess;
  const factory DoaListState.failure({
    required Failure failure,
  }) = DoaListFailure;
}

extension DoaListSuccessX on DoaListSuccess {
  List<Doa> get filtered {
    var result = allDoa;

    // Filter by grup (XOR tag)
    if (activeGrup != null) {
      result = result.where((d) => d.grup == activeGrup).toList();
    } else if (activeTag != null) {
      result = result.where((d) => d.tag.contains(activeTag)).toList();
    }

    // Search: nama + idn + grup
    if (query.isNotEmpty) {
      final q = query.toLowerCase();
      result = result
          .where(
            (d) =>
                d.nama.toLowerCase().contains(q) ||
                d.idn.toLowerCase().contains(q) ||
                d.grup.toLowerCase().contains(q),
          )
          .toList();
    }

    return result;
  }

  bool get hasActiveFilter => activeGrup != null || activeTag != null;

  String get activeFilterLabel {
    if (activeGrup != null) return activeGrup!;
    if (activeTag != null) return '#$activeTag';
    return '';
  }
}
