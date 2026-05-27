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
import 'package:equran_app/features/hafalan/presentation/widgets/hafalan_section_header.dart';
import 'package:equran_app/features/hafalan/presentation/widgets/hafalan_status_selector.dart';
import 'package:equran_app/features/surat_list/domain/entities/surat.dart';
import 'package:equran_app/features/surat_list/presentation/cubit/surat_list_cubit.dart';
import 'package:equran_app/injection/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HafalanDetailPage extends StatelessWidget {
  const HafalanDetailPage({required this.suratNomor, super.key});

  final int suratNomor;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // HafalanCubit adalah @lazySingleton — pakai .value agar tidak di-close
        BlocProvider.value(
          value: () {
            final cubit = getIt<HafalanCubit>();
            unawaited(cubit.load());
            return cubit;
          }(),
        ),
        BlocProvider(
          create: (_) {
            final cubit = getIt<SuratListCubit>();
            unawaited(cubit.load());
            return cubit;
          },
        ),
      ],
      child: _HafalanDetailView(suratNomor: suratNomor),
    );
  }
}

class _HafalanDetailView extends StatelessWidget {
  const _HafalanDetailView({required this.suratNomor});

  final int suratNomor;

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

            return _HafalanDetailScaffold(surat: surat, hafalan: hafalan);
          },
        );
      },
    );
  }
}

class _HafalanDetailScaffold extends StatelessWidget {
  const _HafalanDetailScaffold({
    required this.surat,
    required this.hafalan,
  });

  final Surat surat;
  final HafalanSurat? hafalan;

  @override
  Widget build(BuildContext context) {
    final ayatHafal = hafalan?.ayatHafal ?? [];
    final progress = surat.jumlahAyat > 0
        ? ayatHafal.length / surat.jumlahAyat
        : 0.0;
    final persen = (progress * 100).toStringAsFixed(0);
    final status = hafalan?.status ?? HafalanStatus.belum;

    return Scaffold(
      appBar: LuxuryAppBar(
        title: surat.namaLatin,
        titleFontSize: 18,
        actions: [
          if (hafalan != null)
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
              surat: surat,
              ayatHafalCount: ayatHafal.length,
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
                suratNomor: surat.nomor,
                currentStatus: status,
              ),
            ),

            const HafalanSectionHeader(
              title: 'Ayat',
              icon: Icons.grid_view_rounded,
            ),
            HafalanAyatGrid(
              jumlahAyat: surat.jumlahAyat,
              ayatHafal: ayatHafal,
              onToggle: (ayatNomor) {
                final suratAsHafalan = HafalanSurat(
                  suratNomor: surat.nomor,
                  namaLatin: surat.namaLatin,
                  nama: surat.nama,
                  jumlahAyat: surat.jumlahAyat,
                );
                unawaited(
                  context.read<HafalanCubit>().toggleAyat(
                    suratNomor: surat.nomor,
                    ayatNomor: ayatNomor,
                    suratInfo: suratAsHafalan,
                  ),
                );
              },
            ),

            if (hafalan != null && hafalan!.isSelesai) ...[
              const HafalanSectionHeader(
                title: "Muraja'ah",
                icon: Icons.refresh_rounded,
              ),
              HafalanMurajaahSection(hafalan: hafalan!),
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
                onTap: () =>
                    context.push(AppRoutes.hafalanSetoranSurat(surat.nomor)),
              ),
            ),

            const HafalanSectionHeader(
              title: 'Catatan',
              icon: Icons.edit_note_rounded,
            ),
            HafalanCatatanField(
              suratNomor: surat.nomor,
              initialValue: hafalan?.catatan,
              suratInfo: HafalanSurat(
                suratNomor: surat.nomor,
                namaLatin: surat.namaLatin,
                nama: surat.nama,
                jumlahAyat: surat.jumlahAyat,
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
          'Semua data hafalan ${surat.namaLatin} akan dihapus. '
          'Tindakan ini tidak bisa dibatalkan.',
    );
    if (confirmed && context.mounted) {
      await context.read<HafalanCubit>().deleteSurat(surat.nomor);
      if (context.mounted) context.pop();
    }
  }
}
