import 'package:equran_app/core/domain/entities/surat.dart';
import 'package:equran_app/core/error/failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'surat_list_state.freezed.dart';

enum SuratCompletionFilter { all, incomplete, completed }

@freezed
sealed class SuratListState with _$SuratListState {
  const factory SuratListState.initial() = SuratListInitial;
  const factory SuratListState.loading() = SuratListLoading;
  const factory SuratListState.success({
    required List<Surat> surats,
    @Default('') String query,
    @Default(SuratCompletionFilter.all) SuratCompletionFilter activeFilter,
  }) = SuratListSuccess;
  const factory SuratListState.failure({
    required Failure failure,
  }) = SuratListFailure;
}

extension SuratListSuccessX on SuratListSuccess {
  List<Surat> get filtered {
    if (query.isEmpty) return surats;
    final q = query.toLowerCase();
    return surats
        .where(
          (s) =>
              s.namaLatin.toLowerCase().contains(q) ||
              s.arti.toLowerCase().contains(q) ||
              s.nomor.toString().contains(q),
        )
        .toList();
  }
}
