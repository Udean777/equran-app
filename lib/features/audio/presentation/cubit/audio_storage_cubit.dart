import 'dart:async';

import 'package:equran_app/features/audio/data/datasources/audio_download_data_source.dart';
import 'package:equran_app/features/audio/domain/entities/qari.dart';
import 'package:equran_app/features/audio/domain/usecases/delete_ayat_audio.dart';
import 'package:equran_app/features/audio/domain/usecases/get_downloaded_ayats.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'audio_storage_cubit.freezed.dart';

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

@injectable
class AudioStorageCubit extends Cubit<AudioStorageState> {
  AudioStorageCubit(
    this._getDownloadedAyats,
    this._deleteAyatAudio,
    this._downloadDataSource,
  ) : super(const AudioStorageState.initial());

  final GetDownloadedAyats _getDownloadedAyats;
  final DeleteAyatAudio _deleteAyatAudio;
  final AudioDownloadDataSource _downloadDataSource;

  Future<void> load() async {
    emit(const AudioStorageState.loading());
    final result = await _getDownloadedAyats();
    result.fold(
      (failure) => emit(AudioStorageState.error(message: failure.toString())),
      (files) {
        final totalBytes = files.fold<int>(0, (sum, f) => sum + f.sizeBytes);
        emit(AudioStorageState.success(files: files, totalBytes: totalBytes));
      },
    );
  }

  Future<void> deleteFile({
    required int suratNomor,
    required int ayatNomor,
    required Qari qari,
  }) async {
    final result = await _deleteAyatAudio(
      suratNomor: suratNomor,
      ayatNomor: ayatNomor,
      qari: qari,
    );
    result.fold(
      (failure) => debugPrint('AudioStorageCubit: delete error: $failure'),
      (_) => unawaited(load()),
    );
  }

  Future<void> deleteAll() async {
    try {
      await _downloadDataSource.deleteAll();
      await load();
    } on Object catch (e) {
      debugPrint('AudioStorageCubit: deleteAll error: $e');
    }
  }
}
