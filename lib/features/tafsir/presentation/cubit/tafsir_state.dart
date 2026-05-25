part of 'tafsir_cubit.dart';

@freezed
sealed class TafsirState with _$TafsirState {
  const factory TafsirState.initial() = TafsirInitial;
  const factory TafsirState.loading() = TafsirLoading;
  const factory TafsirState.success({
    required TafsirSurat tafsir,
  }) = TafsirSuccess;
  const factory TafsirState.failure({
    required Failure failure,
  }) = TafsirFailure;
}
