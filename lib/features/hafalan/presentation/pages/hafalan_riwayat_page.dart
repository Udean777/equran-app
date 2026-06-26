import 'dart:async';
import 'dart:io';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/utils/failure_extension.dart';
import 'package:equran_app/core/widgets/error_state_widget.dart';
import 'package:equran_app/core/widgets/loading_widget.dart';
import 'package:equran_app/core/widgets/luxury_app_bar.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:equran_app/features/surat_detail/presentation/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class HafalanRiwayatPage extends ConsumerWidget {
  const HafalanRiwayatPage({
    required this.suratNomor,
    this.juzNomor,
    super.key,
  });

  final int suratNomor;
  final int? juzNomor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(suratDetailViewModelProvider(suratNomor));

    return switch (state) {
      SuratDetailInitial() => const Scaffold(body: LoadingWidget()),
      SuratDetailLoading() => const Scaffold(body: LoadingWidget()),
      SuratDetailFailure(:final failure) => Scaffold(
        appBar: const LuxuryAppBar(title: 'Riwayat Rekaman'),
        body: ErrorStateWidget(
          message: failure.toUserMessage(),
          onRetry: () => ref
              .read(suratDetailViewModelProvider(suratNomor).notifier)
              .retry(suratNomor),
        ),
      ),
      SuratDetailSuccess(:final detail) => _RiwayatList(
        detail: detail,
        suratNomor: suratNomor,
        juzNomor: juzNomor,
      ),
    };
  }
}

class _RiwayatList extends StatefulWidget {
  const _RiwayatList({
    required this.detail,
    required this.suratNomor,
    this.juzNomor,
  });

  final SuratDetail detail;
  final int suratNomor;
  final int? juzNomor;

  @override
  State<_RiwayatList> createState() => _RiwayatListState();
}

class _RiwayatListState extends State<_RiwayatList> {
  final List<Ayat> _recordedAyat = [];
  final Map<int, String> _audioPaths = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    unawaited(_loadRecordings());
  }

  Future<void> _loadRecordings() async {
    final docDir = await getApplicationDocumentsDirectory();

    // Check all ayats in the surat
    for (final ayat in widget.detail.ayatList) {
      final targetPath = p.join(
        docDir.path,
        'hafalan_audio_${widget.suratNomor}_${ayat.nomorAyat}.m4a',
      );
      final file = File(targetPath);
      if (file.existsSync()) {
        _recordedAyat.add(ayat);
        _audioPaths[ayat.nomorAyat] = targetPath;
      }
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: LoadingWidget());
    }

    return Scaffold(
      appBar: LuxuryAppBar(
        title: 'Riwayat ${widget.detail.namaLatin}',
      ),
      body: _recordedAyat.isEmpty
          ? const Center(
              child: Text(
                'Belum ada riwayat rekaman.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(AppDimens.spaceMD),
              itemCount: _recordedAyat.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppDimens.spaceMD),
              itemBuilder: (context, index) {
                final ayat = _recordedAyat[index];
                final audioPath = _audioPaths[ayat.nomorAyat]!;

                return _RiwayatCard(
                  ayat: ayat,
                  audioPath: audioPath,
                );
              },
            ),
    );
  }
}

class _RiwayatCard extends StatefulWidget {
  const _RiwayatCard({
    required this.ayat,
    required this.audioPath,
  });

  final Ayat ayat;
  final String audioPath;

  @override
  State<_RiwayatCard> createState() => _RiwayatCardState();
}

class _RiwayatCardState extends State<_RiwayatCard> {
  final _player = AudioPlayer();
  bool _isPlaying = false;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    unawaited(_initPlayer());
  }

  Future<void> _initPlayer() async {
    try {
      await _player.setFilePath(widget.audioPath);
      _player.playerStateStream.listen((state) {
        if (mounted) {
          setState(() {
            _isPlaying = state.playing;
            if (state.processingState == ProcessingState.completed) {
              _isPlaying = false;
              unawaited(
                _player.seek(Duration.zero).then((_) => _player.pause()),
              );
            }
          });
        }
      });
    } on Object catch (_) {
      if (mounted) {
        setState(() => _isError = true);
      }
    }
  }

  @override
  void dispose() {
    unawaited(_player.dispose());
    super.dispose();
  }

  void _togglePlay() {
    if (_isError) return;
    if (_isPlaying) {
      unawaited(_player.pause());
    } else {
      unawaited(_player.play());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppDimens.spaceMD),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
        border: Border.all(
          color: isDark ? AppColors.outlineDark : AppColors.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.spaceSM,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.surfaceDarkVariant
                      : AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppDimens.radiusSM),
                ),
                child: Text(
                  'Ayat ${widget.ayat.nomorAyat}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: AppDimens.spaceMD),
          Row(
            children: [
              IconButton(
                onPressed: _togglePlay,
                icon: Icon(
                  _isError
                      ? Icons.error_outline_rounded
                      : _isPlaying
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                ),
                color: _isError ? AppColors.error : AppColors.primary,
                iconSize: 32,
              ),
              const SizedBox(width: AppDimens.spaceSM),
              Expanded(
                child: Text(
                  'Rekaman Anda',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? AppColors.onSurfaceDark
                        : AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
