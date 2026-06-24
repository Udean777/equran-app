import 'package:equran_app/core/constants/juz_constants.dart';
import 'package:equran_app/core/router/app_routes.dart';
import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/hafalan/domain/entities/hafalan_surat.dart';
import 'package:equran_app/features/hafalan/presentation/widgets/hafalan_status_badge.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HafalanSuratCard extends StatelessWidget {
  const HafalanSuratCard({
    required this.hafalan,
    this.juzNomor,
    super.key,
  });

  final HafalanSurat hafalan;
  final int? juzNomor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Cari range ayat untuk surat ini di juz yang aktif jika ada
    final range = juzNomor != null
        ? JuzConstants.verseRanges['$juzNomor:${hafalan.suratNomor}']
        : null;

    final startAyat = range?.$1 ?? 1;
    final endAyat = range?.$2 ?? hafalan.jumlahAyat;
    final totalAyatInRange = endAyat - startAyat + 1;

    // Filter ayat yang dihafal hanya yang berada di range juz aktif
    final ayatHafalInRange = hafalan.ayatHafal
        .where((a) => a >= startAyat && a <= endAyat)
        .toList();

    final progress = totalAyatInRange > 0
        ? ayatHafalInRange.length / totalAyatInRange
        : 0.0;
    final persen = (progress * 100).toStringAsFixed(0);
    final displayedStatus = _juzStatus(progress, hafalan.status);

    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () => context.push(
          AppRoutes.hafalanSurat(hafalan.suratNomor, juzNomor: juzNomor),
        ),
        borderRadius: BorderRadius.circular(AppDimens.radiusMD),
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  // Nomor surat
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${hafalan.suratNomor}',
                      style: const TextStyle(
                        color: AppColors.onPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimens.spaceMD),

                  // Nama surat
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hafalan.namaLatin,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${ayatHafalInRange.length}/$totalAyatInRange ayat · $persen%',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Status badge + arrow
                  HafalanStatusBadge(status: displayedStatus),
                  const SizedBox(width: AppDimens.spaceXS),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.grey[400],
                    size: AppDimens.iconMD,
                  ),
                ],
              ),

              // Progress bar — hanya tampil jika sudah ada progress
              if (ayatHafalInRange.isNotEmpty) ...[
                const SizedBox(height: AppDimens.spaceSM),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 4,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _progressColor(displayedStatus),
                    ),
                  ),
                ),
              ],

              // Muraja'ah jatuh tempo — warning kecil
              if (displayedStatus == HafalanStatus.perluMurajaah &&
                  hafalan.tanggalMurajaahBerikutnya != null) ...[
                const SizedBox(height: AppDimens.spaceXS),
                Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      size: 12,
                      color: AppColors.error,
                    ),
                    const SizedBox(width: AppDimens.spaceXS),
                    Text(
                      'Murajaah sudah jatuh tempo',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.error,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  HafalanStatus _juzStatus(double progress, HafalanStatus overallStatus) {
    if (progress == 0.0) return HafalanStatus.belum;
    if (progress == 1.0) {
      return overallStatus == HafalanStatus.perluMurajaah
          ? HafalanStatus.perluMurajaah
          : HafalanStatus.sudahHafal;
    }
    return HafalanStatus.sedangDihafal;
  }

  Color _progressColor(HafalanStatus status) {
    switch (status) {
      case HafalanStatus.sudahHafal:
        return AppColors.success;
      case HafalanStatus.perluMurajaah:
        return AppColors.error;
      case HafalanStatus.sedangDihafal:
        return AppColors.warning;
      case HafalanStatus.belum:
        return Colors.grey;
    }
  }
}
