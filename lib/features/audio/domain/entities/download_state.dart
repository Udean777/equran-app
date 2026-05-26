import 'package:freezed_annotation/freezed_annotation.dart';

part 'download_state.freezed.dart';

@freezed
sealed class DownloadState with _$DownloadState {
  /// Belum ada proses download
  const factory DownloadState.idle() = DownloadIdle;

  /// Sedang download — [progress] antara 0.0 dan 1.0
  const factory DownloadState.downloading({
    required double progress,
  }) = DownloadDownloading;

  /// Download selesai, file tersedia lokal
  const factory DownloadState.done() = DownloadDone;

  /// Download gagal
  const factory DownloadState.error({
    required String message,
  }) = DownloadError;
}
