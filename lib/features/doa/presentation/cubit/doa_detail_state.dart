part of 'doa_detail_cubit.dart';

@freezed
sealed class DoaDetailState with _$DoaDetailState {
  const factory DoaDetailState.initial() = DoaDetailInitial;
  const factory DoaDetailState.loading() = DoaDetailLoading;
  const factory DoaDetailState.success({
    required Doa doa,
    @Default(false) bool isBookmarked,
  }) = DoaDetailSuccess;
  const factory DoaDetailState.failure({
    required Failure failure,
  }) = DoaDetailFailure;
}
