import 'dart:async';

import 'package:equran_app/features/audio/domain/entities/download_state.dart';
import 'package:equran_app/features/audio/domain/entities/qari.dart';
import 'package:equran_app/features/audio/domain/usecases/download_ayat_audio.dart';
import 'package:equran_app/features/audio/domain/usecases/get_downloaded_ayats.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

/// Key format: '$suratNomor:$ayatNomor:$qariId'
String _key(int suratNomor, int ayatNomor, String qariId) =>
    '$suratNomor:$ayatNomor:$qariId';

/// State untuk AudioDownloadCubit.
/// Menyimpan status download per ayat dan progress download surat penuh.
class AudioDownloadState {
  const AudioDownloadState({
    this.downloadStates = const {},
    this.suratDownloadTotal = 0,
    this.suratDownloadDone = 0,
    this.isDownloadingSurat = false,
  });

  /// Status download per ayat. Key: '$suratNomor:$ayatNomor:$qariId'
  final Map<String, DownloadState> downloadStates;

  /// Total ayat yang akan didownload (download surat penuh)
  final int suratDownloadTotal;

  /// Jumlah ayat yang sudah selesai didownload (download surat penuh)
  final int suratDownloadDone;

  /// Apakah sedang download surat penuh
  final bool isDownloadingSurat;

  AudioDownloadState copyWith({
    Map<String, DownloadState>? downloadStates,
    int? suratDownloadTotal,
    int? suratDownloadDone,
    bool? isDownloadingSurat,
  }) {
    return AudioDownloadState(
      downloadStates: downloadStates ?? this.downloadStates,
      suratDownloadTotal: suratDownloadTotal ?? this.suratDownloadTotal,
      suratDownloadDone: suratDownloadDone ?? this.suratDownloadDone,
      isDownloadingSurat: isDownloadingSurat ?? this.isDownloadingSurat,
    );
  }

  /// Status download untuk ayat tertentu.
  DownloadState stateFor(int suratNomor, int ayatNomor, String qariId) =>
      downloadStates[_key(suratNomor, ayatNomor, qariId)] ??
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
}

@injectable
class AudioDownloadCubit extends Cubit<AudioDownloadState> {
  AudioDownloadCubit(
    this._downloadAyatAudio,
    this._getDownloadedAyats,
  ) : super(const AudioDownloadState());

  final DownloadAyatAudio _downloadAyatAudio;
  final GetDownloadedAyats _getDownloadedAyats;

  bool _cancelSuratDownload = false;

  /// Load status download semua ayat dalam surat untuk qari tertentu.
  /// Dipanggil saat halaman surat pertama dibuka.
  Future<void> loadDownloadedStatus({
    required int suratNomor,
    required List<Ayat> ayatList,
    required Qari qari,
  }) async {
    final result = await _getDownloadedAyats();
    result.fold(
      (failure) => debugPrint('AudioDownloadCubit: load error: $failure'),
      (files) {
        final downloaded = <String>{
          for (final f in files)
            if (f.qari == qari) _key(f.suratNomor, f.ayatNomor, qari.id),
        };

        final newStates = Map<String, DownloadState>.from(
          state.downloadStates,
        );

        for (final ayat in ayatList) {
          final k = _key(suratNomor, ayat.nomorAyat, qari.id);
          newStates[k] = downloaded.contains(k)
              ? const DownloadState.done()
              : const DownloadState.idle();
        }

        emit(state.copyWith(downloadStates: newStates));
      },
    );
  }

  /// Download satu ayat. Update progress secara realtime.
  Future<void> downloadAyat({
    required int suratNomor,
    required Ayat ayat,
    required Qari qari,
  }) async {
    final url = ayat.audio[qari.id];
    if (url == null) return;

    final k = _key(suratNomor, ayat.nomorAyat, qari.id);

    // Jika sudah done, skip
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

  /// Download semua ayat dalam surat secara sequential.
  /// Progress ditampilkan via suratDownloadDone / suratDownloadTotal.
  Future<void> downloadSurat({
    required int suratNomor,
    required List<Ayat> ayatList,
    required Qari qari,
  }) async {
    if (isAllDownloaded(suratNomor, ayatList, qari)) return;

    _cancelSuratDownload = false;

    // Hanya download ayat yang belum done
    final pending = ayatList
        .where(
          (a) =>
              state.stateFor(suratNomor, a.nomorAyat, qari.id) !=
              const DownloadState.done(),
        )
        .toList();

    emit(
      state.copyWith(
        isDownloadingSurat: true,
        suratDownloadTotal: pending.length,
        suratDownloadDone: 0,
      ),
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
      emit(state.copyWith(suratDownloadDone: done));
    }

    emit(
      state.copyWith(
        isDownloadingSurat: false,
        suratDownloadTotal: 0,
        suratDownloadDone: 0,
      ),
    );
  }

  /// Cancel download surat yang sedang berjalan.
  void cancelSuratDownload() {
    _cancelSuratDownload = true;
  }

  /// Helper — cek apakah semua ayat sudah didownload.
  bool isAllDownloaded(int suratNomor, List<Ayat> ayatList, Qari qari) =>
      state.isAllDownloaded(suratNomor, ayatList, qari.id);

  void _updateKey(String key, DownloadState downloadState) {
    final newStates = Map<String, DownloadState>.from(state.downloadStates)
      ..[key] = downloadState;
    emit(state.copyWith(downloadStates: newStates));
  }
}
