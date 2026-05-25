import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/widgets/error_state_widget.dart';
import 'package:equran_app/core/widgets/loading_widget.dart';
import 'package:equran_app/features/audio/data/datasources/audio_download_data_source.dart';
import 'package:equran_app/features/audio/presentation/cubit/audio_storage_cubit.dart';
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
      appBar: AppBar(
        title: const Text('Manajemen Audio'),
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
                tooltip: 'Hapus semua',
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
          AudioStorageError(:final message) => ErrorStateWidget(
            message: message,
            onRetry: () => context.read<AudioStorageCubit>().load(),
          ),
          AudioStorageSuccess(:final files, :final totalBytes) =>
            files.isEmpty
                ? _buildEmpty(context)
                : _buildList(context, files, totalBytes),
        },
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.audio_file_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: AppDimens.spaceMD),
          Text(
            'Belum ada audio yang didownload',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: AppDimens.spaceSM),
          Text(
            'Download audio ayat dari halaman surat\nuntuk diputar secara offline.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(
    BuildContext context,
    List<DownloadedAyatInfo> files,
    int totalBytes,
  ) {
    // Group by surat
    final grouped = <int, List<DownloadedAyatInfo>>{};
    for (final file in files) {
      grouped.putIfAbsent(file.suratNomor, () => []).add(file);
    }
    final suratNumbers = grouped.keys.toList()..sort();

    return Column(
      children: [
        // Storage summary
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.spaceMD,
            vertical: AppDimens.spaceSM,
          ),
          color: AppColors.primary.withValues(alpha: 0.08),
          child: Row(
            children: [
              const Icon(
                Icons.storage_rounded,
                size: AppDimens.iconSM,
                color: AppColors.primary,
              ),
              const SizedBox(width: AppDimens.spaceSM),
              Text(
                '${files.length} file • ${_formatBytes(totalBytes)}',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        // File list grouped by surat
        Expanded(
          child: ListView.builder(
            itemCount: suratNumbers.length,
            itemBuilder: (context, i) {
              final suratNomor = suratNumbers[i];
              final suratFiles = grouped[suratNomor]!
                ..sort((a, b) => a.ayatNomor.compareTo(b.ayatNomor));

              return _SuratGroup(
                suratNomor: suratNomor,
                files: suratFiles,
              );
            },
          ),
        ),
      ],
    );
  }

  void _confirmDeleteAll(BuildContext context) {
    final cubit = context.read<AudioStorageCubit>();
    unawaited(
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Hapus Semua Audio'),
          content: const Text(
            'Semua file audio yang sudah didownload akan dihapus. '
            'Tindakan ini tidak dapat dibatalkan.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                unawaited(cubit.deleteAll());
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Hapus Semua'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

class _SuratGroup extends StatelessWidget {
  const _SuratGroup({
    required this.suratNomor,
    required this.files,
  });

  final int suratNomor;
  final List<DownloadedAyatInfo> files;

  @override
  Widget build(BuildContext context) {
    final totalBytes = files.fold<int>(0, (sum, f) => sum + f.sizeBytes);

    return ExpansionTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
        child: Text(
          '$suratNomor',
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
      title: Text('Surat $suratNomor'),
      subtitle: Text(
        '${files.length} ayat • ${_formatBytes(totalBytes)}',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Colors.grey[500],
        ),
      ),
      children: files.map((file) => _FileItem(file: file)).toList(),
    );
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

class _FileItem extends StatelessWidget {
  const _FileItem({required this.file});

  final DownloadedAyatInfo file;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(
        left: AppDimens.spaceXL + AppDimens.spaceMD,
        right: AppDimens.spaceSM,
      ),
      leading: const Icon(
        Icons.audio_file_rounded,
        color: AppColors.primary,
        size: AppDimens.iconSM + 4,
      ),
      title: Text('Ayat ${file.ayatNomor}'),
      subtitle: Text(
        '${file.qari.name} • ${_formatBytes(file.sizeBytes)}',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Colors.grey[500],
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline_rounded, size: 20),
        color: Colors.red[400],
        tooltip: 'Hapus',
        onPressed: () => context.read<AudioStorageCubit>().deleteFile(
          suratNomor: file.suratNomor,
          ayatNomor: file.ayatNomor,
          qari: file.qari,
        ),
      ),
    );
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
