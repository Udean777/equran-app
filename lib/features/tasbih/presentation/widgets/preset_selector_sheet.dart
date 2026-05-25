import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
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
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: AppDimens.spaceMD),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                ),
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

              // Preset list
              ...TasbihPreset.defaults.map((preset) {
                final isSelected =
                    state.selectedPreset.id == preset.id;
                return ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.primary.withValues(alpha: 0.08),
                    ),
                    child: Center(
                      child: Text(
                        '${preset.defaultTarget}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? AppColors.onPrimary
                              : AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    preset.name,
                    style: TextStyle(
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: isSelected ? AppColors.primary : null,
                    ),
                  ),
                  subtitle: Text(
                    preset.arabic,
                    style: const TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 16,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(
                          Icons.check_rounded,
                          color: AppColors.primary,
                        )
                      : null,
                  onTap: () {
                    context.read<TasbihCubit>().selectPreset(preset);
                    Navigator.pop(context);
                  },
                );
              }),

              const Divider(height: AppDimens.spaceLG),

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
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
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
