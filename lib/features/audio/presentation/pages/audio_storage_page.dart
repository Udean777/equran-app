import 'dart:async';

import 'package:equran_app/core/utils/dialog_utils.dart';
import 'package:equran_app/core/widgets/error_state_widget.dart';
import 'package:equran_app/core/widgets/loading_widget.dart';
import 'package:equran_app/core/widgets/luxury_app_bar.dart';
import 'package:equran_app/features/audio/domain/entities/downloaded_ayat_info.dart';
import 'package:equran_app/features/audio/presentation/providers.dart';
import 'package:equran_app/features/audio/presentation/utils/format_utils.dart';
import 'package:equran_app/features/audio/presentation/widgets/audio_surat_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AudioStoragePage extends ConsumerStatefulWidget {
  const AudioStoragePage({super.key});

  @override
  ConsumerState<AudioStoragePage> createState() => _AudioStoragePageState();
}

class _AudioStoragePageState extends ConsumerState<AudioStoragePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(ref.read(audioStorageViewModelProvider.notifier).load());
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(audioStorageViewModelProvider);

    return Scaffold(
      appBar: LuxuryAppBar(
        title: 'Manajemen Audio',
        actions: [
          state.maybeMap(
            success: (s) {
              if (s.files.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.delete_sweep_rounded),
                tooltip: 'Hapus semua audio',
                onPressed: () => _confirmDeleteAll(context),
              );
            },
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: switch (state) {
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
          onRetry: () => unawaited(
            ref.read(audioStorageViewModelProvider.notifier).load(),
          ),
        ),
      },
    );
  }

  Future<void> _confirmDeleteAll(BuildContext context) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Hapus Semua Audio?',
      content: 'Semua file audio yang telah diunduh akan dihapus.',
    );
    if (confirmed && context.mounted) {
      await ref.read(audioStorageViewModelProvider.notifier).deleteAll();
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
    final grouped = <int, List<DownloadedAyatInfo>>{};
    for (final f in files) {
      grouped.putIfAbsent(f.suratNomor, () => []).add(f);
    }
    final sortedKeys = grouped.keys.toList()..sort();

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

              final isComplete = _isFullSuratDownloaded(suratFiles);

              return AudioSuratGroup(
                suratNomor: suratNomor,
                files: suratFiles,
                isComplete: isComplete,
                onPlayTap: isComplete
                    ? () => _onPlayTap(context, suratNomor, suratFiles)
                    : null,
              );
            },
          ),
        ),
      ],
    );
  }

  /// Cek apakah semua ayat 1..maxAyat sudah ada di downloaded files.
  bool _isFullSuratDownloaded(List<DownloadedAyatInfo> files) {
    if (files.isEmpty) return false;
    final maxAyat = files
        .map((f) => f.ayatNomor)
        .reduce(
          (a, b) => a > b ? a : b,
        );
    if (files.length < maxAyat) return false;
    final downloadedAyats = files.map((f) => f.ayatNomor).toSet();
    for (var i = 1; i <= maxAyat; i++) {
      if (!downloadedAyats.contains(i)) return false;
    }
    return true;
  }

  Future<void> _onPlayTap(
    BuildContext context,
    int suratNomor,
    List<DownloadedAyatInfo> files,
  ) async {
    final audioVm = ProviderScope.containerOf(
      context,
    ).read(audioViewModelProvider.notifier);

    if (audioVm.isPlaylistMode) {
      final currentName = audioVm.playlistSuratName ?? 'surat lain';
      final confirmed = await showConfirmDialog(
        context,
        title: 'Ganti Audio?',
        content:
            '"$currentName" sedang diputar. Hentikan dan putar Surat $suratNomor?',
        confirmLabel: 'Ya, Ganti',
        isDestructive: false,
      );
      if (!confirmed) return;
      await audioVm.stop();
    }

    if (!context.mounted) return;

    final storageVm = ProviderScope.containerOf(
      context,
    ).read(audioStorageViewModelProvider.notifier);
    final ayatList = await storageVm.buildAyatList(
      suratNomor: suratNomor,
      files: files,
    );
    if (ayatList == null) return;
    if (!context.mounted) return;

    final qari = [...files]..sort((a, b) => a.ayatNomor.compareTo(b.ayatNomor));
    final qariValue = qari.firstOrNull?.qari;
    if (qariValue == null) return;

    unawaited(
      audioVm.playFullSurat(
        ayatList: ayatList,
        startIndex: 0,
        qari: qariValue,
        suratNomor: suratNomor,
        suratName: 'Surat $suratNomor',
        updateLastRead: false,
      ),
    );
  }
}
