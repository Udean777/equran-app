import 'dart:async';

import 'package:equran_app/core/utils/dialog_utils.dart';
import 'package:equran_app/core/utils/failure_extension.dart';
import 'package:equran_app/core/widgets/error_state_widget.dart';
import 'package:equran_app/core/widgets/loading_widget.dart';
import 'package:equran_app/core/widgets/luxury_app_bar.dart';
import 'package:equran_app/features/hafalan/domain/entities/hafalan_surat.dart';
import 'package:equran_app/features/hafalan/presentation/cubit/hafalan_detail_cubit.dart';
import 'package:equran_app/features/hafalan/presentation/widgets/hafalan_providers.dart';
import 'package:equran_app/features/hafalan/presentation/widgets/setoran_card.dart';
import 'package:equran_app/features/hafalan/presentation/widgets/setoran_hasil.dart';
import 'package:equran_app/features/surat_detail/constants/juz_mapping.dart';
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
  int _currentIndex = 0;
  final Map<int, bool> _hasil = {};
  bool _showTerjemahan = false;
  bool _isSelesai = false;

  @override
  void initState() {
    super.initState();

    // Ambil range ayat untuk surat ini di juz yang aktif
    final range = widget.juzNomor != null
        ? kJuzSurahVerseRanges['${widget.juzNomor}:${widget.suratNomor}']
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
        : 'Setoran: ${widget.detail.info.namaLatin}';

    return Scaffold(
      appBar: LuxuryAppBar(
        title: title,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          tooltip: 'Keluar',
          onPressed: () => _confirmExit(context),
        ),
      ),
      body: _isSelesai
          ? SetoranHasil(
              detail: widget.detail,
              hasil: _hasil,
              onSimpan: () => _simpanHasil(context),
              onUlang: _ulangSetoran,
            )
          : SetoranCard(
              ayat: _currentAyat,
              currentIndex: _currentIndex,
              totalAyat: _totalAyat,
              showTerjemahan: _showTerjemahan,
              onToggleTerjemahan: () =>
                  setState(() => _showTerjemahan = !_showTerjemahan),
              onHafal: () => _jawab(hafal: true),
              onBelumHafal: () => _jawab(hafal: false),
            ),
    );
  }

  void _jawab({required bool hafal}) {
    _hasil[_currentAyat.nomorAyat] = hafal;
    if (_currentIndex < _totalAyat - 1) {
      setState(() {
        _currentIndex++;
        _showTerjemahan = false;
      });
    } else {
      setState(() => _isSelesai = true);
    }
  }

  void _ulangSetoran() {
    setState(() {
      _currentIndex = 0;
      _hasil.clear();
      _showTerjemahan = false;
      _isSelesai = false;
    });
  }

  Future<void> _simpanHasil(BuildContext context) async {
    await context.read<HafalanDetailCubit>().saveSetoranHasil(
      suratNomor: widget.suratNomor,
      hasil: _hasil,
      suratInfo: HafalanSurat.fromSurat(widget.detail.info),
    );

    if (context.mounted) {
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

  Future<void> _confirmExit(BuildContext context) async {
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
    if (confirmed && context.mounted) context.pop();
  }
}
