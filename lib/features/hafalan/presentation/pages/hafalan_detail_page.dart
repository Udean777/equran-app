import 'dart:async';

import 'package:equran_app/core/domain/entities/surat.dart';
import 'package:equran_app/core/router/app_routes.dart';
import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/utils/dialog_utils.dart';
import 'package:equran_app/core/widgets/empty_state_widget.dart';
import 'package:equran_app/core/widgets/gradient_button.dart';
import 'package:equran_app/core/widgets/loading_widget.dart';
import 'package:equran_app/core/widgets/luxury_app_bar.dart';
import 'package:equran_app/features/hafalan/domain/entities/hafalan_surat.dart';
import 'package:equran_app/features/hafalan/domain/services/hafalan_view_helper.dart';
import 'package:equran_app/features/hafalan/presentation/providers.dart';
import 'package:equran_app/features/hafalan/presentation/viewmodels/hafalan_detail_viewmodel.dart';
import 'package:equran_app/features/hafalan/presentation/viewmodels/hafalan_list_viewmodel.dart';
import 'package:equran_app/features/hafalan/presentation/widgets/hafalan_ayat_grid.dart';
import 'package:equran_app/features/hafalan/presentation/widgets/hafalan_catatan_field.dart';
import 'package:equran_app/features/hafalan/presentation/widgets/hafalan_murajaah_section.dart';
import 'package:equran_app/features/hafalan/presentation/widgets/hafalan_progress_header.dart';
import 'package:equran_app/features/hafalan/presentation/widgets/hafalan_section_header.dart';
import 'package:equran_app/features/hafalan/presentation/widgets/hafalan_status_selector.dart';
import 'package:equran_app/features/surat_list/presentation/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HafalanDetailPage extends ConsumerWidget {
  const HafalanDetailPage({
    required this.suratNomor,
    this.juzNomor,
    super.key,
  });

  final int suratNomor;
  final int? juzNomor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suratState = ref.watch(suratListViewModelProvider);
    final detailState = ref.watch(hafalanDetailViewModelProvider(suratNomor));
    final detailNotifier = ref.read(
      hafalanDetailViewModelProvider(suratNomor).notifier,
    );

    if (suratState is! SuratListSuccess) {
      return const Scaffold(body: LoadingWidget());
    }

    final suratMatches = suratState.surats.where(
      (s) => s.nomor == suratNomor,
    );
    if (suratMatches.isEmpty) {
      return const Scaffold(
        body: EmptyStateWidget(message: 'Surat tidak ditemukan.'),
      );
    }
    final surat = suratMatches.first;

    final hafalan = detailState is HafalanDetailSuccess
        ? detailState.hafalan
        : null;

    final listNotifier = ref.read(hafalanListViewModelProvider.notifier);

    return _HafalanDetailScaffold(
      surat: surat,
      hafalan: hafalan,
      juzNomor: juzNomor,
      detailNotifier: detailNotifier,
      listNotifier: listNotifier,
      suratNomor: suratNomor,
    );
  }
}

class _HafalanDetailScaffold extends StatefulWidget {
  const _HafalanDetailScaffold({
    required this.surat,
    required this.hafalan,
    required this.detailNotifier,
    required this.listNotifier,
    required this.suratNomor,
    this.juzNomor,
  });

  final Surat surat;
  final HafalanSurat? hafalan;
  final int? juzNomor;
  final HafalanDetailViewModel detailNotifier;
  final HafalanListViewModel listNotifier;
  final int suratNomor;

  @override
  State<_HafalanDetailScaffold> createState() => _HafalanDetailScaffoldState();
}

class _HafalanDetailScaffoldState extends State<_HafalanDetailScaffold> {
  int _maxItemsToShow = 10;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final ayatHafal = widget.hafalan?.ayatHafal ?? [];

    final range = HafalanViewHelper.getAyatRange(
      suratNomor: widget.surat.nomor,
      jumlahAyat: widget.surat.jumlahAyat,
      juzNomor: widget.juzNomor,
    );
    final startAyat = range.start;
    final endAyat = range.end;
    final totalAyatInRange = range.total;

    final ayatHafalInRange = ayatHafal
        .where((a) => a >= startAyat && a <= endAyat)
        .toList();

    final progress = totalAyatInRange > 0
        ? ayatHafalInRange.length / totalAyatInRange
        : 0.0;
    final persen = (progress * 100).toStringAsFixed(0);
    final status = widget.hafalan?.status ?? HafalanStatus.belum;

    final visibleCount = _maxItemsToShow < totalAyatInRange
        ? _maxItemsToShow
        : totalAyatInRange;

    return Scaffold(
      appBar: LuxuryAppBar(
        title: widget.juzNomor != null
            ? '${widget.surat.namaLatin} (Juz ${widget.juzNomor})'
            : widget.surat.namaLatin,
        titleFontSize: 18,
        actions: [
          if (widget.hafalan != null)
            IconButton(
              icon: Icon(
                Icons.delete_outline_rounded,
                color: AppColors.error.withValues(alpha: 0.8),
              ),
              tooltip: 'Hapus data hafalan',
              onPressed: () => _confirmDelete(context),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HafalanProgressHeader(
              surat: widget.surat,
              ayatHafalCount: ayatHafalInRange.length,
              progress: progress,
              persen: persen,
              status: status,
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimens.pagePadding,
                AppDimens.spaceXS,
                AppDimens.pagePadding,
                AppDimens.spaceMD,
              ),
              child: HafalanStatusSelector(
                suratNomor: widget.surat.nomor,
                currentStatus: status,
                detailNotifier: widget.detailNotifier,
              ),
            ),

            const HafalanSectionHeader(
              title: 'Ayat',
              icon: Icons.grid_view_rounded,
            ),
            HafalanAyatGrid(
              jumlahAyat: visibleCount,
              ayatHafal: ayatHafal,
              startAyat: startAyat,
              onToggle: (ayatNomor) {
                unawaited(
                  widget.detailNotifier.toggleAyat(
                    suratNomor: widget.surat.nomor,
                    ayatNomor: ayatNomor,
                    suratInfo: HafalanSurat.fromSurat(widget.surat),
                  ),
                );
              },
            ),

            if (_maxItemsToShow < totalAyatInRange)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.pagePadding,
                ),
                child: OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _maxItemsToShow += 10;
                    });
                  },
                  icon: const Icon(Icons.add_rounded),
                  label: Text(
                    'Tampilkan 10 Ayat Lagi (${totalAyatInRange - _maxItemsToShow} Tersisa)',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isDark
                        ? AppColors.primaryLighter
                        : AppColors.primary,
                    side: BorderSide(
                      color: isDark
                          ? AppColors.outlineDark
                          : AppColors.primary.withValues(alpha: 0.2),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimens.radiusMD),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: AppDimens.spaceMD,
                    ),
                  ),
                ),
              ),

            if (widget.hafalan != null && widget.hafalan!.isSelesai) ...[
              const HafalanSectionHeader(
                title: "Muraja'ah",
                icon: Icons.refresh_rounded,
              ),
              HafalanMurajaahSection(
                hafalan: widget.hafalan!,
                detailNotifier: widget.detailNotifier,
              ),
            ],

            const HafalanSectionHeader(
              title: 'Mode Setoran',
              icon: Icons.record_voice_over_rounded,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimens.pagePadding,
                AppDimens.spaceXS,
                AppDimens.pagePadding,
                AppDimens.spaceMD,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GradientButton(
                    label: 'Mulai Setoran',
                    icon: Icons.play_arrow_rounded,
                    onTap: () => context.push(
                      AppRoutes.hafalanSetoranSurat(
                        widget.surat.nomor,
                        juzNomor: widget.juzNomor,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimens.spaceMD),
                  OutlinedButton.icon(
                    onPressed: () {
                      unawaited(
                        context.push(
                          AppRoutes.hafalanRiwayatSurat(
                            widget.surat.nomor,
                            juzNomor: widget.juzNomor,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.history_rounded, size: 20),
                    label: const Text('Riwayat Rekaman Setoran'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppDimens.spaceMD,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const HafalanSectionHeader(
              title: 'Catatan',
              icon: Icons.edit_note_rounded,
            ),
            HafalanCatatanField(
              suratNomor: widget.surat.nomor,
              initialValue: widget.hafalan?.catatan,
              suratInfo: HafalanSurat.fromSurat(widget.surat),
              listNotifier: widget.listNotifier,
              detailNotifier: widget.detailNotifier,
            ),

            const SizedBox(height: AppDimens.spaceXL),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Hapus Data Hafalan?',
      content:
          'Semua data hafalan ${widget.surat.namaLatin} akan dihapus. '
          'Tindakan ini tidak bisa dibatalkan.',
    );
    if (confirmed && context.mounted) {
      await widget.detailNotifier.deleteSurat(widget.surat.nomor);
      if (context.mounted) context.pop();
    }
  }
}
