import 'dart:async';

import 'package:equran_app/features/audio/domain/entities/download_state.dart';
import 'package:equran_app/features/audio/domain/usecases/download_ayat_audio.dart';
import 'package:equran_app/features/audio/domain/usecases/get_downloaded_ayats.dart';
import 'package:equran_app/features/audio/presentation/providers.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AudioDownloadViewModel extends AutoDisposeNotifier<AudioDownloadState> {
  @override
  AudioDownloadState build() => const AudioDownloadState();

  DownloadAyatAudio get _downloadAyatAudio => ref.read(downloadAyatAudioProvider);
  GetDownloadedAyats get _getDownloadedAyats => ref.read(getDownloadedAyatsProvider);

  bool _cancelSuratDownload = false;
  int? _currentSuratNomor;

  Future<void> loadDownloadedStatus({
    required int suratNomor,
    required List<Ayat> ayatList,
    required Qari qari,
  }) async {
    if (_currentSuratNomor != null && _currentSuratNomor != suratNomor) {
      _clearStatesForSurat(_currentSuratNomor!);
    }
    _currentSuratNomor = suratNomor;

    final result = await _getDownloadedAyats();
    result.fold(
      (failure) => state = state.copyWith(loadError: failure),
      (files) {
        final downloaded = <String>{
          for (final f in files)
            if (f.qari == qari)
              audioDownloadKey(f.suratNomor, f.ayatNomor, qari.id),
        };

        final newStates = Map<String, DownloadState>.from(
          state.downloadStates,
        );

        for (final ayat in ayatList) {
          final k = audioDownloadKey(suratNomor, ayat.nomorAyat, qari.id);
          newStates[k] = downloaded.contains(k)
              ? const DownloadState.done()
              : const DownloadState.idle();
        }

        state = state.copyWith(downloadStates: newStates);
      },
    );
  }

  void _clearStatesForSurat(int suratNomor) {
    final prefix = '$suratNomor:';
    final cleaned = Map<String, DownloadState>.from(state.downloadStates)
      ..removeWhere((key, _) => key.startsWith(prefix));
    state = state.copyWith(downloadStates: cleaned);
  }

  Future<void> downloadAyat({
    required int suratNomor,
    required Ayat ayat,
    required Qari qari,
  }) async {
    final url = ayat.audio[qari.id];
    if (url == null) return;

    final k = audioDownloadKey(suratNomor, ayat.nomorAyat, qari.id);

    if (state.downloadStates[k] == const DownloadState.done()) return;

    _updateKey(k, const DownloadState.downloading(progress: 0));

    await for (final result in _downloadAyatAudio(
      suratNomor: suratNomor,
      ayatNomor: ayat.nomorAyat,
      qari: qari,
      url: url,
    )) {
      result.fold(
        (failure) => _updateKey(
          k,
          DownloadState.error(message: failure.toString()),
        ),
        (progress) {
          if (progress >= 1.0) {
            _updateKey(k, const DownloadState.done());
          } else {
            _updateKey(k, DownloadState.downloading(progress: progress));
          }
        },
      );
    }
  }

  Future<void> downloadSurat({
    required int suratNomor,
    required List<Ayat> ayatList,
    required Qari qari,
  }) async {
    if (isAllDownloaded(suratNomor, ayatList, qari)) return;

    _cancelSuratDownload = false;

    final pending = ayatList
        .where(
          (a) =>
              state.stateFor(suratNomor, a.nomorAyat, qari.id) !=
              const DownloadState.done(),
        )
        .toList();

    state = state.copyWith(
      isDownloadingSurat: true,
      suratDownloadTotal: pending.length,
      suratDownloadDone: 0,
    );

    var done = 0;
    for (final ayat in pending) {
      if (_cancelSuratDownload) break;

      await downloadAyat(
        suratNomor: suratNomor,
        ayat: ayat,
        qari: qari,
      );

      done++;
      state = state.copyWith(suratDownloadDone: done);
    }

    state = state.copyWith(
      isDownloadingSurat: false,
      suratDownloadTotal: 0,
      suratDownloadDone: 0,
    );
  }

  void cancelSuratDownload() {
    _cancelSuratDownload = true;
  }

  bool isAllDownloaded(int suratNomor, List<Ayat> ayatList, Qari qari) =>
      state.isAllDownloaded(suratNomor, ayatList, qari.id);

  void _updateKey(String key, DownloadState downloadState) {
    final newStates = Map<String, DownloadState>.from(state.downloadStates)
      ..[key] = downloadState;
    state = state.copyWith(downloadStates: newStates);
  }
}
