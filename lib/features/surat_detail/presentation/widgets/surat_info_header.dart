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
    final surat = detail.info;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(AppDimens.spaceMD),
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
          // Nama Arab
          Text(
            surat.nama,
            style: AppTypography.arabicLarge.copyWith(
              color: AppColors.onPrimary,
              fontSize: 36,
            ),
          ),
          const SizedBox(height: AppDimens.spaceSM),
          // Nama Latin
          Text(
            surat.namaLatin,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: AppColors.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimens.spaceXS),
          // Arti
          Text(
            surat.arti,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.onPrimary.withValues(alpha: 0.85),
            ),
          ),
          const SizedBox(height: AppDimens.spaceMD),
          // Info row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _InfoChip(
                label: surat.tempatTurun == TempatTurun.mekah
                    ? 'Mekah'
                    : 'Madinah',
              ),
              const SizedBox(width: AppDimens.spaceSM),
              _InfoChip(label: '${surat.jumlahAyat} Ayat'),
              const SizedBox(width: AppDimens.spaceSM),
              _InfoChip(label: 'Surat ${surat.nomor}'),
            ],
          ),
          if (detail.deskripsi.isNotEmpty) ...[
            const SizedBox(height: AppDimens.spaceMD),
            const Divider(color: Colors.white24),
            const SizedBox(height: AppDimens.spaceSM),
            Text(
              detail.deskripsi,
              textAlign: TextAlign.center,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.onPrimary.withValues(alpha: 0.8),
                height: 1.6,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceSM,
        vertical: AppDimens.spaceXS,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppDimens.radiusFull),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.onPrimary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
