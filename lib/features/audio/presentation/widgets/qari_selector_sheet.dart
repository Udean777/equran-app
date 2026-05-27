import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/widgets/bottom_sheet_handle.dart';
import 'package:equran_app/features/audio/domain/entities/audio_state_entity.dart';
import 'package:flutter/material.dart';

class QariSelectorSheet extends StatelessWidget {
  const QariSelectorSheet({
    required this.selectedQari,
    required this.audioMap,
    required this.onQariSelected,
    super.key,
  });

  final Qari selectedQari;
  final Map<String, String> audioMap;
  final ValueChanged<Qari> onQariSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    // Hanya tampilkan qari yang URL-nya tersedia di audioMap
    final availableQaris = Qari.values
        .where((q) => audioMap.containsKey(q.id))
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceMD),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          const BottomSheetHandle(),
          const SizedBox(height: AppDimens.spaceMD),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMD),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Pilih Qari',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.primaryLighter : AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppDimens.spaceSM),
          ...availableQaris.map(
            (qari) {
              final isSelected = qari == selectedQari;
              return InkWell(
                onTap: () => onQariSelected(qari),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.spaceMD,
                    vertical: AppDimens.spaceMD,
                  ),
                  child: Row(
                    children: [
                      // Avatar with initials
                      Container(
                        width: 40,
                        height: 40,
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
                          qari.id.toUpperCase(),
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : (isDark
                                      ? AppColors.primaryLighter
                                      : AppColors.primary),
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppDimens.spaceMD),
                      // Name
                      Expanded(
                        child: Text(
                          qari.name,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: isSelected
                                ? (isDark
                                      ? AppColors.primaryLighter
                                      : AppColors.primary)
                                : (isDark
                                      ? AppColors.onSurfaceDark
                                      : AppColors.textPrimary),
                          ),
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
            },
          ),
          const SizedBox(height: AppDimens.spaceMD),
        ],
      ),
    );
  }
}
