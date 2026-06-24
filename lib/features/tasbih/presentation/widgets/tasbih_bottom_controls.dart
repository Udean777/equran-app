import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/core/utils/bottom_sheet_utils.dart';
import 'package:equran_app/features/tasbih/constants/tasbih_constants.dart';
import 'package:equran_app/features/tasbih/presentation/cubit/tasbih_cubit.dart';
import 'package:equran_app/features/tasbih/presentation/widgets/preset_selector_sheet.dart';
import 'package:equran_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Tombol bawah TasbihPage: Ganti Dzikir + Reset.
class TasbihBottomControls extends StatelessWidget {
  const TasbihBottomControls({required this.state, super.key});

  final TasbihState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.pagePadding,
        AppDimens.spaceMD,
        AppDimens.pagePadding,
        AppDimens.spaceXL,
      ),
      child: Row(
        children: [
          // Ganti dzikir
          Expanded(
            child: OutlinedButton.icon(
              icon: Icon(
                Icons.swap_horiz_rounded,
                  color: context.primaryActionColor,
              ),
              label: Text(l10n.tasbihChangeDzikir),
              style: OutlinedButton.styleFrom(
                foregroundColor: context.primaryActionColor,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  inherit: false,
                  fontSize: TasbihConstants.buttonTextSize,
                  letterSpacing: 0.1,
                  height: 1.4,
                  decoration: TextDecoration.none,
                ),
                side: BorderSide(
                color: context.primaryActionColor,
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimens.spaceMD,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimens.radiusLG),
                ),
              ),
              onPressed: () => _showPresetSheet(context),
            ),
          ),

          const SizedBox(width: AppDimens.spaceMD),

          // Reset
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: state.isCompleted
                      ? [AppColors.goldDark, AppColors.gold]
                      : (context.isDark
                            ? [AppColors.primaryDark, AppColors.primary]
                            : [AppColors.primary, AppColors.primaryLight]),
                ),
                borderRadius: BorderRadius.circular(AppDimens.radiusLG),
                boxShadow: [
                  BoxShadow(
                    color:
                        (state.isCompleted ? AppColors.gold : AppColors.primary)
                            .withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => context.read<TasbihCubit>().reset(),
                  borderRadius: BorderRadius.circular(AppDimens.radiusLG),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppDimens.spaceMD,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.refresh_rounded,
                          color: AppColors.onPrimary,
                          size: 18,
                        ),
                        const SizedBox(width: AppDimens.spaceXS),
                        Text(
                          l10n.tasbihReset,
                          style: AppTypography.serifHeadingSmall.copyWith(
                            color: AppColors.onPrimary,
                            fontSize: TasbihConstants.buttonTextSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPresetSheet(BuildContext context) {
    unawaited(
      showAppBottomSheet<void>(
        context,
        builder: (_) => BlocProvider.value(
          value: context.read<TasbihCubit>(),
          child: const PresetSelectorSheet(),
        ),
      ),
    );
  }
}
