part of 'surat_detail_cubit.dart';

@freezed
sealed class SuratDetailState with _$SuratDetailState {
  const factory SuratDetailState.initial() = SuratDetailInitial;
  const factory SuratDetailState.loading() = SuratDetailLoading;
  const factory SuratDetailState.success({
    required SuratDetail detail,
  }) = SuratDetailSuccess;
  const factory SuratDetailState.failure({
    required Failure failure,
  }) = SuratDetailFailure;
}
