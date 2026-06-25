import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/doa/domain/entities/doa.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'doa_list_state.freezed.dart';

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

    if (activeGrup != null) {
      result = result.where((d) => d.grup == activeGrup).toList();
    } else if (activeTag != null) {
      result = result.where((d) => d.tag.contains(activeTag)).toList();
    }

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
