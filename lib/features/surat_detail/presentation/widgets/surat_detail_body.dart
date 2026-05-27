import 'dart:async';

import 'package:equran_app/core/utils/bottom_sheet_utils.dart';
import 'package:equran_app/features/audio/domain/entities/audio_state_entity.dart';
import 'package:equran_app/features/audio/presentation/cubit/audio_cubit.dart';
import 'package:equran_app/features/audio/presentation/cubit/audio_download_cubit.dart';
import 'package:equran_app/features/audio/presentation/widgets/audio_player_bar.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:equran_app/features/surat_detail/presentation/controllers/viewport_detection_controller.dart';
import 'package:equran_app/features/surat_detail/presentation/cubit/surat_detail_cubit.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/ayat_list_view.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/download_surat_sheet.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/surat_detail_app_bar.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/surat_info_header.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/surat_nav_button.dart';
import 'package:equran_app/features/tafsir/presentation/widgets/tafsir_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Body utama halaman surat detail — ditampilkan saat state sukses.
///
/// Menerima semua data dan callback dari _SuratDetailViewState (SRP):
/// - State management tetap di State class
/// - Widget ini hanya bertanggung jawab untuk render UI
class SuratDetailBody extends StatelessWidget {
  const SuratDetailBody({
    required this.detail,
    required this.scrollController,
    required this.viewportController,
    required this.autoScrollEnabled,
    required this.onToggleAutoScroll,
    required this.onSaveLastRead,
    required this.suratNomor,
    super.key,
  });

  final SuratDetail detail;
  final ScrollController scrollController;
  final ViewportDetectionController viewportController;
  final bool autoScrollEnabled;
  final VoidCallback onToggleAutoScroll;
  final void Function(SuratDetail, int) onSaveLastRead;
  final int suratNomor;

  @override
  Widget build(BuildContext context) {
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
        if (autoScrollEnabled &&
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
            autoScrollEnabled: autoScrollEnabled,
            onToggleAutoScroll: onToggleAutoScroll,
            onDownloadTap: () => _showDownloadSuratSheet(context, detail, qari),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _showTafsirBottomSheet(context, suratNomor),
            icon: const Icon(Icons.menu_book_rounded),
            label: const Text('Lihat Tafsir'),
          ),
          bottomNavigationBar: AudioPlayerBar(audioMap: detail.audioFull),
          body: RefreshIndicator(
            onRefresh: () async =>
                context.read<SuratDetailCubit>().load(suratNomor),
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: SuratInfoHeader(detail: detail),
                ),
                AyatListView(
                  detail: detail,
                  viewportController: viewportController,
                  onSaveLastRead: onSaveLastRead,
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

  void _scrollToAyat(int ayatNomor) {
    final key = viewportController.keys[ayatNomor];
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
