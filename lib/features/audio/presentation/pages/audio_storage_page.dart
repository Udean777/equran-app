import 'dart:async';

import 'package:equran_app/core/utils/dialog_utils.dart';
import 'package:equran_app/core/utils/format_utils.dart';
import 'package:equran_app/core/widgets/error_state_widget.dart';
import 'package:equran_app/core/widgets/loading_widget.dart';
import 'package:equran_app/core/widgets/luxury_app_bar.dart';
import 'package:equran_app/features/audio/domain/repositories/audio_download_repository.dart'
    show DownloadedAyatInfo;
import 'package:equran_app/features/audio/presentation/cubit/audio_cubit.dart';
import 'package:equran_app/features/audio/presentation/cubit/audio_storage_cubit.dart';
import 'package:equran_app/features/audio/presentation/widgets/audio_surat_group.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:equran_app/features/surat_detail/domain/usecases/get_surat_detail.dart';
import 'package:equran_app/features/surat_list/domain/entities/surat.dart';
import 'package:equran_app/features/surat_list/presentation/cubit/surat_list_cubit.dart';
import 'package:equran_app/injection/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AudioStoragePage extends StatelessWidget {
  const AudioStoragePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            final cubit = getIt<AudioStorageCubit>();
            unawaited(cubit.load());
            return cubit;
          },
        ),
        BlocProvider(
          create: (_) {
            final cubit = getIt<SuratListCubit>();
            unawaited(cubit.load());
            return cubit;
          },
        ),
        // AudioCubit adalah singleton di root — pakai value
        BlocProvider.value(value: context.read<AudioCubit>()),
      ],
      child: const _AudioStorageView(),
    );
  }
}

class _AudioStorageView extends StatelessWidget {
  const _AudioStorageView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LuxuryAppBar(
        title: 'Manajemen Audio',
        actions: [
          BlocBuilder<AudioStorageCubit, AudioStorageState>(
            builder: (context, state) {
              final hasFiles = state.maybeMap(
                success: (s) => s.files.isNotEmpty,
                orElse: () => false,
              );
              if (!hasFiles) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.delete_sweep_rounded),
                tooltip: 'Hapus semua audio',
                onPressed: () => _confirmDeleteAll(context),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<AudioStorageCubit, AudioStorageState>(
        builder: (context, state) => switch (state) {
          AudioStorageInitial() => const LoadingWidget(),
          AudioStorageLoading() => const LoadingWidget(),
          AudioStorageSuccess(:final files, :final totalBytes) =>
            files.isEmpty
                ? const Center(
                    child: Text('Belum ada audio yang diunduh.'),
                  )
                : _AudioStorageContent(files: files, totalBytes: totalBytes),
          AudioStorageError(:final message) => ErrorStateWidget(
            message: message,
            onRetry: context.read<AudioStorageCubit>().load,
          ),
        },
      ),
    );
  }

  Future<void> _confirmDeleteAll(BuildContext context) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Hapus Semua Audio?',
      content: 'Semua file audio yang telah diunduh akan dihapus.',
    );
    if (confirmed && context.mounted) {
      await context.read<AudioStorageCubit>().deleteAll();
    }
  }
}

class _AudioStorageContent extends StatelessWidget {
  const _AudioStorageContent({
    required this.files,
    required this.totalBytes,
  });

  final List<DownloadedAyatInfo> files;
  final int totalBytes;

  @override
  Widget build(BuildContext context) {
    // Group files by suratNomor
    final grouped = <int, List<DownloadedAyatInfo>>{};
    for (final f in files) {
      grouped.putIfAbsent(f.suratNomor, () => []).add(f);
    }
    final sortedKeys = grouped.keys.toList()..sort();

    // Ambil surat list untuk nama + jumlah ayat
    final suratMap = context.watch<SuratListCubit>().state.maybeMap(
      success: (s) => {for (final surat in s.surats) surat.nomor: surat},
      orElse: () => <int, Surat>{},
    );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total ukuran:'),
              Text(
                totalBytes.toReadableBytes(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: sortedKeys.length,
            itemBuilder: (_, i) {
              final suratNomor = sortedKeys[i];
              final suratFiles = grouped[suratNomor]!;
              final surat = suratMap[suratNomor];

              // Cek apakah semua ayat sudah didownload
              final isComplete =
                  surat != null &&
                  _isFullSuratDownloaded(suratFiles, surat.jumlahAyat);

              return AudioSuratGroup(
                suratNomor: suratNomor,
                files: suratFiles,
                suratName: surat?.namaLatin,
                isComplete: isComplete,
                onPlayTap: isComplete
                    ? () => _onPlayTap(context, suratNomor, suratFiles, surat)
                    : null,
              );
            },
          ),
        ),
      ],
    );
  }

  /// Cek apakah semua ayat 1..jumlahAyat sudah ada di downloaded files.
  bool _isFullSuratDownloaded(
    List<DownloadedAyatInfo> files,
    int jumlahAyat,
  ) {
    if (files.length < jumlahAyat) return false;
    final downloadedAyats = files.map((f) => f.ayatNomor).toSet();
    for (var i = 1; i <= jumlahAyat; i++) {
      if (!downloadedAyats.contains(i)) return false;
    }
    return true;
  }

  Future<void> _onPlayTap(
    BuildContext context,
    int suratNomor,
    List<DownloadedAyatInfo> files,
    Surat surat,
  ) async {
    final audioCubit = context.read<AudioCubit>();

    // Jika ada audio lain yang sedang berjalan — minta konfirmasi
    if (audioCubit.isPlaylistMode) {
      final currentName = audioCubit.playlistSuratName ?? 'surat lain';
      final confirmed = await showConfirmDialog(
        context,
        title: 'Ganti Audio?',
        content:
            '"$currentName" sedang diputar. Hentikan dan putar ${surat.namaLatin}?',
        confirmLabel: 'Ya, Ganti',
        isDestructive: false,
      );
      if (!confirmed) return;
      await audioCubit.stop();
    }

    if (!context.mounted) return;

    // Build ayat list dari downloaded files — sorted by ayatNomor
    final sortedFiles = [...files]
      ..sort((a, b) => a.ayatNomor.compareTo(b.ayatNomor));

    final qari = sortedFiles.first.qari;

    // Ambil full detail surat dari local cache untuk mendapatkan teksArab agar estimasi durasi dan progress bar akurat
    final getSuratDetail = getIt<GetSuratDetail>();
    final detailResult = await getSuratDetail(
      SuratDetailParams(nomor: suratNomor),
    );

    final ayatList = detailResult.fold<List<Ayat>>(
      (failure) {
        // Fallback jika gagal mengambil detail dari cache
        return sortedFiles
            .map(
              (f) => Ayat(
                nomorAyat: f.ayatNomor,
                teksArab: '',
                teksLatin: '',
                teksIndonesia: '',
                audio: {f.qari.id: f.filePath},
              ),
            )
            .toList();
      },
      (detail) {
        // Substitusikan file path lokal ke dalam Ayat dari detail asli
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

    unawaited(
      audioCubit.playFullSurat(
        ayatList: ayatList,
        startIndex: 0,
        qari: qari,
        suratNomor: suratNomor,
        suratName: surat.namaLatin,
        updateLastRead: false, // tidak update lastRead dari manajemen audio
      ),
    );
  }
}
