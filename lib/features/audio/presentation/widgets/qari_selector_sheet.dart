import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
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
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: AppDimens.spaceMD),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(AppDimens.radiusFull),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMD),
            child: Text(
              'Pilih Qari',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: AppDimens.spaceSM),
          ...availableQaris.map(
            (qari) => ListTile(
              leading: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: qari == selectedQari
                      ? AppColors.primary
                      : AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  qari.id,
                  style: TextStyle(
                    color: qari == selectedQari
                        ? AppColors.onPrimary
                        : AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              title: Text(
                qari.name,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: qari == selectedQari
                      ? FontWeight.w600
                      : FontWeight.normal,
                  color: qari == selectedQari ? AppColors.primary : null,
                ),
              ),
              trailing: qari == selectedQari
                  ? const Icon(
                      Icons.check_rounded,
                      color: AppColors.primary,
                    )
                  : null,
              onTap: () => onQariSelected(qari),
            ),
          ),
          const SizedBox(height: AppDimens.spaceMD),
        ],
      ),
    );
  }
}
