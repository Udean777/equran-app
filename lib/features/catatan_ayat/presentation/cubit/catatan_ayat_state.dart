part of 'catatan_ayat_cubit.dart';

@freezed
sealed class CatatanAyatState with _$CatatanAyatState {
  const factory CatatanAyatState.initial() = CatatanAyatInitial;
  const factory CatatanAyatState.loading() = CatatanAyatLoading;
  const factory CatatanAyatState.success(List<CatatanAyat> catatan) =
      CatatanAyatSuccess;
  const factory CatatanAyatState.failure(String message) = CatatanAyatFailure;
}
