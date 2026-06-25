import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/utils/bottom_sheet_utils.dart';
import 'package:equran_app/features/audio/domain/entities/download_state.dart';
import 'package:equran_app/features/audio/presentation/providers.dart';
import 'package:equran_app/features/bookmark/presentation/providers.dart';
import 'package:equran_app/features/catatan_ayat/presentation/providers.dart';
import 'package:equran_app/features/catatan_ayat/presentation/widgets/catatan_editor_sheet.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:equran_app/features/surat_detail/presentation/controllers/viewport_detection_controller.dart';
import 'package:equran_app/features/surat_detail/presentation/services/ayat_navigation_helper.dart';
import 'package:equran_app/features/surat_detail/presentation/services/bookmark_toggle_helper.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/ayat_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// SliverList builder untuk daftar ayat di SuratDetailPage.
class AyatListView extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;

    final bookmarkState = ref.watch(bookmarkViewModelProvider);
    final bookmarks =
        bookmarkState.mapOrNull(
          success: (s) => s.bookmarks,
        ) ??
        [];

    final audioState = ref.watch(audioViewModelProvider);
    final downloadState = ref.watch(audioDownloadViewModelProvider);
    final audioNotifier = ref.read(audioViewModelProvider.notifier);
    final downloadNotifier = ref.read(audioDownloadViewModelProvider.notifier);
    final qari = audioState.currentQari;

    return SliverList.builder(
      itemCount: detail.ayatList.length,
      itemBuilder: (_, i) {
        final ayat = detail.ayatList[i];
        final itemKey = viewportController.keyFor(ayat.nomorAyat);

        final isBookmarked = bookmarks.any(
          (b) => b.suratNomor == detail.nomor && b.ayatNomor == ayat.nomorAyat,
        );

        final isCurrentAyat = audioState.currentAyat == ayat.nomorAyat;
        final isPlaying = isCurrentAyat && audioState.isPlaying;
        final isAudioLoading = isCurrentAyat && audioState.isLoading;

        final audioUrl = ayat.audio[qari.id] ?? ayat.audio.values.firstOrNull;

        final ayatDownloadState = downloadState.stateFor(
          detail.nomor,
          ayat.nomorAyat,
          qari.id,
        );
        final isDownloaded = ayatDownloadState == const DownloadState.done();
        final isDownloading =
            ayatDownloadState is DownloadDownloading ||
            downloadState.isDownloadingSurat;
        final dlProgress = ayatDownloadState.maybeMap(
          downloading: (s) => s.progress,
          orElse: () => 0.0,
        );

        return Container(
          key: itemKey,
          decoration: isCurrentAyat
              ? BoxDecoration(
                  color: isDark
                      ? AppColors.primaryDark.withValues(alpha: 0.3)
                      : AppColors.primaryContainer.withValues(
                          alpha: 0.4,
                        ),
                  border: Border(
                    left: BorderSide(
                      color: context.primaryActionColor,
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
              BookmarkToggleHelper.toggle(
                viewModel: ref.read(bookmarkViewModelProvider.notifier),
                detail: detail,
                ayat: ayat,
                isBookmarked: isBookmarked,
              );
            },
            onPlayTap: audioUrl == null
                ? null
                : () {
                    if (isCurrentAyat) {
                      if (isPlaying) {
                        unawaited(audioNotifier.pause());
                      } else {
                        unawaited(audioNotifier.resume());
                      }
                    } else {
                      unawaited(
                        audioNotifier.playFullSurat(
                          ayatList: detail.ayatList,
                          startIndex: i,
                          qari: qari,
                          suratNomor: detail.nomor,
                          suratName: detail.namaLatin,
                          audioMap: detail.audioFull,
                        ),
                      );
                    }
                  },
            onShareTap: () => _showSharePage(context, ayat),
            hasCatatan: ProviderScope.containerOf(context)
                .read(catatanAyatViewModelProvider.notifier)
                .hasCatatan(
                  suratNomor: detail.nomor,
                  ayatNomor: ayat.nomorAyat,
                ),
            onCatatanTap: () => _showCatatanSheet(context, ayat),
            onDownloadTap: audioUrl == null
                ? null
                : () {
                    unawaited(
                      downloadNotifier.downloadAyat(
                        suratNomor: detail.nomor,
                        ayat: ayat,
                        qari: qari,
                      ),
                    );
                  },
          ),
        );
      },
    );
  }

  void _showSharePage(BuildContext context, Ayat ayat) {
    AyatNavigationHelper.openSharePage(
      context,
      ayat: ayat,
      namaLatin: detail.namaLatin,
      suratNomor: detail.nomor,
    );
  }

  void _showCatatanSheet(BuildContext context, Ayat ayat) {
    final existing = ProviderScope.containerOf(context)
        .read(catatanAyatViewModelProvider.notifier)
        .getCatatan(
          suratNomor: detail.nomor,
          ayatNomor: ayat.nomorAyat,
        );
    unawaited(
      showAppBottomSheet<void>(
        context,
        builder: (_) => CatatanEditorSheet(
          suratNomor: detail.nomor,
          ayatNomor: ayat.nomorAyat,
          namaLatin: detail.namaLatin,
          teksArab: ayat.teksArab,
          existing: existing,
        ),
      ),
    );
  }
}
