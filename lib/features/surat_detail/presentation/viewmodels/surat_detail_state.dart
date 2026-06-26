import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'surat_detail_state.freezed.dart';

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
