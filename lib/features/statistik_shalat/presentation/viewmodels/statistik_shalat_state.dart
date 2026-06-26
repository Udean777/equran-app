part of 'statistik_shalat_viewmodel.dart';

@freezed
abstract class StatistikShalatState with _$StatistikShalatState {
  const factory StatistikShalatState.initial() = _Initial;
  const factory StatistikShalatState.loading() = _Loading;
  const factory StatistikShalatState.success({
    required ShalatDayStats today,
    required ShalatStats stats,
  }) = _Success;
  const factory StatistikShalatState.failure(String message) = _Failure;
}
