import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/cubit/quran_font_cubit.dart';
import 'package:equran_app/core/widgets/bottom_sheet_handle.dart';
import 'package:equran_app/core/widgets/luxury_divider.dart';
import 'package:equran_app/features/tasbih/constants/tasbih_constants.dart';
import 'package:equran_app/features/tasbih/domain/entities/tasbih_preset.dart';
import 'package:equran_app/features/tasbih/presentation/cubit/tasbih_cubit.dart';
import 'package:equran_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Bottom sheet untuk memilih preset dzikir dan set target custom.
class PresetSelectorSheet extends StatefulWidget {
  const PresetSelectorSheet({super.key});

  @override
  State<PresetSelectorSheet> createState() => _PresetSelectorSheetState();
}

class _PresetSelectorSheetState extends State<PresetSelectorSheet> {
  final _targetController = TextEditingController();

  @override
  void dispose() {
    _targetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasbihCubit, TasbihState>(
      builder: (context, state) {
        final l10n = AppLocalizations.of(context)!;
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppDimens.spaceMD),
                child: BottomSheetHandle(),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.spaceMD,
                ),
                child: Text(
                  l10n.tasbihSelectDzikir,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),

              const SizedBox(height: AppDimens.spaceSM),

              ...TasbihPreset.defaults.map((preset) {
                final isSelected = state.selectedPreset.id == preset.id;
                return InkWell(
                  onTap: () {
                    context.read<TasbihCubit>().selectPreset(preset);
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.spaceMD,
                      vertical: AppDimens.spaceSM + 2,
                    ),
                    child: Row(
                      children: [
                        // Count badge
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : context.primaryContainerColor,
                            borderRadius: BorderRadius.circular(
                              AppDimens.radiusSM,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${preset.defaultTarget}',
                            style: TextStyle(
                              fontSize: TasbihConstants.presetCountBadgeSize,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? Colors.white
                                  : context.primaryActionColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppDimens.spaceMD),
                        // Name + arabic
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                preset.name,
                                style: TextStyle(
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  fontSize: TasbihConstants.presetNameSize,
                                  color: isSelected
                                      ? context.primaryActionColor
                                      : context.textPrimaryColor,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                preset.arabic,
                                style: TextStyle(
                                  fontFamily: kFontAmiri,
                                  fontSize: TasbihConstants.presetArabicSize,
                                  color: context.textSecondaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Checkmark
                        if (isSelected)
                          Icon(
                            Icons.check_circle_rounded,
                            color: context.primaryActionColor,
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                );
              }),

              const LuxuryDivider(),

              // Custom target
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.spaceMD,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _targetController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: l10n.tasbihCustomTarget,
                          hintText: l10n.tasbihCustomTargetHint,
                          prefixIcon: const Icon(Icons.tune_rounded),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppDimens.spaceSM),
                    SizedBox(
                      height: 48,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimens.radiusMD,
                            ),
                          ),
                        ),
                        onPressed: () {
                          final val = int.tryParse(_targetController.text);
                          if (val != null && val > 0) {
                            context.read<TasbihCubit>().setTarget(val);
                            Navigator.pop(context);
                          }
                        },
                        child: Text(l10n.tasbihSetButton),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppDimens.spaceLG),
            ],
          ),
        );
      },
    );
  }
}
