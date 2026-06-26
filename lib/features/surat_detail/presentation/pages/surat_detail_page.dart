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
import 'package:equran_app/features/surat_detail/presentation/providers.dart';
import 'package:equran_app/features/surat_detail/presentation/services/last_read_helper.dart';
import 'package:equran_app/features/surat_detail/presentation/viewmodels/auto_read_notifier.dart';
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

class _SuratDetailView extends ConsumerStatefulWidget {
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
  ConsumerState<_SuratDetailView> createState() => _SuratDetailViewState();
}

class _SuratDetailViewState extends ConsumerState<_SuratDetailView> {
  bool _autoScrollEnabled = true;
  BookmarkViewModel? _bookmarkViewModel;
  ReadingProgressViewModel? _readingProgressViewModel;
  AudioViewModel? _audioViewModel;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(ref.read(quranStreakViewModelProvider.notifier).recordRead());
    });
    _bookmarkViewModel = ref.read(bookmarkViewModelProvider.notifier);
    _readingProgressViewModel = ref.read(
      readingProgressViewModelProvider.notifier,
    );
    // Simpan referensi AudioViewModel di initState agar aman dipakai di dispose()
    // tanpa perlu context.read (context tidak valid saat dispose).
    _audioViewModel = ref.read(audioViewModelProvider.notifier);
  }

  void _initializeCardStack(SuratDetail detail) {
    if (_isInitialized) return;

    final totalAyat = detail.ayatList.length;
    
    // Prioritas initial index:
    // 1. initialAyat dari route param (misal dari bookmark tap)
    // 2. lastRead.ayatNomor dari BookmarkViewModel (resume saat reload)
    // 3. 0 (info card)
    var initialIndex = 0;

    if (widget.initialAyat != null) {
      initialIndex = widget.initialAyat!.clamp(1, totalAyat);
    } else {
      final bookmarkState = ref.read(bookmarkViewModelProvider);
      final lastRead = bookmarkState.mapOrNull(
        success: (s) => s.lastRead,
      );
      if (lastRead != null && lastRead.suratNomor == detail.nomor) {
        initialIndex = lastRead.ayatNomor.clamp(1, totalAyat);
      }
    }

    // Setup initial state dan progress callback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(cardStackProvider(totalAyat).notifier)
        ..jumpToInitial(initialIndex)
        ..onProgressUpdate = (_) {
          // Buffer ayat yang sedang dibaca ke ReadingProgressViewModel
          final cardState = ref.read(cardStackProvider(totalAyat));
          final ayatNomor = cardState.currentAyatNomor;
          if (ayatNomor > 0) {
            _readingProgressViewModel?.bufferAyat(detail.nomor, ayatNomor);
          }
        };
    });

    _isInitialized = true;
  }

  @override
  void dispose() {
    // Sync posisi card ke audio aktif sebelum save last read.
    // Mencegah "stuck ayat" saat user keluar di tengah auto-read —
    // _maxReachedIndex mungkin belum ter-update jika animasi belum selesai.
    // Pakai _audioViewModel (disimpan di initState) — context tidak valid di dispose().
    final currentAyat = _audioViewModel?.currentAyat;
    if (currentAyat != null &&
        (_audioViewModel?.isPlaylistMode ?? false)) {
      final totalAyat = widget.detail.ayatList.length;
      ref.read(cardStackProvider(totalAyat).notifier).jumpTo(currentAyat);
    }

    _saveLastRead();
    super.dispose();
  }

  void _saveLastRead() {
    final detail = widget.detail;
    final viewModel = _bookmarkViewModel;
    if (viewModel == null) return;

    final totalAyat = detail.ayatList.length;
    final cardState = ref.read(cardStackProvider(totalAyat));

    LastReadHelper.saveLastRead(
      viewModel: viewModel,
      cardState: cardState,
      detail: detail,
    );
  }

  @override
  Widget build(BuildContext context) {
    final detail = widget.detail;
    final isFirstLoad = !_isInitialized;
    _initializeCardStack(detail);

    // Load audio download status + autoPlay — hanya sekali saat first load
    if (isFirstLoad) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final audioNotifier = ref.read(audioViewModelProvider.notifier);
        final qari = audioNotifier.currentQari;
        unawaited(
          ref
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
      totalAyat: detail.ayatList.length,
      autoScrollEnabled: _autoScrollEnabled,
      onToggleAutoScroll: () =>
          setState(() => _autoScrollEnabled = !_autoScrollEnabled),
      suratNomor: widget.nomor,
    );
  }
}
