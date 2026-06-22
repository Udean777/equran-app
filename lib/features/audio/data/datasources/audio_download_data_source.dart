import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equran_app/core/network/dio_client.dart';
import 'package:equran_app/features/audio/domain/entities/downloaded_ayat_info.dart';
import 'package:equran_app/features/audio/domain/entities/qari.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

abstract interface class AudioDownloadDataSource {
  /// Download audio ayat ke storage lokal.
  /// Emit progress 0.0–1.0 via stream.
  Stream<double> downloadAyat({
    required int suratNomor,
    required int ayatNomor,
    required Qari qari,
    required String url,
  });

  /// Dapatkan path file lokal untuk ayat tertentu.
  /// Return null jika belum didownload.
  Future<String?> getLocalPath({
    required int suratNomor,
    required int ayatNomor,
    required Qari qari,
  });

  /// Hapus file audio ayat tertentu.
  Future<void> deleteAyat({
    required int suratNomor,
    required int ayatNomor,
    required Qari qari,
  });

  /// Hapus semua file audio yang sudah didownload.
  Future<void> deleteAll();

  /// Dapatkan list semua file yang sudah didownload.
  /// Return list of [DownloadedAyatInfo].
  Future<List<DownloadedAyatInfo>> getDownloadedAyats();
}

@LazySingleton(as: AudioDownloadDataSource)
class AudioDownloadDataSourceImpl implements AudioDownloadDataSource {
  AudioDownloadDataSourceImpl(DioClient dioClient) : _dio = dioClient.dio;

  final Dio _dio;

  /// Base directory: {appDocDir}/audio/{qariId}/{suratNomor}/
  Future<Directory> _getAudioDir({
    required int suratNomor,
    required Qari qari,
  }) async {
    final appDir = await getApplicationDocumentsDirectory();
    final dir = Directory(
      '${appDir.path}/audio/${qari.id}/$suratNomor',
    );
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  String _fileName(int ayatNomor) => '$ayatNomor.mp3';

  Future<String> _buildFilePath({
    required int suratNomor,
    required int ayatNomor,
    required Qari qari,
  }) async {
    final dir = await _getAudioDir(suratNomor: suratNomor, qari: qari);
    return '${dir.path}/${_fileName(ayatNomor)}';
  }

  @override
  Stream<double> downloadAyat({
    required int suratNomor,
    required int ayatNomor,
    required Qari qari,
    required String url,
  }) {
    final controller = StreamController<double>();

    unawaited(
      _streamDownload(
        controller,
        suratNomor: suratNomor,
        ayatNomor: ayatNomor,
        qari: qari,
        url: url,
      ),
    );

    return controller.stream;
  }

  Future<void> _streamDownload(
    StreamController<double> controller, {
    required int suratNomor,
    required int ayatNomor,
    required Qari qari,
    required String url,
  }) async {
    try {
      final filePath = await _buildFilePath(
        suratNomor: suratNomor,
        ayatNomor: ayatNomor,
        qari: qari,
      );

      if (File(filePath).existsSync()) {
        controller.add(1);
        return;
      }

      final tempPath = '$filePath.tmp';

      await _dio.download(
        url,
        tempPath,
        onReceiveProgress: (received, total) {
          if (total > 0) {
            controller.add(received / total);
          }
        },
        options: Options(responseType: ResponseType.bytes),
      );

      await File(tempPath).rename(filePath);
      controller.add(1);
    } on Object catch (e) {
      try {
        final filePath = await _buildFilePath(
          suratNomor: suratNomor,
          ayatNomor: ayatNomor,
          qari: qari,
        );
        final tempFile = File('$filePath.tmp');
        if (tempFile.existsSync()) {
          await tempFile.delete();
        }
      } on Object catch (_) {}

      controller.addError(e);
      debugPrint('AudioDownloadDataSource: download error: $e');
    } finally {
      await controller.close();
    }
  }

  @override
  Future<String?> getLocalPath({
    required int suratNomor,
    required int ayatNomor,
    required Qari qari,
  }) async {
    final filePath = await _buildFilePath(
      suratNomor: suratNomor,
      ayatNomor: ayatNomor,
      qari: qari,
    );
    return File(filePath).existsSync() ? filePath : null;
  }

  @override
  Future<void> deleteAyat({
    required int suratNomor,
    required int ayatNomor,
    required Qari qari,
  }) async {
    final filePath = await _buildFilePath(
      suratNomor: suratNomor,
      ayatNomor: ayatNomor,
      qari: qari,
    );
    final file = File(filePath);
    if (file.existsSync()) {
      await file.delete();
    }
  }

  @override
  Future<void> deleteAll() async {
    final appDir = await getApplicationDocumentsDirectory();
    final audioDir = Directory('${appDir.path}/audio');
    if (audioDir.existsSync()) {
      await audioDir.delete(recursive: true);
    }
  }

  @override
  Future<List<DownloadedAyatInfo>> getDownloadedAyats() async {
    final appDir = await getApplicationDocumentsDirectory();
    final audioDir = Directory('${appDir.path}/audio');
    if (!audioDir.existsSync()) return [];

    final result = <DownloadedAyatInfo>[];

    // Struktur: audio/{qariId}/{suratNomor}/{ayatNomor}.mp3
    await for (final qariDir in audioDir.list()) {
      if (qariDir is! Directory) continue;
      final qariId = qariDir.path.split('/').last;
      final qari = Qari.fromId(qariId);

      await for (final suratDir in qariDir.list()) {
        if (suratDir is! Directory) continue;
        final suratNomor = int.tryParse(suratDir.path.split('/').last);
        if (suratNomor == null) continue;

        await for (final file in suratDir.list()) {
          if (file is! File) continue;
          final fileName = file.path.split('/').last;
          if (!fileName.endsWith('.mp3')) continue;
          final ayatNomor = int.tryParse(fileName.replaceAll('.mp3', ''));
          if (ayatNomor == null) continue;

          final stat = file.statSync();
          result.add(
            DownloadedAyatInfo(
              suratNomor: suratNomor,
              ayatNomor: ayatNomor,
              qari: qari,
              filePath: file.path,
              sizeBytes: stat.size,
            ),
          );
        }
      }
    }

    return result;
  }
}
