import 'package:equran_app/features/hafalan/domain/entities/hafalan_surat.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'hafalan_detail_state.freezed.dart';

@freezed
sealed class HafalanDetailState with _$HafalanDetailState {
  const factory HafalanDetailState.initial() = HafalanDetailInitial;
  const factory HafalanDetailState.loading() = HafalanDetailLoading;
  const factory HafalanDetailState.success({
    HafalanSurat? hafalan,
  }) = HafalanDetailSuccess;
  const factory HafalanDetailState.failure(String message) =
      HafalanDetailFailure;
}
