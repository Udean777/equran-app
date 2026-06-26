import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/widgets/luxury_divider.dart';
import 'package:equran_app/features/tafsir/domain/entities/tafsir_surat.dart';
import 'package:equran_app/features/tafsir/presentation/constants/tafsir_constants.dart';
import 'package:equran_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class TafsirAyatCard extends StatelessWidget {
  const TafsirAyatCard({
    required this.tafsirAyat,
    super.key,
  });

  final TafsirAyat tafsirAyat;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceMD,
        vertical: AppDimens.spaceXS,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nomor ayat badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.spaceSM,
              vertical: AppDimens.spaceXS,
            ),
            decoration: BoxDecoration(
              color: AppColors.ayatNumberBg,
              borderRadius: BorderRadius.circular(AppDimens.radiusFull),
            ),
            child: Text(
              l10n.ayatNumber(tafsirAyat.nomorAyat),
              style: const TextStyle(
                color: AppColors.ayatNumberText,
                fontSize: TafsirConstants.ayatBadgeFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: AppDimens.spaceSM),
          // Teks tafsir
          Text(
            tafsirAyat.teks,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: TafsirConstants.tafsirLineHeight,
            ),
          ),
          const SizedBox(height: AppDimens.spaceSM),
          const LuxuryDivider(),
        ],
      ),
    );
  }
}
