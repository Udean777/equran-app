import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/utils/bottom_sheet_utils.dart';
import 'package:equran_app/core/utils/failure_extension.dart';
import 'package:equran_app/core/widgets/error_state_widget.dart';
import 'package:equran_app/core/widgets/loading_widget.dart';
import 'package:equran_app/features/audio/domain/entities/audio_state_entity.dart';
import 'package:equran_app/features/audio/presentation/cubit/audio_cubit.dart';
import 'package:equran_app/features/audio/presentation/widgets/audio_player_bar.dart';
import 'package:equran_app/features/bookmark/domain/entities/bookmark.dart';
import 'package:equran_app/features/bookmark/domain/entities/last_read.dart';
import 'package:equran_app/features/bookmark/presentation/cubit/bookmark_cubit.dart';
import 'package:equran_app/features/catatan_ayat/presentation/cubit/catatan_ayat_cubit.dart';
import 'package:equran_app/features/catatan_ayat/presentation/widgets/catatan_editor_sheet.dart';
import 'package:equran_app/features/quran_reminder/presentation/cubit/quran_streak_cubit.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:equran_app/features/surat_detail/presentation/cubit/surat_detail_cubit.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/ayat_card.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/share_ayat_sheet.dart';
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
    super.key,
  });

  final int nomor;
  final int? initialAyat;

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
          create: (_) => getIt<CatatanAyatCubit>()..load(),
        ),
        // AudioCubit adalah singleton — pakai getIt langsung tanpa create baru
        BlocProvider.value(value: getIt<AudioCubit>()),
      ],
      child: _SuratDetailView(nomor: nomor, initialAyat: initialAyat),
    );
  }
}

class _SuratDetailView extends StatefulWidget {
  const _SuratDetailView({required this.nomor, this.initialAyat});

  final int nomor;
  final int? initialAyat;

  @override
  State<_SuratDetailView> createState() => _SuratDetailViewState();
}

class _SuratDetailViewState extends State<_SuratDetailView> {
  final _scrollController = ScrollController();
  final _itemKeys = <int, GlobalKey>{};
  bool _hasScrolled = false;

  @override
  void initState() {
    super.initState();
    // Record streak — user membuka surat berarti baca Quran hari ini
    unawaited(context.read<QuranStreakCubit>().recordRead());
    // Scroll ke initialAyat hanya sekali setelah frame pertama
    if (widget.initialAyat != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_hasScrolled) {
          _hasScrolled = true;
          _scrollToAyat(widget.initialAyat!);
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToAyat(int ayatNomor) {
    final key = _itemKeys[ayatNomor];
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
    unawaited(
      context.read<BookmarkCubit>().saveLastRead(
        LastRead(
          suratNomor: detail.info.nomor,
          ayatNomor: ayatNomor,
          namaLatin: detail.info.namaLatin,
          readAt: DateTime.now(),
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
    return BlocBuilder<BookmarkCubit, BookmarkState>(
      builder: (context, bookmarkState) {
        final bookmarks =
            bookmarkState.mapOrNull(success: (s) => s.bookmarks) ?? [];

        return BlocConsumer<AudioCubit, AudioPlayerState>(
          // Hanya rebuild saat state yang relevan berubah —
          // mencegah rebuild seluruh SliverList setiap audio tick
          buildWhen: (prev, next) =>
              prev.currentAyat != next.currentAyat ||
              prev.isPlaying != next.isPlaying ||
              prev.isLoading != next.isLoading ||
              prev.isPaused != next.isPaused ||
              prev.currentQari != next.currentQari,
          // Auto-scroll ke ayat yang sedang diputar saat playlist mode
          listener: (context, audioState) {
            final cubit = context.read<AudioCubit>();
            if (cubit.isPlaylistMode && audioState.currentAyat != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _scrollToAyat(audioState.currentAyat!);
              });
            }
          },
          builder: (context, audioState) {
            final cubit = context.read<AudioCubit>();

            return Scaffold(
              appBar: AppBar(
                title: Text(detail.info.namaLatin),
                actions: [
                  // Tombol Play Surat
                  IconButton(
                    icon: Icon(
                      cubit.isPlaylistMode && audioState.isPlaying
                          ? Icons.pause_circle_outline_rounded
                          : Icons.play_circle_outline_rounded,
                    ),
                    color: AppColors.primary,
                    tooltip: 'Play Surat',
                    onPressed: () {
                      if (cubit.isPlaylistMode && audioState.isPlaying) {
                        unawaited(cubit.pause());
                      } else if (cubit.isPlaylistMode && audioState.isPaused) {
                        unawaited(cubit.resume());
                      } else {
                        unawaited(
                          cubit.playFullSurat(
                            ayatList: detail.ayatList,
                            startIndex: 0,
                            qari: audioState.currentQari,
                            suratNomor: detail.info.nomor,
                            suratName: detail.info.namaLatin,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () => _showTafsirBottomSheet(context, widget.nomor),
                icon: const Icon(Icons.menu_book_rounded),
                label: const Text('Lihat Tafsir'),
              ),
              // AudioPlayerBar sebagai persistent bottom widget
              bottomNavigationBar: AudioPlayerBar(
                audioMap: detail.audioFull,
              ),
              body: RefreshIndicator(
                onRefresh: () async =>
                    context.read<SuratDetailCubit>().load(widget.nomor),
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: SuratInfoHeader(detail: detail),
                    ),
                    SliverList.builder(
                      itemCount: detail.ayatList.length,
                      itemBuilder: (_, i) {
                        final ayat = detail.ayatList[i];
                        _itemKeys[ayat.nomorAyat] ??= GlobalKey();

                        final isBookmarked = bookmarks.any(
                          (b) =>
                              b.suratNomor == detail.info.nomor &&
                              b.ayatNomor == ayat.nomorAyat,
                        );

                        final isCurrentAyat =
                            audioState.currentAyat == ayat.nomorAyat;
                        final isPlaying = isCurrentAyat && audioState.isPlaying;
                        final isAudioLoading =
                            isCurrentAyat && audioState.isLoading;

                        // Ambil URL audio dari qari yang sedang aktif
                        final qari = audioState.currentQari;
                        final audioUrl =
                            ayat.audio[qari.id] ??
                            ayat.audio.values.firstOrNull;

                        return Container(
                          key: _itemKeys[ayat.nomorAyat],
                          decoration: isCurrentAyat
                              ? BoxDecoration(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.05,
                                  ),
                                  border: const Border(
                                    left: BorderSide(
                                      color: AppColors.primary,
                                      width: 3,
                                    ),
                                  ),
                                )
                              : null,
                          child: AyatCard(
                            ayat: ayat,
                            isBookmarked: isBookmarked,
                            isPlaying: isPlaying,
                            isAudioLoading: isAudioLoading,
                            onBookmarkToggle: () {
                              _saveLastRead(context, detail, ayat.nomorAyat);
                              if (isBookmarked) {
                                unawaited(
                                  context.read<BookmarkCubit>().removeBookmark(
                                    suratNomor: detail.info.nomor,
                                    ayatNomor: ayat.nomorAyat,
                                  ),
                                );
                              } else {
                                unawaited(
                                  context.read<BookmarkCubit>().addBookmark(
                                    Bookmark(
                                      suratNomor: detail.info.nomor,
                                      ayatNomor: ayat.nomorAyat,
                                      namaLatin: detail.info.namaLatin,
                                      teksArab: ayat.teksArab,
                                      teksIndonesia: ayat.teksIndonesia,
                                      savedAt: DateTime.now(),
                                    ),
                                  ),
                                );
                              }
                            },
                            onPlayTap: audioUrl == null
                                ? null
                                : () {
                                    unawaited(
                                      cubit.playOrToggle(
                                        url: audioUrl,
                                        ayatNomor: ayat.nomorAyat,
                                        qari: qari,
                                        suratNomor: detail.info.nomor,
                                      ),
                                    );
                                  },
                            onShareTap: () => _showShareSheet(
                              context,
                              ayat,
                              detail,
                            ),
                            hasCatatan: context
                                .read<CatatanAyatCubit>()
                                .hasCatatan(
                                  suratNomor: detail.info.nomor,
                                  ayatNomor: ayat.nomorAyat,
                                ),
                            onCatatanTap: () => _showCatatanSheet(
                              context,
                              ayat,
                              detail,
                            ),
                          ),
                        );
                      },
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

  void _showShareSheet(BuildContext context, Ayat ayat, SuratDetail detail) {
    unawaited(
      showAppBottomSheet<void>(
        context,
        builder: (_) => ShareAyatSheet(
          ayat: ayat,
          namaLatin: detail.info.namaLatin,
          suratNomor: detail.info.nomor,
        ),
      ),
    );
  }

  void _showCatatanSheet(BuildContext context, Ayat ayat, SuratDetail detail) {
    final existing = context.read<CatatanAyatCubit>().getCatatan(
      suratNomor: detail.info.nomor,
      ayatNomor: ayat.nomorAyat,
    );
    unawaited(
      showAppBottomSheet<void>(
        context,
        builder: (_) => BlocProvider.value(
          value: context.read<CatatanAyatCubit>(),
          child: CatatanEditorSheet(
            suratNomor: detail.info.nomor,
            ayatNomor: ayat.nomorAyat,
            namaLatin: detail.info.namaLatin,
            teksArab: ayat.teksArab,
            existing: existing,
          ),
        ),
      ),
    );
  }
}
