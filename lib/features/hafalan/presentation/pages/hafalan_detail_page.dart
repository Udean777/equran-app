import 'dart:async';

import 'package:equran_app/core/router/app_routes.dart';
import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/utils/dialog_utils.dart';
import 'package:equran_app/core/widgets/empty_state_widget.dart';
import 'package:equran_app/core/widgets/gradient_button.dart';
import 'package:equran_app/core/widgets/loading_widget.dart';
import 'package:equran_app/core/widgets/luxury_app_bar.dart';
import 'package:equran_app/features/hafalan/domain/entities/hafalan_surat.dart';
import 'package:equran_app/features/hafalan/presentation/cubit/hafalan_cubit.dart';
import 'package:equran_app/features/hafalan/presentation/widgets/hafalan_ayat_grid.dart';
import 'package:equran_app/features/hafalan/presentation/widgets/hafalan_catatan_field.dart';
import 'package:equran_app/features/hafalan/presentation/widgets/hafalan_murajaah_section.dart';
import 'package:equran_app/features/hafalan/presentation/widgets/hafalan_progress_header.dart';
import 'package:equran_app/features/hafalan/presentation/widgets/hafalan_providers.dart';
import 'package:equran_app/features/hafalan/presentation/widgets/hafalan_section_header.dart';
import 'package:equran_app/features/hafalan/presentation/widgets/hafalan_status_selector.dart';
import 'package:equran_app/features/surat_detail/constants/juz_mapping.dart';
import 'package:equran_app/features/surat_list/domain/entities/surat.dart';
import 'package:equran_app/features/surat_list/presentation/cubit/surat_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HafalanDetailPage extends StatelessWidget {
  const HafalanDetailPage({
    required this.suratNomor,
    this.juzNomor,
    super.key,
  });

  final int suratNomor;
  final int? juzNomor;

  @override
  Widget build(BuildContext context) {
    return HafalanProviders(
      child: _HafalanDetailView(suratNomor: suratNomor, juzNomor: juzNomor),
    );
  }
}

class _HafalanDetailView extends StatelessWidget {
  const _HafalanDetailView({
    required this.suratNomor,
    this.juzNomor,
  });

  final int suratNomor;
  final int? juzNomor;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SuratListCubit, SuratListState>(
      builder: (context, suratState) {
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

        return BlocBuilder<HafalanCubit, HafalanState>(
          builder: (context, hafalanState) {
            final hafalan = hafalanState is HafalanSuccess
                ? (hafalanState.hafalanList
                          .where((h) => h.suratNomor == suratNomor)
                          .isEmpty
                      ? null
                      : hafalanState.hafalanList.firstWhere(
                          (h) => h.suratNomor == suratNomor,
                        ))
                : null;

            return _HafalanDetailScaffold(
              surat: surat,
              hafalan: hafalan,
              juzNomor: juzNomor,
            );
          },
        );
      },
    );
  }
}

class _HafalanDetailScaffold extends StatefulWidget {
  const _HafalanDetailScaffold({
    required this.surat,
    required this.hafalan,
    this.juzNomor,
  });

  final Surat surat;
  final HafalanSurat? hafalan;
  final int? juzNomor;

  @override
  State<_HafalanDetailScaffold> createState() => _HafalanDetailScaffoldState();
}

class _HafalanDetailScaffoldState extends State<_HafalanDetailScaffold> {
  int _maxItemsToShow = 10;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final ayatHafal = widget.hafalan?.ayatHafal ?? [];

    // Cari range ayat untuk surat ini di juz yang aktif
    final range = widget.juzNomor != null
        ? kJuzSurahVerseRanges['${widget.juzNomor}:${widget.surat.nomor}']
        : null;

    final startAyat = range?.$1 ?? 1;
    final endAyat = range?.$2 ?? widget.surat.jumlahAyat;
    final totalAyatInRange = endAyat - startAyat + 1;

    // Filter ayat yang dihafal hanya yang berada di range juz aktif
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
                final suratAsHafalan = HafalanSurat(
                  suratNomor: widget.surat.nomor,
                  namaLatin: widget.surat.namaLatin,
                  nama: widget.surat.nama,
                  jumlahAyat: widget.surat.jumlahAyat,
                );
                unawaited(
                  context.read<HafalanCubit>().toggleAyat(
                    suratNomor: widget.surat.nomor,
                    ayatNomor: ayatNomor,
                    suratInfo: suratAsHafalan,
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
              HafalanMurajaahSection(hafalan: widget.hafalan!),
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
              child: GradientButton(
                label: 'Mulai Setoran',
                icon: Icons.play_arrow_rounded,
                onTap: () => context.push(
                  AppRoutes.hafalanSetoranSurat(
                    widget.surat.nomor,
                    juzNomor: widget.juzNomor,
                  ),
                ),
              ),
            ),

            const HafalanSectionHeader(
              title: 'Catatan',
              icon: Icons.edit_note_rounded,
            ),
            HafalanCatatanField(
              suratNomor: widget.surat.nomor,
              initialValue: widget.hafalan?.catatan,
              suratInfo: HafalanSurat(
                suratNomor: widget.surat.nomor,
                namaLatin: widget.surat.namaLatin,
                nama: widget.surat.nama,
                jumlahAyat: widget.surat.jumlahAyat,
              ),
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
      await context.read<HafalanCubit>().deleteSurat(widget.surat.nomor);
      if (context.mounted) context.pop();
    }
  }
}
