import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/core/theme/providers.dart';
import 'package:equran_app/core/utils/bottom_sheet_utils.dart';
import 'package:equran_app/features/tasbih/presentation/constants/tasbih_constants.dart';
import 'package:equran_app/features/tasbih/presentation/viewmodels/tasbih_state.dart';
import 'package:equran_app/features/tasbih/presentation/widgets/info_chip.dart';
import 'package:equran_app/features/tasbih/presentation/widgets/preset_selector_sheet.dart';
import 'package:equran_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Section info dzikir: nama, teks Arab, dan chip target/sisa.
class DzikirInfoSection extends StatelessWidget {
  const DzikirInfoSection({required this.state, super.key});

  final TasbihState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final surfaceColor = context.surfaceColor;
    final borderColor = context.borderVariantColor;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(
        AppDimens.pagePadding,
        AppDimens.spaceMD,
        AppDimens.pagePadding,
        AppDimens.spaceXS,
      ),
      padding: const EdgeInsets.all(AppDimens.cardPaddingLG),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(AppDimens.radiusXL),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(
              alpha: context.isDark ? 0.04 : 0.06,
            ),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Gold ornamen atas
          Container(
            width: TasbihConstants.ornamentWidth,
            height: TasbihConstants.ornamentHeight,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppColors.goldDark,
                  AppColors.gold,
                  AppColors.goldDark,
                ],
              ),
              borderRadius: BorderRadius.circular(AppDimens.radiusFull),
            ),
          ),
          const SizedBox(height: AppDimens.spaceMD),

          // Nama dzikir — tap untuk ganti
          GestureDetector(
            onTap: () => _showPresetSheet(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  state.selectedPreset.name,
                  style: AppTypography.serifHeadingMedium.copyWith(
                    color: context.primaryActionColor,
                    fontSize: TasbihConstants.dzikirNameFontSize,
                  ),
                ),
                const SizedBox(width: AppDimens.spaceXS),
                Icon(
                  Icons.expand_more_rounded,
                  color: context.primaryActionColor,
                  size: 20,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppDimens.spaceSM),

          // Teks Arab
          Text(
            state.selectedPreset.arabic,
            style: TextStyle(
              fontFamily: kFontAmiri,
              fontSize: TasbihConstants.arabicTextFontSize,
              height: TasbihConstants.arabicTextLineHeight,
              color: context.textPrimaryColor,
            ),
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppDimens.spaceMD),

          // Gold divider
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.gold.withValues(alpha: 0),
                  AppColors.gold.withValues(alpha: 0.4),
                  AppColors.gold.withValues(alpha: 0),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppDimens.spaceMD),

          // Target + Sisa chips
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InfoChip(
                label: l10n.tasbihTarget,
                value: '${state.target}x',
              ),
              const SizedBox(width: AppDimens.spaceSM),
              InfoChip(
                label: l10n.tasbihRemaining,
                value: state.isCompleted ? '0' : '${state.remaining}x',
                highlight: state.isCompleted,
              ),
            ],
          ),

          const SizedBox(height: AppDimens.spaceXS),
        ],
      ),
    );
  }

  void _showPresetSheet(BuildContext context) {
    unawaited(
      showAppBottomSheet<void>(
        context,
        builder: (_) => const PresetSelectorSheet(),
      ),
    );
  }
}
