import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/surat_list/domain/entities/surat.dart';
import 'package:equran_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class SuratCard extends StatelessWidget {
  const SuratCard({
    required this.surat,
    required this.onTap,
    super.key,
  });

  final Surat surat;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceMD,
        vertical: AppDimens.spaceXS,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.radiusMD),
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.cardPadding),
          child: Row(
            children: [
              _AyatNumberBadge(nomor: surat.nomor),
              const SizedBox(width: AppDimens.spaceMD),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      surat.namaLatin,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: AppDimens.spaceXS),
                    Row(
                      children: [
                        Text(
                          l10n.ayatCount(surat.jumlahAyat),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: AppDimens.spaceSM),
                        _TempatTurunBadge(
                          tempatTurun: surat.tempatTurun,
                          l10n: l10n,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                surat.nama,
                style: const TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 20,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
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
      width: 36,
      height: 36,
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

class _TempatTurunBadge extends StatelessWidget {
  const _TempatTurunBadge({
    required this.tempatTurun,
    required this.l10n,
  });

  final TempatTurun tempatTurun;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final isMekah = tempatTurun == TempatTurun.mekah;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceSM,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: isMekah ? AppColors.mekahBadge : AppColors.madinahBadge,
        borderRadius: BorderRadius.circular(AppDimens.radiusFull),
      ),
      child: Text(
        isMekah ? l10n.mekah : l10n.madinah,
        style: TextStyle(
          color: isMekah
              ? AppColors.mekahBadgeText
              : AppColors.madinahBadgeText,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
