import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/utils/bottom_sheet_utils.dart';
import 'package:equran_app/features/audio/domain/entities/audio_state_entity.dart';
import 'package:equran_app/features/audio/domain/entities/download_state.dart';
import 'package:equran_app/features/audio/presentation/cubit/audio_cubit.dart';
import 'package:equran_app/features/audio/presentation/cubit/audio_download_cubit.dart';
import 'package:equran_app/features/bookmark/domain/entities/bookmark.dart';
import 'package:equran_app/features/bookmark/presentation/cubit/bookmark_cubit.dart';
import 'package:equran_app/features/catatan_ayat/presentation/cubit/catatan_ayat_cubit.dart';
import 'package:equran_app/features/catatan_ayat/presentation/widgets/catatan_editor_sheet.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:equran_app/features/surat_detail/presentation/controllers/viewport_detection_controller.dart';
import 'package:equran_app/features/surat_detail/presentation/pages/share_ayat_page.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/ayat_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// SliverList builder untuk daftar ayat di SuratDetailPage.
class AyatListView extends StatelessWidget {
  const AyatListView({
    required this.detail,
    required this.viewportController,
    required this.onSaveLastRead,
    super.key,
  });

  final SuratDetail detail;
  final ViewportDetectionController viewportController;
  final void Function(SuratDetail detail, int ayatNomor) onSaveLastRead;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return BlocBuilder<BookmarkCubit, BookmarkState>(
      builder: (context, bookmarkState) {
        final bookmarks =
            bookmarkState.mapOrNull(success: (s) => s.bookmarks) ?? [];

        return BlocBuilder<AudioCubit, AudioPlayerState>(
          buildWhen: (prev, next) =>
              prev.currentAyat != next.currentAyat ||
              prev.isPlaying != next.isPlaying ||
              prev.isLoading != next.isLoading ||
              prev.isPaused != next.isPaused ||
              prev.currentQari != next.currentQari,
          builder: (context, audioState) {
            final cubit = context.read<AudioCubit>();
            final qari = audioState.currentQari;

            return BlocBuilder<AudioDownloadCubit, AudioDownloadState>(
              builder: (context, downloadState) {
                final downloadCubit = context.read<AudioDownloadCubit>();

                return SliverList.builder(
                  itemCount: detail.ayatList.length,
                  itemBuilder: (_, i) {
                    final ayat = detail.ayatList[i];
                    final itemKey = viewportController.keyFor(ayat.nomorAyat);

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

                    final audioUrl =
                        ayat.audio[qari.id] ?? ayat.audio.values.firstOrNull;

                    final ayatDownloadState = downloadState.stateFor(
                      detail.info.nomor,
                      ayat.nomorAyat,
                      qari.id,
                    );
                    final isDownloaded =
                        ayatDownloadState == const DownloadState.done();
                    final isDownloading =
                        ayatDownloadState is DownloadDownloading ||
                        downloadState.isDownloadingSurat;
                    final dlProgress = ayatDownloadState.maybeMap(
                      downloading: (s) => s.progress,
                      orElse: () => 0.0,
                    );

                    return Container(
                      key: itemKey,
                      // Luxury highlight — left accent bar saat playing
                      decoration: isCurrentAyat
                          ? BoxDecoration(
                              color: isDark
                                  ? AppColors.primaryDark.withValues(alpha: 0.3)
                                  : AppColors.primaryContainer.withValues(
                                      alpha: 0.4,
                                    ),
                              border: Border(
                                left: BorderSide(
                                  color: isDark
                                      ? AppColors.primaryLighter
                                      : AppColors.primary,
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
                        isDownloaded: isDownloaded,
                        isDownloading: isDownloading,
                        downloadProgress: dlProgress,
                        onBookmarkToggle: () {
                          onSaveLastRead(detail, ayat.nomorAyat);
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
                                if (isCurrentAyat) {
                                  if (isPlaying) {
                                    unawaited(cubit.pause());
                                  } else {
                                    unawaited(cubit.resume());
                                  }
                                } else {
                                  unawaited(
                                    cubit.playFullSurat(
                                      ayatList: detail.ayatList,
                                      startIndex: i,
                                      qari: qari,
                                      suratNomor: detail.info.nomor,
                                      suratName: detail.info.namaLatin,
                                      audioMap: detail.audioFull,
                                    ),
                                  );
                                }
                              },
                        onShareTap: () => _showSharePage(context, ayat),
                        hasCatatan: context.read<CatatanAyatCubit>().hasCatatan(
                          suratNomor: detail.info.nomor,
                          ayatNomor: ayat.nomorAyat,
                        ),
                        onCatatanTap: () => _showCatatanSheet(context, ayat),
                        onDownloadTap: audioUrl == null
                            ? null
                            : () {
                                unawaited(
                                  downloadCubit.downloadAyat(
                                    suratNomor: detail.info.nomor,
                                    ayat: ayat,
                                    qari: qari,
                                  ),
                                );
                              },
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  void _showSharePage(BuildContext context, Ayat ayat) {
    unawaited(
      Navigator.push<void>(
        context,
        MaterialPageRoute(
          builder: (_) => ShareAyatPage(
            ayat: ayat,
            namaLatin: detail.info.namaLatin,
            suratNomor: detail.info.nomor,
          ),
        ),
      ),
    );
  }

  void _showCatatanSheet(BuildContext context, Ayat ayat) {
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
