import 'dart:async';
import 'dart:io';

import 'package:equran_app/core/constants/juz_constants.dart';
import 'package:equran_app/core/utils/dialog_utils.dart';
import 'package:equran_app/core/utils/failure_extension.dart';
import 'package:equran_app/core/widgets/error_state_widget.dart';
import 'package:equran_app/core/widgets/loading_widget.dart';
import 'package:equran_app/core/widgets/luxury_app_bar.dart';
import 'package:equran_app/features/hafalan/domain/entities/hafalan_surat.dart';
import 'package:equran_app/features/hafalan/domain/entities/setoran_compare_result.dart';
import 'package:equran_app/features/hafalan/presentation/providers.dart';
import 'package:equran_app/features/hafalan/presentation/viewmodels/hafalan_detail_viewmodel.dart';
import 'package:equran_app/features/hafalan/presentation/widgets/setoran_card.dart';
import 'package:equran_app/features/hafalan/presentation/widgets/setoran_hasil.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:equran_app/features/surat_detail/presentation/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class HafalanSetoranPage extends ConsumerWidget {
  const HafalanSetoranPage({
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
        appBar: const LuxuryAppBar(title: 'Mode Setoran'),
        body: ErrorStateWidget(
          message: failure.toUserMessage(),
          onRetry: () => ref
              .read(suratDetailViewModelProvider(suratNomor).notifier)
              .retry(suratNomor),
        ),
      ),
      SuratDetailSuccess(:final detail) => _SetoranSession(
        detail: detail,
        suratNomor: suratNomor,
        juzNomor: juzNomor,
      ),
    };
  }
}

class _SetoranSession extends ConsumerStatefulWidget {
  const _SetoranSession({
    required this.detail,
    required this.suratNomor,
    this.juzNomor,
  });

  final SuratDetail detail;
  final int suratNomor;
  final int? juzNomor;

  @override
  ConsumerState<_SetoranSession> createState() => _SetoranSessionState();
}

class _SetoranSessionState extends ConsumerState<_SetoranSession> {
  late final List<Ayat> _ayatList;

  int _currentIndex = 0;
  final Map<int, bool> _hasil = {};
  final Map<int, SetoranCompareResult> _compareResults = {};
  final Map<int, String> _userAudioPaths = {};
  bool _showTerjemahan = false;
  bool _isSelesai = false;

  SetoranRecordState _recordState = SetoranRecordState.idle;
  bool _forceExit = false;

  @override
  void initState() {
    super.initState();

    final range = widget.juzNomor != null
        ? JuzConstants.verseRanges['${widget.juzNomor}:${widget.suratNomor}']
        : null;

    if (range != null) {
      final startAyat = range.$1;
      final endAyat = range.$2;
      _ayatList = widget.detail.ayatList
          .where((a) => a.nomorAyat >= startAyat && a.nomorAyat <= endAyat)
          .toList();
    } else {
      _ayatList = widget.detail.ayatList;
    }
  }

  Ayat get _currentAyat => _ayatList[_currentIndex];
  int get _totalAyat => _ayatList.length;
  int get _hafalCount => _hasil.values.where((v) => v).length;

  @override
  Widget build(BuildContext context) {
    final title = _isSelesai
        ? 'Hasil Setoran'
        : 'Setoran: ${widget.detail.namaLatin}';

    final canPopNow = _forceExit || _hasil.isEmpty || _isSelesai;

    final detailState = ref.watch(
      hafalanDetailViewModelProvider(widget.suratNomor),
    );
    final detailNotifier = ref.read(
      hafalanDetailViewModelProvider(widget.suratNomor).notifier,
    );

    return PopScope(
      canPop: canPopNow,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final confirmed = await showConfirmDialog(
          context,
          title: 'Keluar Setoran?',
          content: 'Progress setoran akan hilang jika keluar sekarang.',
          confirmLabel: 'Keluar',
          cancelLabel: 'Lanjutkan',
        );
        if (confirmed && mounted) {
          setState(() => _forceExit = true);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) context.pop();
          });
        }
      },
      child: Scaffold(
        appBar: LuxuryAppBar(
          title: title,
          leading: IconButton(
            icon: const Icon(Icons.close_rounded),
            tooltip: 'Keluar',
            onPressed: _confirmExit,
          ),
        ),
        body: _isSelesai
            ? SetoranHasil(
                detail: widget.detail,
                hasil: _hasil,
                compareResults: _compareResults.isNotEmpty
                    ? _compareResults
                    : null,
                onSimpan: _simpanHasil,
                onUlang: _ulangSetoran,
              )
            : _buildSetoranCard(detailState, detailNotifier),
      ),
    );
  }

  Widget _buildSetoranCard(
    HafalanDetailState detailState,
    HafalanDetailViewModel detailNotifier,
  ) {
    ref.listen<HafalanDetailState>(
      hafalanDetailViewModelProvider(widget.suratNomor),
      (prev, next) {
        if (next is HafalanDetailCompareSuccess &&
            next.ayatNomor == _currentAyat.nomorAyat) {
          _handleCompareSuccess(next.result, next.audioPath);
        } else if (next is HafalanDetailCompareFailure &&
            next.ayatNomor == _currentAyat.nomorAyat) {
          _handleCompareFailure(next.message);
        }
      },
    );

    final isComparing =
        detailState is HafalanDetailComparing &&
        detailState.ayatNomor == _currentAyat.nomorAyat;

    return SetoranCard(
      ayat: _currentAyat,
      currentIndex: _currentIndex,
      totalAyat: _totalAyat,
      showTerjemahan: _showTerjemahan,
      onToggleTerjemahan: () =>
          setState(() => _showTerjemahan = !_showTerjemahan),
      recordState: isComparing ? SetoranRecordState.comparing : _recordState,
      compareResult: _compareResults[_currentAyat.nomorAyat],
      userAudioPath: _userAudioPaths[_currentAyat.nomorAyat],
      onStartRecord: _startRecording,
      onStopRecord: _stopRecording,
      onNextAyat: _advanceToNext,
    );
  }

  Future<void> _startRecording() async {
    final recorder = ref.read(audioRecorderServiceProvider);

    try {
      final hasPermission = await recorder.hasPermission();
      if (!hasPermission) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Izin mikrofon tidak diberikan')),
          );
        }
        return;
      }

      await recorder.startRecording();
      setState(() {
        _recordState = SetoranRecordState.recording;
        _compareResults.remove(_currentAyat.nomorAyat);
        _userAudioPaths.remove(_currentAyat.nomorAyat);
        _hasil.remove(_currentAyat.nomorAyat);
      });
    } on Object catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memulai rekaman: $e')),
        );
      }
    }
  }

  Future<void> _stopRecording() async {
    setState(() => _recordState = SetoranRecordState.comparing);

    final detailNotifier = ref.read(
      hafalanDetailViewModelProvider(widget.suratNomor).notifier,
    );
    unawaited(
      detailNotifier.compareRecitation(
        ayatNomor: _currentAyat.nomorAyat,
        targetText: _currentAyat.teksArab,
      ),
    );
  }

  void _handleCompareSuccess(SetoranCompareResult result, String audioPath) {
    setState(() {
      _recordState = SetoranRecordState.idle;
      _compareResults[_currentAyat.nomorAyat] = result;
      _userAudioPaths[_currentAyat.nomorAyat] = audioPath;
      _hasil[_currentAyat.nomorAyat] = result.passed;
    });
  }

  void _handleCompareFailure(String message) {
    setState(() => _recordState = SetoranRecordState.idle);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  void _advanceToNext() {
    if (_currentIndex < _totalAyat - 1) {
      setState(() {
        _currentIndex++;
        _showTerjemahan = false;
        _recordState = SetoranRecordState.idle;
      });
    } else {
      setState(() => _isSelesai = true);
    }
  }

  void _ulangSetoran() {
    setState(() {
      _currentIndex = 0;
      _hasil.clear();
      _compareResults.clear();
      _userAudioPaths.clear();
      _showTerjemahan = false;
      _isSelesai = false;
      _recordState = SetoranRecordState.idle;
    });
  }

  Future<void> _simpanHasil() async {
    final docDir = await getApplicationDocumentsDirectory();
    for (final entry in _userAudioPaths.entries) {
      final ayatNomor = entry.key;
      final cachePath = entry.value;

      final sourceFile = File(cachePath);
      if (sourceFile.existsSync()) {
        final targetPath = p.join(
          docDir.path,
          'hafalan_audio_${widget.suratNomor}_$ayatNomor.m4a',
        );
        await sourceFile.copy(targetPath);
      }
    }

    if (!mounted) return;

    final detailNotifier = ref.read(
      hafalanDetailViewModelProvider(widget.suratNomor).notifier,
    );
    await detailNotifier.saveSetoranHasil(
      suratNomor: widget.suratNomor,
      hasil: _hasil,
      suratInfo: HafalanSurat(
        suratNomor: widget.detail.nomor,
        namaLatin: widget.detail.namaLatin,
        nama: widget.detail.nama,
        jumlahAyat: widget.detail.jumlahAyat,
      ),
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Hasil setoran disimpan: $_hafalCount/$_totalAyat ayat hafal',
          ),
        ),
      );
      context.pop();
    }
  }

  Future<void> _confirmExit() async {
    if (_hasil.isEmpty || _isSelesai) {
      setState(() => _forceExit = true);
      context.pop();
      return;
    }
    final confirmed = await showConfirmDialog(
      context,
      title: 'Keluar Setoran?',
      content: 'Progress setoran akan hilang jika keluar sekarang.',
      confirmLabel: 'Keluar',
      cancelLabel: 'Lanjutkan',
    );
    if (confirmed && mounted) {
      setState(() => _forceExit = true);
      context.pop();
    }
  }
}
