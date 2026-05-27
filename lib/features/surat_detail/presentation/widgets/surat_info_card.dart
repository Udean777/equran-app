import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:equran_app/features/surat_list/domain/entities/surat.dart';
import 'package:flutter/material.dart';

/// Card index 0 — info surat (nama arab, latin, arti, chips, deskripsi).
/// Ditampilkan sebagai card pertama di stack sebelum ayat-ayat.
class SuratInfoCard extends StatelessWidget {
  const SuratInfoCard({
    required this.detail,
    super.key,
  });

  final SuratDetail detail;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surat = detail.info;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [AppColors.primaryDark, AppColors.primary]
              : [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimens.radiusXL),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: isDark ? 0.25 : 0.35),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Ornamen circle kanan atas
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.onPrimary.withValues(alpha: 0.05),
              ),
            ),
          ),
          Positioned(
            right: 30,
            top: -35,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.onPrimary.withValues(alpha: 0.04),
              ),
            ),
          ),
          // Content
          SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimens.spaceLG),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Nama Arab
                Text(
                  surat.nama,
                  style: AppTypography.arabicLarge.copyWith(
                    color: AppColors.onPrimary,
                    fontSize: 48,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppDimens.spaceSM),

                // Gold divider
                Container(
                  width: 48,
                  height: 1.5,
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius:
                        BorderRadius.circular(AppDimens.radiusFull),
                  ),
                ),

                const SizedBox(height: AppDimens.spaceSM),

                // Nama Latin
                Text(
                  surat.namaLatin,
                  style: AppTypography.serifHeadingLarge.copyWith(
                    color: AppColors.onPrimary,
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppDimens.spaceXS),

                // Arti
                Text(
                  '"${surat.arti}"',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.onPrimary.withValues(alpha: 0.85),
                    fontStyle: FontStyle.italic,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppDimens.spaceMD),

                // Info chips
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: AppDimens.spaceSM,
                  runSpacing: AppDimens.spaceSM,
                  children: [
                    _InfoChip(
                      label: surat.tempatTurun == TempatTurun.mekah
                          ? 'Mekah'
                          : 'Madinah',
                      icon: Icons.location_on_outlined,
                    ),
                    _InfoChip(
                      label: '${surat.jumlahAyat} Ayat',
                      icon: Icons.format_list_numbered_rounded,
                    ),
                    _InfoChip(
                      label: 'Surat ke-${surat.nomor}',
                      icon: Icons.tag_rounded,
                    ),
                  ],
                ),

                // Deskripsi
                if (detail.deskripsi.isNotEmpty) ...[
                  const SizedBox(height: AppDimens.spaceMD),
                  Divider(
                    color: AppColors.onPrimary.withValues(alpha: 0.2),
                    thickness: 1,
                  ),
                  const SizedBox(height: AppDimens.spaceSM),
                  Text(
                    detail.deskripsi,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.onPrimary.withValues(alpha: 0.8),
                      height: 1.8,
                      fontSize: 12,
                    ),
                  ),
                ],

                const SizedBox(height: AppDimens.spaceMD),

                // Hint swipe
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.swipe_left_rounded,
                      color: AppColors.gold.withValues(alpha: 0.8),
                      size: 18,
                    ),
                    const SizedBox(width: AppDimens.spaceXS),
                    Text(
                      'Swipe untuk mulai membaca',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.onPrimary.withValues(alpha: 0.6),
                        fontSize: 11,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceSM + 2,
        vertical: AppDimens.spaceXS,
      ),
      decoration: BoxDecoration(
        color: AppColors.onPrimary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppDimens.radiusFull),
        border: Border.all(
          color: AppColors.gold.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: AppColors.gold),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.onPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
