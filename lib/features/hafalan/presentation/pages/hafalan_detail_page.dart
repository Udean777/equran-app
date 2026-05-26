import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/core/widgets/empty_state_widget.dart';
import 'package:equran_app/core/widgets/loading_widget.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;
    final iconColor = isDark ? AppColors.onSurfaceDark : AppColors.textPrimary;

    final ayatHafal = hafalan?.ayatHafal ?? [];
    final progress = surat.jumlahAyat > 0
        ? ayatHafal.length / surat.jumlahAyat
        : 0.0;
    final persen = (progress * 100).toStringAsFixed(0);
    final status = hafalan?.status ?? HafalanStatus.belum;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.background,
      appBar: AppBar(
        backgroundColor: surfaceColor,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: AppDimens.appBarHeightLG,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: iconColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              surat.namaLatin,
              style: AppTypography.serifHeadingMedium.copyWith(
                color: iconColor,
                height: 1,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 3),
            Container(
              width: 20,
              height: 1.5,
              decoration: BoxDecoration(
                color: AppColors.gold,
                borderRadius: BorderRadius.circular(AppDimens.radiusFull),
              ),
            ),
          ],
        ),
        centerTitle: true,
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
              child: _SetoranButton(suratNomor: surat.nomor, isDark: isDark),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor:
            isDark ? AppColors.surfaceDark : AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusXL),
          side: BorderSide(
            color: isDark ? AppColors.outlineDark : AppColors.outline,
          ),
        ),
        title: Text(
          'Hapus Data Hafalan?',
          style: AppTypography.serifHeadingSmall.copyWith(
            color: isDark ? AppColors.onSurfaceDark : AppColors.textPrimary,
          ),
        ),
        content: Text(
          'Semua data hafalan ${surat.namaLatin} akan dihapus. '
          'Tindakan ini tidak bisa dibatalkan.',
          style: TextStyle(
            color: isDark
                ? AppColors.onSurfaceDarkVariant
                : AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Batal',
              style: TextStyle(
                color: isDark
                    ? AppColors.onSurfaceDarkVariant
                    : AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if ((confirmed ?? false) && context.mounted) {
      await context.read<HafalanCubit>().deleteSurat(surat.nomor);
      if (context.mounted) context.pop();
    }
  }
}

class _SetoranButton extends StatelessWidget {
  const _SetoranButton({required this.suratNomor, required this.isDark});

  final int suratNomor;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [AppColors.primaryDark, AppColors.primary]
              : [AppColors.primary, AppColors.primaryLight],
        ),
        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push('/hafalan/$suratNomor/setoran'),
          borderRadius: BorderRadius.circular(AppDimens.radiusLG),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppDimens.spaceMD,
              horizontal: AppDimens.spaceLG,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.play_arrow_rounded,
                  color: AppColors.onPrimary,
                  size: AppDimens.iconMD,
                ),
                const SizedBox(width: AppDimens.spaceSM),
                Text(
                  'Mulai Setoran',
                  style: AppTypography.serifHeadingSmall.copyWith(
                    color: AppColors.onPrimary,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
