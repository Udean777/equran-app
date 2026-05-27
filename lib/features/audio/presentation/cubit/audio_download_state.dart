import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/audio/domain/entities/download_state.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:flutter/foundation.dart';

/// Key format: '$suratNomor:$ayatNomor:$qariId'
String audioDownloadKey(int suratNomor, int ayatNomor, String qariId) =>
    '$suratNomor:$ayatNomor:$qariId';

/// State untuk AudioDownloadCubit.
/// Menyimpan status download per ayat dan progress download surat penuh.
@immutable
class AudioDownloadState {
  const AudioDownloadState({
    this.downloadStates = const {},
    this.suratDownloadTotal = 0,
    this.suratDownloadDone = 0,
    this.isDownloadingSurat = false,
    this.loadError,
  });

  /// Status download per ayat. Key: '$suratNomor:$ayatNomor:$qariId'
  final Map<String, DownloadState> downloadStates;

  /// Total ayat yang akan didownload (download surat penuh)
  final int suratDownloadTotal;

  /// Jumlah ayat yang sudah selesai didownload (download surat penuh)
  final int suratDownloadDone;

  /// Apakah sedang download surat penuh
  final bool isDownloadingSurat;

  /// Error saat load status download — null jika tidak ada error
  final Failure? loadError;

  AudioDownloadState copyWith({
    Map<String, DownloadState>? downloadStates,
    int? suratDownloadTotal,
    int? suratDownloadDone,
    bool? isDownloadingSurat,
    Failure? loadError,
  }) {
    return AudioDownloadState(
      downloadStates: downloadStates ?? this.downloadStates,
      suratDownloadTotal: suratDownloadTotal ?? this.suratDownloadTotal,
      suratDownloadDone: suratDownloadDone ?? this.suratDownloadDone,
      isDownloadingSurat: isDownloadingSurat ?? this.isDownloadingSurat,
      loadError: loadError,
    );
  }

  /// Status download untuk ayat tertentu.
  DownloadState stateFor(int suratNomor, int ayatNomor, String qariId) =>
      downloadStates[audioDownloadKey(suratNomor, ayatNomor, qariId)] ??
      const DownloadState.idle();

  /// Apakah semua ayat dalam list sudah didownload untuk qari tertentu.
  bool isAllDownloaded(int suratNomor, List<Ayat> ayatList, String qariId) {
    if (ayatList.isEmpty) return false;
    return ayatList.every(
      (a) =>
          stateFor(suratNomor, a.nomorAyat, qariId) ==
          const DownloadState.done(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AudioDownloadState &&
        other.isDownloadingSurat == isDownloadingSurat &&
        other.suratDownloadDone == suratDownloadDone &&
        other.suratDownloadTotal == suratDownloadTotal &&
        other.loadError == loadError &&
        _mapsEqual(other.downloadStates, downloadStates);
  }

  @override
  int get hashCode => Object.hash(
    downloadStates,
    isDownloadingSurat,
    suratDownloadDone,
    suratDownloadTotal,
    loadError,
  );

  bool _mapsEqual(
    Map<String, DownloadState> a,
    Map<String, DownloadState> b,
  ) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (a[key] != b[key]) return false;
    }
    return true;
  }
}
