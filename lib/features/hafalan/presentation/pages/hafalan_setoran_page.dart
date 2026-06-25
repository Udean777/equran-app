import 'dart:async';

import 'package:equran_app/core/constants/juz_constants.dart';
import 'package:equran_app/core/services/audio_recorder_service.dart';
import 'package:equran_app/core/utils/dialog_utils.dart';
import 'package:equran_app/core/utils/failure_extension.dart';
import 'package:equran_app/core/widgets/error_state_widget.dart';
import 'package:equran_app/core/widgets/loading_widget.dart';
import 'package:equran_app/core/widgets/luxury_app_bar.dart';
import 'package:equran_app/features/hafalan/domain/entities/hafalan_surat.dart';
import 'package:equran_app/features/hafalan/domain/entities/setoran_compare_result.dart';
import 'package:equran_app/features/hafalan/presentation/cubit/hafalan_detail_cubit.dart';
import 'package:equran_app/features/hafalan/presentation/cubit/hafalan_detail_state.dart';
import 'package:equran_app/features/hafalan/presentation/widgets/hafalan_providers.dart';
import 'package:equran_app/features/hafalan/presentation/widgets/setoran_card.dart';
import 'package:equran_app/features/hafalan/presentation/widgets/setoran_hasil.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:equran_app/features/surat_detail/presentation/cubit/surat_detail_cubit.dart';
import 'package:equran_app/injection/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HafalanSetoranPage extends StatelessWidget {
  const HafalanSetoranPage({
    required this.suratNomor,
    this.juzNomor,
    super.key,
  });

  final int suratNomor;
  final int? juzNomor;

  @override
  Widget build(BuildContext context) {
    return HafalanProviders(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) {
              final cubit = getIt<SuratDetailCubit>();
              unawaited(cubit.load(suratNomor));
              return cubit;
            },
          ),
          BlocProvider(
            create: (_) {
              final cubit = getIt<HafalanDetailCubit>();
              unawaited(cubit.loadDetail(suratNomor));
              return cubit;
            },
          ),
        ],
        child: _HafalanSetoranView(suratNomor: suratNomor, juzNomor: juzNomor),
      ),
    );
  }
}

class _HafalanSetoranView extends StatelessWidget {
  const _HafalanSetoranView({
    required this.suratNomor,
    this.juzNomor,
  });

  final int suratNomor;
  final int? juzNomor;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SuratDetailCubit, SuratDetailState>(
      builder: (context, state) => switch (state) {
        SuratDetailInitial() => const Scaffold(body: LoadingWidget()),
        SuratDetailLoading() => const Scaffold(body: LoadingWidget()),
        SuratDetailFailure(:final failure) => Scaffold(
          appBar: const LuxuryAppBar(title: 'Mode Setoran'),
          body: ErrorStateWidget(
            message: failure.toUserMessage(),
            onRetry: () => context.read<SuratDetailCubit>().retry(suratNomor),
          ),
        ),
        SuratDetailSuccess(:final detail) => _SetoranSession(
          detail: detail,
          suratNomor: suratNomor,
          juzNomor: juzNomor,
        ),
      },
    );
  }
}

// ─── Sesi Setoran ─────────────────────────────────────────────────────────────

class _SetoranSession extends StatefulWidget {
  const _SetoranSession({
    required this.detail,
    required this.suratNomor,
    this.juzNomor,
  });

  final SuratDetail detail;
  final int suratNomor;
  final int? juzNomor;

  @override
  State<_SetoranSession> createState() => _SetoranSessionState();
}

class _SetoranSessionState extends State<_SetoranSession> {
  late final List<Ayat> _ayatList;

  // Session state
  int _currentIndex = 0;
  final Map<int, bool> _hasil = {};
  final Map<int, SetoranCompareResult> _compareResults = {};
  bool _showTerjemahan = false;
  bool _isSelesai = false;

  // Recording state
  SetoranRecordState _recordState = SetoranRecordState.idle;

  @override
  void initState() {
    super.initState();

    // Ambil range ayat untuk surat ini di juz yang aktif
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

    return Scaffold(
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
          : BlocConsumer<HafalanDetailCubit, HafalanDetailState>(
              listener: (context, state) {
                if (state is HafalanDetailCompareSuccess &&
                    state.ayatNomor == _currentAyat.nomorAyat) {
                  _handleCompareSuccess(state.result);
                } else if (state is HafalanDetailCompareFailure &&
                    state.ayatNomor == _currentAyat.nomorAyat) {
                  _handleCompareFailure(state.message);
                }
              },
              builder: (context, state) {
                final isComparing =
                    state is HafalanDetailComparing &&
                    state.ayatNomor == _currentAyat.nomorAyat;

                return SetoranCard(
                  ayat: _currentAyat,
                  currentIndex: _currentIndex,
                  totalAyat: _totalAyat,
                  showTerjemahan: _showTerjemahan,
                  onToggleTerjemahan: () =>
                      setState(() => _showTerjemahan = !_showTerjemahan),
                  recordState: isComparing
                      ? SetoranRecordState.comparing
                      : _recordState,
                  compareResult: _compareResults[_currentAyat.nomorAyat],
                  onStartRecord: _startRecording,
                  onStopRecord: _stopRecording,
                  onHafal: () => _jawab(hafal: true),
                  onBelumHafal: () => _jawab(hafal: false),
                );
              },
            ),
    );
  }

  // ─── Recording ───────────────────────────────────────────────────────

  Future<void> _startRecording() async {
    final recorder = getIt<AudioRecorderService>();

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
      setState(() => _recordState = SetoranRecordState.recording);
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

    unawaited(
      context.read<HafalanDetailCubit>().compareRecitation(
        ayatNomor: _currentAyat.nomorAyat,
        targetText: _currentAyat.teksArab,
      ),
    );
  }

  void _handleCompareSuccess(SetoranCompareResult result) {
    setState(() {
      _recordState = SetoranRecordState.idle;
      _compareResults[_currentAyat.nomorAyat] = result;

      if (result.passed) {
        _hasil[_currentAyat.nomorAyat] = true;
        _advanceToNext();
      }
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

  // ─── Navigation ──────────────────────────────────────────────────────

  void _jawab({required bool hafal}) {
    _hasil[_currentAyat.nomorAyat] = hafal;
    if (!hafal) {
      _compareResults.remove(_currentAyat.nomorAyat);
    }
    _advanceToNext();
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
      _showTerjemahan = false;
      _isSelesai = false;
      _recordState = SetoranRecordState.idle;
    });
  }

  Future<void> _simpanHasil() async {
    await context.read<HafalanDetailCubit>().saveSetoranHasil(
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
    if (_hasil.isEmpty) {
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
    if (confirmed && mounted) context.pop();
  }
}
