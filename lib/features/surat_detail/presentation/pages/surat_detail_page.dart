import 'dart:async';

import 'package:equran_app/core/utils/failure_extension.dart';
import 'package:equran_app/core/widgets/error_state_widget.dart';
import 'package:equran_app/core/widgets/loading_widget.dart';
import 'package:equran_app/features/audio/presentation/providers.dart';
import 'package:equran_app/features/bookmark/presentation/providers.dart';
import 'package:equran_app/features/bookmark/presentation/viewmodels/bookmark_viewmodel.dart';
import 'package:equran_app/features/quran_reminder/presentation/providers.dart';
import 'package:equran_app/features/reading_progress/presentation/providers.dart';
import 'package:equran_app/features/reading_progress/presentation/viewmodels/reading_progress_viewmodel.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:equran_app/features/surat_detail/presentation/controllers/card_stack_controller.dart';
import 'package:equran_app/features/surat_detail/presentation/providers.dart';
import 'package:equran_app/features/surat_detail/presentation/services/last_read_helper.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/surat_detail_card_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SuratDetailPage extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(suratDetailViewModelProvider(nomor));

    return switch (state) {
      SuratDetailInitial() => const Scaffold(body: LoadingWidget()),
      SuratDetailLoading() => const Scaffold(body: LoadingWidget()),
      SuratDetailSuccess(:final detail) => _SuratDetailView(
        detail: detail,
        nomor: nomor,
        initialAyat: initialAyat,
        autoPlay: autoPlay,
      ),
      SuratDetailFailure(:final failure) => Scaffold(
        appBar: AppBar(),
        body: ErrorStateWidget(
          message: failure.toUserMessage(),
          onRetry: () => ref
              .read(suratDetailViewModelProvider(nomor).notifier)
              .retry(nomor),
        ),
      ),
    };
  }
}

class _SuratDetailView extends StatefulWidget {
  const _SuratDetailView({
    required this.detail,
    required this.nomor,
    required this.autoPlay,
    this.initialAyat,
  });

  final SuratDetail detail;
  final int nomor;
  final int? initialAyat;
  final bool autoPlay;

  @override
  State<_SuratDetailView> createState() => _SuratDetailViewState();
}

class _SuratDetailViewState extends State<_SuratDetailView> {
  CardStackController? _cardController;
  bool _autoScrollEnabled = true;
  BookmarkViewModel? _bookmarkViewModel;
  ReadingProgressViewModel? _readingProgressViewModel;
  AudioViewModel? _audioViewModel;

  @override
  void initState() {
    super.initState();
    unawaited(
      ProviderScope.containerOf(
        context,
      ).read(quranStreakViewModelProvider.notifier).recordRead(),
    );
    _bookmarkViewModel = ProviderScope.containerOf(
      context,
    ).read(bookmarkViewModelProvider.notifier);
    _readingProgressViewModel = ProviderScope.containerOf(
      context,
    ).read(readingProgressViewModelProvider.notifier);
    // Simpan referensi AudioViewModel di initState agar aman dipakai di dispose()
    // tanpa perlu context.read (context tidak valid saat dispose).
    _audioViewModel = ProviderScope.containerOf(
      context,
    ).read(audioViewModelProvider.notifier);
  }

  @override
  void dispose() {
    _cardController?.removeListener(_onCardProgress);

    // Sync posisi card ke audio aktif sebelum save last read.
    // Mencegah "stuck ayat" saat user keluar di tengah auto-read —
    // _maxReachedIndex mungkin belum ter-update jika animasi belum selesai.
    // Pakai _audioViewModel (disimpan di initState) — context tidak valid di dispose().
    final currentAyat = _audioViewModel?.currentAyat;
    if (currentAyat != null &&
        (_audioViewModel?.isPlaylistMode ?? false) &&
        _cardController != null) {
      _cardController!.jumpTo(currentAyat);
    }

    _saveLastRead();

    // Dispose controller — reset akan dipanggil di controller.dispose()
    _cardController?.dispose();
    super.dispose();
  }

  void _onCardProgress() {
    final controller = _cardController;
    final detail = widget.detail;
    if (controller == null) return;

    // Buffer ayat yang sedang dibaca ke ReadingProgressViewModel
    final ayatNomor = controller.currentAyatNomor;
    if (ayatNomor > 0) {
      _readingProgressViewModel?.bufferAyat(detail.nomor, ayatNomor);
    }
  }

  void _saveLastRead() {
    final controller = _cardController;
    final detail = widget.detail;
    final viewModel = _bookmarkViewModel;
    if (controller == null || viewModel == null) return;

    LastReadHelper.saveLastRead(
      viewModel: viewModel,
      controller: controller,
      detail: detail,
    );
  }

  void _initCardController(SuratDetail detail) {
    if (_cardController != null) return;

    // Prioritas initial index:
    // 1. initialAyat dari route param (misal dari bookmark tap)
    // 2. lastRead.ayatNomor dari BookmarkViewModel (resume saat reload)
    // 3. 0 (info card)
    var initialIndex = 0;

    if (widget.initialAyat != null) {
      initialIndex = widget.initialAyat!.clamp(1, detail.ayatList.length);
    } else {
      final bookmarkState = ProviderScope.containerOf(
        context,
      ).read(bookmarkViewModelProvider);
      final lastRead = bookmarkState.mapOrNull(
        success: (s) => s.lastRead,
      );
      if (lastRead != null && lastRead.suratNomor == detail.nomor) {
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
    final detail = widget.detail;
    final isFirstLoad = _cardController == null;
    _initCardController(detail);

    // Load audio download status + autoPlay — hanya sekali saat first load
    if (isFirstLoad) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final audioNotifier = ProviderScope.containerOf(
          context,
        ).read(audioViewModelProvider.notifier);
        final qari = audioNotifier.currentQari;
        unawaited(
          ProviderScope.containerOf(context)
              .read(audioDownloadViewModelProvider.notifier)
              .loadDownloadedStatus(
                suratNomor: detail.nomor,
                ayatList: detail.ayatList,
                qari: qari,
              ),
        );
        if (widget.autoPlay) {
          unawaited(
            audioNotifier.playFullSurat(
              ayatList: detail.ayatList,
              startIndex: 0,
              qari: qari,
              suratNomor: detail.nomor,
              suratName: detail.namaLatin,
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
