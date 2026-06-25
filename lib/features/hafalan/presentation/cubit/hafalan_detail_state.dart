import 'package:equran_app/features/hafalan/domain/entities/hafalan_surat.dart';
import 'package:equran_app/features/hafalan/domain/entities/setoran_compare_result.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'hafalan_detail_state.freezed.dart';

@freezed
sealed class HafalanDetailState with _$HafalanDetailState {
  const factory HafalanDetailState.initial() = HafalanDetailInitial;
  const factory HafalanDetailState.loading() = HafalanDetailLoading;
  const factory HafalanDetailState.connectingToServer() =
      HafalanDetailConnectingToServer;
  const factory HafalanDetailState.success({
    HafalanSurat? hafalan,
  }) = HafalanDetailSuccess;
  const factory HafalanDetailState.failure(String message) =
      HafalanDetailFailure;
  const factory HafalanDetailState.comparing(int ayatNomor) =
      HafalanDetailComparing;
  const factory HafalanDetailState.compareSuccess({
    required int ayatNomor,
    required SetoranCompareResult result,
    required String audioPath,
  }) = HafalanDetailCompareSuccess;
  const factory HafalanDetailState.compareFailure({
    required int ayatNomor,
    required String message,
  }) = HafalanDetailCompareFailure;
}
