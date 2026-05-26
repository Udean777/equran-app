import 'package:equran_app/core/constants/juz_mapping.dart';
import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/hafalan/domain/entities/hafalan_surat.dart';
import 'package:equran_app/features/hafalan/presentation/widgets/hafalan_surat_card.dart';
import 'package:flutter/material.dart';

class HafalanJuzSection extends StatelessWidget {
  const HafalanJuzSection({
    required this.juzNomor,
    required this.hafalanList,
    required this.progressJuz,
    super.key,
  });

  final int juzNomor;
  final List<HafalanSurat> hafalanList;
  final double progressJuz;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final persen = (progressJuz * 100).toStringAsFixed(0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header juz
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDimens.spaceMD,
            AppDimens.spaceMD,
            AppDimens.spaceMD,
            AppDimens.spaceXS,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.spaceSM,
                  vertical: AppDimens.spaceXS,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppDimens.radiusSM),
                ),
                child: Text(
                  'Juz $juzNomor',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: AppDimens.spaceSM),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                  child: LinearProgressIndicator(
                    value: progressJuz,
                    minHeight: 4,
                    backgroundColor: Colors.grey[200],
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppDimens.spaceSM),
              Text(
                '$persen%',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        // List surat di juz ini
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMD),
          itemCount: hafalanList.length,
          separatorBuilder: (_, _) =>
              const SizedBox(height: AppDimens.spaceXS),
          itemBuilder: (context, index) =>
              HafalanSuratCard(hafalan: hafalanList[index]),
        ),
      ],
    );
  }
}

/// Helper: kelompokkan list hafalan per juz.
/// Surat yang belum ada di hafalanList tetap ditampilkan dengan status belum.
Map<int, List<HafalanSurat>> groupHafalanByJuz({
  required List<HafalanSurat> hafalanList,
  required List<HafalanSurat> allSuratAsHafalan,
}) {
  final map = <int, List<HafalanSurat>>{};

  for (final surat in allSuratAsHafalan) {
    final juz = kJuzMapping[surat.suratNomor] ?? 1;
    map.putIfAbsent(juz, () => []).add(surat);
  }

  return map;
}
