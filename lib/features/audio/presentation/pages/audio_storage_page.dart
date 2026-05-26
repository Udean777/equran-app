import 'dart:async';

import 'package:equran_app/core/utils/dialog_utils.dart';
import 'package:equran_app/core/utils/format_utils.dart';
import 'package:equran_app/core/widgets/error_state_widget.dart';
import 'package:equran_app/core/widgets/loading_widget.dart';
import 'package:equran_app/core/widgets/luxury_app_bar.dart';
import 'package:equran_app/features/audio/data/datasources/audio_download_data_source.dart';
import 'package:equran_app/features/audio/presentation/cubit/audio_storage_cubit.dart';
import 'package:equran_app/features/audio/presentation/widgets/audio_surat_group.dart';
import 'package:equran_app/injection/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AudioStoragePage extends StatelessWidget {
  const AudioStoragePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = getIt<AudioStorageCubit>();
        unawaited(cubit.load());
        return cubit;
      },
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
              return AudioSuratGroup(
                suratNomor: suratNomor,
                files: grouped[suratNomor]!,
              );
            },
          ),
        ),
      ],
    );
  }
}
