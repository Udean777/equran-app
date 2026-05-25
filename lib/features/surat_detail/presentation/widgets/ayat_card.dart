import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:flutter/material.dart';

class AyatCard extends StatelessWidget {
  const AyatCard({
    required this.ayat,
    super.key,
  });

  final Ayat ayat;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceMD,
        vertical: AppDimens.spaceXS,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Nomor ayat
            Row(
              children: [
                _AyatNumberBadge(nomor: ayat.nomorAyat),
                const Spacer(),
              ],
            ),
            const SizedBox(height: AppDimens.spaceMD),
            // Teks Arab
            Text(
              ayat.teksArab,
              textAlign: TextAlign.right,
              style: AppTypography.arabicLarge.copyWith(
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppDimens.spaceMD),
            const Divider(),
            const SizedBox(height: AppDimens.spaceSM),
            // Teks Latin
            Text(
              ayat.teksLatin,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
                color: Colors.grey[600],
                height: 1.6,
              ),
            ),
            const SizedBox(height: AppDimens.spaceSM),
            // Teks Indonesia
            Text(
              ayat.teksIndonesia,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AyatNumberBadge extends StatelessWidget {
  const _AyatNumberBadge({required this.nomor});

  final int nomor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: const BoxDecoration(
        color: AppColors.ayatNumberBg,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        nomor.toString(),
        style: const TextStyle(
          color: AppColors.ayatNumberText,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
