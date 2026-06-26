import 'package:equran_app/features/audio/domain/entities/downloaded_ayat_info.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_storage_state.freezed.dart';

@freezed
sealed class AudioStorageState with _$AudioStorageState {
  const factory AudioStorageState.initial() = AudioStorageInitial;
  const factory AudioStorageState.loading() = AudioStorageLoading;
  const factory AudioStorageState.success({
    required List<DownloadedAyatInfo> files,
    required int totalBytes,
  }) = AudioStorageSuccess;
  const factory AudioStorageState.error({required String message}) =
      AudioStorageError;
}
