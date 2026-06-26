import 'dart:async';

import 'package:equran_app/core/utils/failure_extension.dart';
import 'package:equran_app/features/audio/domain/entities/downloaded_ayat_info.dart';
import 'package:equran_app/features/audio/domain/usecases/delete_all_audio.dart';
import 'package:equran_app/features/audio/domain/usecases/delete_ayat_audio.dart';
import 'package:equran_app/features/audio/domain/usecases/get_downloaded_ayats.dart';
import 'package:equran_app/features/audio/presentation/providers.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:equran_app/features/surat_detail/domain/usecases/get_surat_detail.dart';
import 'package:equran_app/features/surat_detail/presentation/providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AudioStorageViewModel extends AutoDisposeNotifier<AudioStorageState> {
  @override
  AudioStorageState build() => const AudioStorageState.initial();

  GetDownloadedAyats get _getDownloadedAyats =>
      ref.read(getDownloadedAyatsProvider);
  DeleteAyatAudio get _deleteAyatAudio => ref.read(deleteAyatAudioProvider);
  DeleteAllAudio get _deleteAllAudio => ref.read(deleteAllAudioProvider);
  GetSuratDetail get _getSuratDetail => ref.read(getSuratDetailProvider);

  Future<void> load() async {
    state = const AudioStorageState.loading();
    final result = await _getDownloadedAyats();
    result.fold(
      (failure) => state = AudioStorageState.error(
        message: failure.toUserMessage(),
      ),
      (files) {
        final totalBytes = files.fold<int>(0, (sum, f) => sum + f.sizeBytes);
        state = AudioStorageState.success(files: files, totalBytes: totalBytes);
      },
    );
  }

  Qari? _qariFromFiles(List<DownloadedAyatInfo> files) {
    final sorted = [...files]
      ..sort((a, b) => a.ayatNomor.compareTo(b.ayatNomor));
    return sorted.firstOrNull?.qari;
  }

  Future<List<Ayat>?> buildAyatList({
    required int suratNomor,
    required List<DownloadedAyatInfo> files,
  }) async {
    final sorted = [...files]
      ..sort((a, b) => a.ayatNomor.compareTo(b.ayatNomor));

    final qari = _qariFromFiles(sorted);
    if (qari == null) return null;

    final result = await _getSuratDetail(
      SuratDetailParams(nomor: suratNomor),
    );

    return result.fold(
      (failure) {
        return sorted.map((f) {
          return Ayat(
            nomorAyat: f.ayatNomor,
            teksArab: '',
            teksLatin: '',
            teksIndonesia: '',
            audio: {qari.id: f.filePath},
          );
        }).toList();
      },
      (detail) {
        final downloadedPaths = {
          for (final f in files) f.ayatNomor: f.filePath,
        };
        return detail.ayatList.map((a) {
          final localPath = downloadedPaths[a.nomorAyat];
          return Ayat(
            nomorAyat: a.nomorAyat,
            teksArab: a.teksArab,
            teksLatin: a.teksLatin,
            teksIndonesia: a.teksIndonesia,
            audio: {
              qari.id: localPath ?? a.audio[qari.id] ?? a.audio.values.first,
            },
          );
        }).toList();
      },
    );
  }

  Future<void> deleteFile({
    required int suratNomor,
    required int ayatNomor,
    required Qari qari,
  }) async {
    final result = await _deleteAyatAudio(
      DeleteAyatAudioParams(
        suratNomor: suratNomor,
        ayatNomor: ayatNomor,
        qari: qari,
      ),
    );
    result.fold(
      (failure) => debugPrint('AudioStorageViewModel: delete error: $failure'),
      (_) => unawaited(load()),
    );
  }

  Future<void> deleteAll() async {
    final result = await _deleteAllAudio();
    result.fold(
      (failure) =>
          debugPrint('AudioStorageViewModel: deleteAll error: $failure'),
      (_) => unawaited(load()),
    );
  }
}
