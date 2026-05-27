import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/widgets/bottom_sheet_handle.dart';
import 'package:equran_app/core/widgets/luxury_divider.dart';
import 'package:equran_app/features/tasbih/domain/entities/tasbih_preset.dart';
import 'package:equran_app/features/tasbih/presentation/cubit/tasbih_cubit.dart';
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
                  'Pilih Dzikir',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),

              const SizedBox(height: AppDimens.spaceSM),

              ...TasbihPreset.defaults.map((preset) {
                final isSelected = state.selectedPreset.id == preset.id;
                final isDark = Theme.of(context).brightness == Brightness.dark;
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
                                : (isDark
                                      ? AppColors.primaryDark
                                      : AppColors.primaryContainer),
                            borderRadius: BorderRadius.circular(
                              AppDimens.radiusSM,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${preset.defaultTarget}',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? Colors.white
                                  : (isDark
                                        ? AppColors.primaryLighter
                                        : AppColors.primary),
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
                                  fontSize: 14,
                                  color: isSelected
                                      ? (isDark
                                            ? AppColors.primaryLighter
                                            : AppColors.primary)
                                      : (isDark
                                            ? AppColors.onSurfaceDark
                                            : AppColors.textPrimary),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                preset.arabic,
                                style: TextStyle(
                                  fontFamily: 'Amiri',
                                  fontSize: 15,
                                  color: isDark
                                      ? AppColors.onSurfaceDarkVariant
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Checkmark
                        if (isSelected)
                          Icon(
                            Icons.check_circle_rounded,
                            color: isDark
                                ? AppColors.primaryLighter
                                : AppColors.primary,
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
                        decoration: const InputDecoration(
                          labelText: 'Target custom',
                          hintText: 'Contoh: 200',
                          prefixIcon: Icon(Icons.tune_rounded),
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
                        child: const Text('Set'),
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
