import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/audio/domain/entities/download_state.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';

String audioDownloadKey(int suratNomor, int ayatNomor, String qariId) =>
    '$suratNomor:$ayatNomor:$qariId';

class AudioDownloadState {
  const AudioDownloadState({
    this.downloadStates = const {},
    this.suratDownloadTotal = 0,
    this.suratDownloadDone = 0,
    this.isDownloadingSurat = false,
    this.loadError,
  });

  final Map<String, DownloadState> downloadStates;
  final int suratDownloadTotal;
  final int suratDownloadDone;
  final bool isDownloadingSurat;
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

  DownloadState stateFor(int suratNomor, int ayatNomor, String qariId) =>
      downloadStates[audioDownloadKey(suratNomor, ayatNomor, qariId)] ??
      const DownloadState.idle();

  bool isAllDownloaded(int suratNomor, List<Ayat> ayatList, String qariId) {
    if (ayatList.isEmpty) return false;
    return ayatList.every(
      (a) =>
          stateFor(suratNomor, a.nomorAyat, qariId) ==
          const DownloadState.done(),
    );
  }
}
