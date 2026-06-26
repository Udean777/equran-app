import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/catatan_ayat/domain/entities/catatan_ayat.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'catatan_ayat_state.freezed.dart';

@freezed
sealed class CatatanAyatState with _$CatatanAyatState {
  const factory CatatanAyatState.initial() = CatatanAyatInitial;
  const factory CatatanAyatState.loading() = CatatanAyatLoading;
  const factory CatatanAyatState.success(List<CatatanAyat> catatan) =
      CatatanAyatSuccess;
  const factory CatatanAyatState.failure(Failure failure) = CatatanAyatFailure;
}
