import 'dart:async';

import 'package:equran_app/core/utils/failure_extension.dart';
import 'package:equran_app/core/widgets/error_state_widget.dart';
import 'package:equran_app/core/widgets/loading_widget.dart';
import 'package:equran_app/features/audio/domain/entities/audio_state_entity.dart';
import 'package:equran_app/features/audio/presentation/cubit/audio_cubit.dart';
import 'package:equran_app/features/audio/presentation/cubit/audio_download_cubit.dart';
import 'package:equran_app/features/bookmark/domain/entities/last_read.dart';
import 'package:equran_app/features/bookmark/presentation/cubit/bookmark_cubit.dart';
import 'package:equran_app/features/catatan_ayat/presentation/cubit/catatan_ayat_cubit.dart';
import 'package:equran_app/features/quran_reminder/presentation/cubit/quran_streak_cubit.dart';
import 'package:equran_app/features/reading_progress/presentation/cubit/reading_progress_cubit.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:equran_app/features/surat_detail/presentation/controllers/card_stack_controller.dart';
import 'package:equran_app/features/surat_detail/presentation/cubit/surat_detail_cubit.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/surat_detail_card_view.dart';
import 'package:equran_app/injection/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SuratDetailPage extends StatelessWidget {
  const SuratDetailPage({
    required this.nomor,
    this.initialAyat,
    this.autoPlay = false,
    super.key,
  });

  final int nomor;
  final int? initialAyat;
  final bool autoPlay;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            final cubit = getIt<SuratDetailCubit>();
            unawaited(cubit.load(nomor));
            return cubit;
          },
        ),
        // BookmarkCubit dari root — pakai BlocProvider.value agar update realtime di home
        BlocProvider.value(value: context.read<BookmarkCubit>()),
        BlocProvider(
          create: (_) {
            final cubit = getIt<CatatanAyatCubit>();
            unawaited(cubit.load());
            return cubit;
          },
        ),
        // AudioCubit adalah singleton di root — pakai BlocProvider.value
        BlocProvider.value(value: context.read<AudioCubit>()),
        // AudioDownloadCubit — per halaman surat
        BlocProvider(create: (_) => getIt<AudioDownloadCubit>()),
        // ReadingProgressCubit — factory, per halaman surat
        BlocProvider(create: (_) => getIt<ReadingProgressCubit>()),
      ],
      child: _SuratDetailView(
        nomor: nomor,
        initialAyat: initialAyat,
        autoPlay: autoPlay,
      ),
    );
  }
}

class _SuratDetailView extends StatefulWidget {
  const _SuratDetailView({
    required this.nomor,
    required this.autoPlay,
    this.initialAyat,
  });

  final int nomor;
  final int? initialAyat;
  final bool autoPlay;

  @override
  State<_SuratDetailView> createState() => _SuratDetailViewState();
}

class _SuratDetailViewState extends State<_SuratDetailView> {
  CardStackController? _cardController;
  bool _autoScrollEnabled = true;
  SuratDetail? _currentDetail;
  BookmarkCubit? _bookmarkCubit;
  ReadingProgressCubit? _readingProgressCubit;
  AudioCubit? _audioCubit;

  @override
  void initState() {
    super.initState();
    unawaited(context.read<QuranStreakCubit>().recordRead());
    _bookmarkCubit = context.read<BookmarkCubit>();
    _readingProgressCubit = context.read<ReadingProgressCubit>();
    // Simpan referensi AudioCubit di initState agar aman dipakai di dispose()
    // tanpa perlu context.read (context tidak valid saat dispose).
    _audioCubit = context.read<AudioCubit>();
  }

  @override
  void dispose() {
    _cardController?.removeListener(_onCardProgress);

    // Sync posisi card ke audio aktif sebelum save last read.
    // Mencegah "stuck ayat" saat user keluar di tengah auto-read —
    // _maxReachedIndex mungkin belum ter-update jika animasi belum selesai.
    // Pakai _audioCubit (disimpan di initState) — context tidak valid di dispose().
    final currentAyat = _audioCubit?.state.currentAyat;
    if (currentAyat != null &&
        (_audioCubit?.isPlaylistMode ?? false) &&
        _cardController != null) {
      _cardController!.jumpTo(currentAyat);
    }

    _saveLastRead();

    // Reset controller state sebelum dispose untuk mencegah
    // animasi/state tersisa saat back navigation
    _cardController?.reset();
    _cardController?.dispose();
    super.dispose();
  }

  void _onCardProgress() {
    final controller = _cardController;
    final detail = _currentDetail;
    if (controller == null || detail == null) return;

    // Buffer ayat yang sedang dibaca ke ReadingProgressCubit
    final ayatNomor = controller.currentAyatNomor;
    if (ayatNomor > 0) {
      _readingProgressCubit?.bufferAyat(detail.info.nomor, ayatNomor);
    }
  }

  void _saveLastRead() {
    final controller = _cardController;
    final detail = _currentDetail;
    final cubit = _bookmarkCubit;
    if (controller == null || detail == null || cubit == null) return;

    final totalAyat = detail.ayatList.length;
    final ayatNomor = controller.lastReadAyatNomor.clamp(1, totalAyat);
    final scrollPercent = totalAyat > 0
        ? (ayatNomor / totalAyat).clamp(0.0, 1.0)
        : 0.0;
    final maxScrollPercent = controller.maxProgress.clamp(0.0, 1.0);

    unawaited(
      cubit.saveLastRead(
        LastRead(
          suratNomor: detail.info.nomor,
          ayatNomor: ayatNomor,
          namaLatin: detail.info.namaLatin,
          readAt: DateTime.now(),
          scrollPercent: scrollPercent,
          maxScrollPercent: maxScrollPercent,
          totalAyat: totalAyat,
        ),
      ),
    );
  }

  void _initCardController(SuratDetail detail) {
    if (_cardController != null) return;

    // Prioritas initial index:
    // 1. initialAyat dari route param (misal dari bookmark tap)
    // 2. lastRead.ayatNomor dari BookmarkCubit (resume saat reload)
    // 3. 0 (info card)
    var initialIndex = 0;

    if (widget.initialAyat != null) {
      initialIndex = widget.initialAyat!.clamp(1, detail.ayatList.length);
    } else {
      final lastRead = context.read<BookmarkCubit>().state.mapOrNull(
        success: (s) => s.lastRead,
      );
      if (lastRead != null && lastRead.suratNomor == detail.info.nomor) {
        initialIndex = lastRead.ayatNomor.clamp(1, detail.ayatList.length);
      }
    }

    _cardController = CardStackController(
      totalAyat: detail.ayatList.length,
      initialIndex: initialIndex,
      onProgressUpdate: (_) {},
    );
    _cardController!.addListener(_onCardProgress);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SuratDetailCubit, SuratDetailState>(
      builder: (context, state) => switch (state) {
        SuratDetailInitial() => const Scaffold(body: LoadingWidget()),
        SuratDetailLoading() => const Scaffold(body: LoadingWidget()),
        SuratDetailSuccess(:final detail) => _buildSuccess(context, detail),
        SuratDetailFailure(:final failure) => Scaffold(
          appBar: AppBar(),
          body: ErrorStateWidget(
            message: failure.toUserMessage(),
            onRetry: () => context.read<SuratDetailCubit>().retry(widget.nomor),
          ),
        ),
      },
    );
  }

  Widget _buildSuccess(BuildContext context, SuratDetail detail) {
    _currentDetail = detail;
    final isFirstLoad = _cardController == null;
    _initCardController(detail);

    // Load audio download status + autoPlay — hanya sekali saat first load
    if (isFirstLoad) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final audioCubit = context.read<AudioCubit>();
        final qari = audioCubit.state.currentQari;
        unawaited(
          context.read<AudioDownloadCubit>().loadDownloadedStatus(
            suratNomor: detail.info.nomor,
            ayatList: detail.ayatList,
            qari: qari,
          ),
        );
        if (widget.autoPlay) {
          unawaited(
            audioCubit.playFullSurat(
              ayatList: detail.ayatList,
              startIndex: 0,
              qari: qari,
              suratNomor: detail.info.nomor,
              suratName: detail.info.namaLatin,
              audioMap: detail.audioFull,
            ),
          );
        }
      });
    }

    return SuratDetailCardView(
      detail: detail,
      controller: _cardController!,
      autoScrollEnabled: _autoScrollEnabled,
      onToggleAutoScroll: () =>
          setState(() => _autoScrollEnabled = !_autoScrollEnabled),
      suratNomor: widget.nomor,
    );
  }
}
