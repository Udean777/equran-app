import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:flutter/material.dart';

/// Layar hasil setoran hafalan — menampilkan summary dan detail per ayat.
class SetoranHasil extends StatelessWidget {
  const SetoranHasil({
    required this.detail,
    required this.hasil,
    required this.onSimpan,
    required this.onUlang,
    super.key,
  });

  final SuratDetail detail;
  final Map<int, bool> hasil;
  final VoidCallback onSimpan;
  final VoidCallback onUlang;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalAyat = detail.ayatList.length;
    final hafalCount = hasil.values.where((v) => v).length;
    final belumCount = totalAyat - hafalCount;
    final persen = totalAyat > 0
        ? (hafalCount / totalAyat * 100).toStringAsFixed(0)
        : '0';

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimens.spaceMD),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Summary card
                Container(
                  padding: const EdgeInsets.all(AppDimens.spaceLG),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, Color(0xFF2E7D32)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(AppDimens.radiusLG),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.auto_stories_rounded,
                        color: AppColors.onPrimary,
                        size: 48,
                      ),
                      const SizedBox(height: AppDimens.spaceSM),
                      Text(
                        'Setoran Selesai',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: AppColors.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        detail.info.namaLatin,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.onPrimary.withValues(alpha: 0.8),
                        ),
                      ),
                      const SizedBox(height: AppDimens.spaceMD),
                      Text(
                        '$hafalCount/$totalAyat ayat ($persen%)',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: AppColors.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppDimens.spaceSM),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                          AppDimens.radiusFull,
                        ),
                        child: LinearProgressIndicator(
                          value: totalAyat > 0 ? hafalCount / totalAyat : 0,
                          minHeight: 8,
                          backgroundColor: AppColors.onPrimary.withValues(
                            alpha: 0.2,
                          ),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppDimens.spaceMD),

                // Stat row
                Row(
                  children: [
                    _SetoranStatBox(
                      label: 'Hafal',
                      value: '$hafalCount',
                      color: AppColors.success,
                    ),
                    const SizedBox(width: AppDimens.spaceSM),
                    _SetoranStatBox(
                      label: 'Belum Hafal',
                      value: '$belumCount',
                      color: AppColors.error,
                    ),
                  ],
                ),

                const SizedBox(height: AppDimens.spaceMD),

                // Detail per ayat
                Text(
                  'Detail per Ayat',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppDimens.spaceSM),
                Wrap(
                  spacing: AppDimens.spaceXS,
                  runSpacing: AppDimens.spaceXS,
                  children: hasil.entries.map((e) {
                    final isHafal = e.value;
                    return Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isHafal
                            ? AppColors.success.withValues(alpha: 0.15)
                            : AppColors.error.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(
                          AppDimens.radiusSM,
                        ),
                        border: Border.all(
                          color: isHafal ? AppColors.success : AppColors.error,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${e.key}',
                        style: TextStyle(
                          color: isHafal ? AppColors.success : AppColors.error,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),

        // Tombol aksi
        Container(
          padding: const EdgeInsets.all(AppDimens.spaceMD),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FilledButton.icon(
                onPressed: onSimpan,
                icon: const Icon(Icons.save_rounded),
                label: const Text('Simpan Hasil'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    vertical: AppDimens.spaceMD,
                  ),
                ),
              ),
              const SizedBox(height: AppDimens.spaceSM),
              OutlinedButton.icon(
                onPressed: onUlang,
                icon: const Icon(Icons.replay_rounded),
                label: const Text('Ulang Setoran'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppDimens.spaceMD,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SetoranStatBox extends StatelessWidget {
  const _SetoranStatBox({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppDimens.spaceMD),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppDimens.radiusMD),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
