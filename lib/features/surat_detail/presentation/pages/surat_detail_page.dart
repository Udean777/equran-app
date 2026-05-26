import 'dart:async';

import 'package:equran_app/core/utils/bottom_sheet_utils.dart';
import 'package:equran_app/core/utils/failure_extension.dart';
import 'package:equran_app/core/widgets/error_state_widget.dart';
import 'package:equran_app/core/widgets/loading_widget.dart';
import 'package:equran_app/features/audio/domain/entities/audio_state_entity.dart';
import 'package:equran_app/features/audio/presentation/cubit/audio_cubit.dart';
import 'package:equran_app/features/audio/presentation/cubit/audio_download_cubit.dart';
import 'package:equran_app/features/audio/presentation/widgets/audio_player_bar.dart';
import 'package:equran_app/features/bookmark/domain/entities/last_read.dart';
import 'package:equran_app/features/bookmark/presentation/cubit/bookmark_cubit.dart';
import 'package:equran_app/features/catatan_ayat/presentation/cubit/catatan_ayat_cubit.dart';
import 'package:equran_app/features/quran_reminder/presentation/cubit/quran_streak_cubit.dart';
import 'package:equran_app/features/reading_progress/presentation/cubit/reading_progress_cubit.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:equran_app/features/surat_detail/presentation/controllers/viewport_detection_controller.dart';
import 'package:equran_app/features/surat_detail/presentation/cubit/surat_detail_cubit.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/ayat_list_view.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/download_surat_sheet.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/surat_detail_app_bar.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/surat_info_header.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/surat_nav_button.dart';
import 'package:equran_app/features/tafsir/presentation/widgets/tafsir_bottom_sheet.dart';
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
        BlocProvider(
          create: (_) {
            final cubit = getIt<BookmarkCubit>();
            unawaited(cubit.load());
            return cubit;
          },
        ),
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
  final _scrollController = ScrollController();
  late final ViewportDetectionController _viewportController;
  bool _hasScrolled = false;
  bool _autoScrollEnabled = true;
  Timer? _saveDebouncer;
  SuratDetail? _currentDetail;
  BookmarkCubit? _bookmarkCubit;
  ReadingProgressCubit? _readingProgressCubit;

  @override
  void initState() {
    super.initState();
    _viewportController = ViewportDetectionController(
      onAyatRead: (suratNomor, ayatNomor) {
        _readingProgressCubit?.bufferAyat(suratNomor, ayatNomor);
      },
    );
    unawaited(context.read<QuranStreakCubit>().recordRead());
    _bookmarkCubit = context.read<BookmarkCubit>();
    _readingProgressCubit = context.read<ReadingProgressCubit>();
    if (widget.initialAyat != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_hasScrolled) {
          _hasScrolled = true;
          _scrollToAyat(widget.initialAyat!);
        }
      });
    }
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _saveDebouncer?.cancel();
    _viewportController.dispose();
    final readingCubit = _readingProgressCubit;
    if (readingCubit != null) {
      unawaited(readingCubit.flushBuffer());
    }
    final detail = _currentDetail;
    final cubit = _bookmarkCubit;
    if (detail != null && cubit != null) {
      final totalAyat = detail.ayatList.length;
      final ayatNomor = _viewportController.keys.isNotEmpty
          ? _viewportController.keys.keys.first
          : (widget.initialAyat ?? 1);
      final scrollPercent = totalAyat > 0
          ? (ayatNomor / totalAyat).clamp(0.0, 1.0)
          : 0.0;
      unawaited(
        cubit.saveLastRead(
          LastRead(
            suratNomor: detail.info.nomor,
            ayatNomor: ayatNomor,
            namaLatin: detail.info.namaLatin,
            readAt: DateTime.now(),
            scrollPercent: scrollPercent,
            totalAyat: totalAyat,
          ),
        ),
      );
    }
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    _saveDebouncer?.cancel();
    _saveDebouncer = Timer(const Duration(seconds: 1), _detectVisibleAyat);
    if (mounted) {
      final screenH = MediaQuery.of(context).size.height;
      _viewportController.scheduleCheck(screenH);
    }
  }

  void _detectVisibleAyat() {
    if (!mounted) return;
    final detail = _currentDetail;
    if (detail == null) return;

    final screenH = MediaQuery.of(context).size.height;
    int? bestAyat;
    var bestDy = double.negativeInfinity;

    for (final entry in _viewportController.keys.entries) {
      final ctx = entry.value.currentContext;
      if (ctx == null) continue;
      final box = ctx.findRenderObject();
      if (box == null || box is! RenderBox) continue;
      final pos = box.localToGlobal(Offset.zero);
      if (pos.dy <= screenH * 0.5 && pos.dy > bestDy) {
        bestDy = pos.dy;
        bestAyat = entry.key;
      }
    }

    if (bestAyat != null) {
      _saveLastRead(context, detail, bestAyat);
    }
  }

  void _scrollToAyat(int ayatNomor) {
    final key = _viewportController.keys[ayatNomor];
    if (key?.currentContext != null) {
      unawaited(
        Scrollable.ensureVisible(
          key!.currentContext!,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          alignment: 0.1,
        ),
      );
    }
  }

  void _saveLastRead(BuildContext context, SuratDetail detail, int ayatNomor) {
    final totalAyat = detail.ayatList.length;
    final scrollPercent = totalAyat > 0
        ? (ayatNomor / totalAyat).clamp(0.0, 1.0)
        : 0.0;
    unawaited(
      context.read<BookmarkCubit>().saveLastRead(
        LastRead(
          suratNomor: detail.info.nomor,
          ayatNomor: ayatNomor,
          namaLatin: detail.info.namaLatin,
          readAt: DateTime.now(),
          scrollPercent: scrollPercent,
          totalAyat: totalAyat,
        ),
      ),
    );
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
    final isFirstLoad = _currentDetail == null;
    _currentDetail = detail;
    _viewportController.setSurat(detail.info.nomor);

    if (isFirstLoad) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _detectVisibleAyat();
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

    return BlocConsumer<AudioCubit, AudioPlayerState>(
      buildWhen: (prev, next) =>
          prev.currentAyat != next.currentAyat ||
          prev.isPlaying != next.isPlaying ||
          prev.isLoading != next.isLoading ||
          prev.isPaused != next.isPaused ||
          prev.currentQari != next.currentQari,
      listenWhen: (prev, next) => prev.currentAyat != next.currentAyat,
      listener: (context, audioState) {
        final cubit = context.read<AudioCubit>();
        if (_autoScrollEnabled &&
            cubit.isPlaylistMode &&
            audioState.currentAyat != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToAyat(audioState.currentAyat!);
          });
        }
      },
      builder: (context, audioState) {
        final qari = audioState.currentQari;

        return Scaffold(
          appBar: SuratDetailAppBar(
            detail: detail,
            autoScrollEnabled: _autoScrollEnabled,
            onToggleAutoScroll: () =>
                setState(() => _autoScrollEnabled = !_autoScrollEnabled),
            onDownloadTap: () => _showDownloadSuratSheet(context, detail, qari),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _showTafsirBottomSheet(context, widget.nomor),
            icon: const Icon(Icons.menu_book_rounded),
            label: const Text('Lihat Tafsir'),
          ),
          bottomNavigationBar: AudioPlayerBar(audioMap: detail.audioFull),
          body: RefreshIndicator(
            onRefresh: () async =>
                context.read<SuratDetailCubit>().load(widget.nomor),
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: SuratInfoHeader(detail: detail),
                ),
                AyatListView(
                  detail: detail,
                  viewportController: _viewportController,
                  onSaveLastRead: (d, ayatNomor) =>
                      _saveLastRead(context, d, ayatNomor),
                ),
                SliverToBoxAdapter(
                  child: SuratNavButton(
                    suratSebelumnya: detail.suratSebelumnya,
                    suratSelanjutnya: detail.suratSelanjutnya,
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showTafsirBottomSheet(BuildContext context, int nomor) {
    unawaited(
      showAppBottomSheet<void>(
        context,
        builder: (_) => TafsirBottomSheet(nomor: nomor),
      ),
    );
  }

  void _showDownloadSuratSheet(
    BuildContext context,
    SuratDetail detail,
    Qari qari,
  ) {
    unawaited(
      showAppBottomSheet<void>(
        context,
        builder: (_) => DownloadSuratSheet(
          detail: detail,
          qari: qari,
          downloadCubit: context.read<AudioDownloadCubit>(),
        ),
      ),
    );
  }
}
