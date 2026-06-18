import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:equran_app/features/surat_list/domain/entities/surat.dart';
import 'package:flutter/material.dart';

class SuratInfoHeader extends StatelessWidget {
  const SuratInfoHeader({
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
      margin: const EdgeInsets.fromLTRB(
        AppDimens.pagePadding,
        AppDimens.spaceMD,
        AppDimens.pagePadding,
        AppDimens.spaceSM,
      ),
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
            color: AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
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
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.onPrimary.withValues(alpha: 0.05),
              ),
            ),
          ),
          Positioned(
            right: 30,
            top: -30,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.onPrimary.withValues(alpha: 0.04),
              ),
            ),
          ),
          // Gold ornament line kiri
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 3,
              decoration: BoxDecoration(
                color: AppColors.gold.withValues(alpha: 0.6),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppDimens.radiusXL),
                  bottomLeft: Radius.circular(AppDimens.radiusXL),
                ),
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(AppDimens.spaceLG),
            child: Column(
              children: [
                // Nama Arab — besar, centered
                Text(
                  surat.nama,
                  style: AppTypography.arabicLarge.copyWith(
                    color: AppColors.onPrimary,
                    fontSize: 40,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppDimens.spaceSM),

                // Gold divider
                Container(
                  width: 40,
                  height: 1.5,
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                  ),
                ),

                const SizedBox(height: AppDimens.spaceSM),

                // Nama Latin — serif
                Text(
                  surat.namaLatin,
                  style: AppTypography.serifHeadingLarge.copyWith(
                    color: AppColors.onPrimary,
                    fontSize: 22,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppDimens.spaceXS),

                // Arti
                Text(
                  surat.arti,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.onPrimary.withValues(alpha: 0.8),
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppDimens.spaceMD),

                // Info chips row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _InfoChip(
                      label: surat.tempatTurun == TempatTurun.mekah
                          ? 'Mekah'
                          : 'Madinah',
                      icon: Icons.location_on_outlined,
                    ),
                    const SizedBox(width: AppDimens.spaceSM),
                    _InfoChip(
                      label: '${surat.jumlahAyat} Ayat',
                      icon: Icons.format_list_numbered_rounded,
                    ),
                    const SizedBox(width: AppDimens.spaceSM),
                    _InfoChip(
                      label: 'Surat ${surat.nomor}',
                      icon: Icons.tag_rounded,
                    ),
                  ],
                ),

                // Deskripsi collapsible
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
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.onPrimary.withValues(alpha: 0.75),
                      height: 1.7,
                    ),
                  ),
                ],
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
