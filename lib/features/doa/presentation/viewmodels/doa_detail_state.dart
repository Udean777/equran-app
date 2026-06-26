import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/doa/domain/entities/doa.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'doa_detail_state.freezed.dart';

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
