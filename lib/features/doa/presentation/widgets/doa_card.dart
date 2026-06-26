import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/doa/domain/entities/doa.dart';
import 'package:flutter/material.dart';

class DoaCard extends StatelessWidget {
  const DoaCard({
    required this.doa,
    required this.onTap,
    this.onRemove,
    super.key,
  });

  final Doa doa;
  final VoidCallback onTap;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;
    final borderColor = isDark
        ? AppColors.outlineDark
        : AppColors.outlineVariant;

    return Material(
      color: surfaceColor,
      borderRadius: BorderRadius.circular(AppDimens.radiusLG),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
        splashColor: AppColors.primaryContainer.withValues(alpha: 0.4),
        highlightColor: AppColors.primaryContainer.withValues(alpha: 0.2),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimens.radiusLG),
            border: Border.all(color: borderColor),
          ),
          padding: const EdgeInsets.all(AppDimens.cardPaddingLG),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row — nama + delete
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      doa.nama,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.primaryLighter
                            : AppColors.primary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  if (onRemove != null) ...[
                    const SizedBox(width: AppDimens.spaceXS),
                    GestureDetector(
                      onTap: onRemove,
                      child: Icon(
                        Icons.delete_outline_rounded,
                        color: isDark
                            ? AppColors.onSurfaceDarkVariant
                            : AppColors.textTertiary,
                        size: AppDimens.iconSM + 2,
                      ),
                    ),
                  ],
                ],
              ),

              const SizedBox(height: AppDimens.spaceXS),

              // Grup
              Text(
                doa.grup,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDark
                      ? AppColors.onSurfaceDarkVariant
                      : AppColors.textTertiary,
                  fontStyle: FontStyle.italic,
                  fontSize: 11,
                ),
              ),

              // Preview terjemahan
              if (doa.idn.isNotEmpty) ...[
                const SizedBox(height: AppDimens.spaceSM),
                Text(
                  doa.idn,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? AppColors.onSurfaceDarkVariant
                        : AppColors.textSecondary,
                    height: 1.5,
                    fontSize: 12,
                  ),
                ),
              ],

              // Tag chips
              if (doa.tag.isNotEmpty) ...[
                const SizedBox(height: AppDimens.spaceSM),
                _TagChips(tags: doa.tag, isDark: isDark),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _TagChips extends StatelessWidget {
  const _TagChips({required this.tags, required this.isDark});

  final List<String> tags;
  final bool isDark;

  static const _maxVisible = 3;

  @override
  Widget build(BuildContext context) {
    final visible = tags.take(_maxVisible).toList();
    final overflow = tags.length - _maxVisible;

    return Wrap(
      spacing: AppDimens.spaceXS,
      runSpacing: AppDimens.spaceXS,
      children: [
        ...visible.map((tag) => _TagChip(label: tag, isDark: isDark)),
        if (overflow > 0)
          _TagChip(label: '+$overflow', isDark: isDark, isOverflow: true),
      ],
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({
    required this.label,
    required this.isDark,
    this.isOverflow = false,
  });

  final String label;
  final bool isDark;
  final bool isOverflow;

  @override
  Widget build(BuildContext context) {
    final bgColor = isOverflow
        ? (isDark ? AppColors.outlineDark : AppColors.outlineVariant)
        : (isDark ? AppColors.primaryDark : AppColors.primaryContainer);

    final textColor = isOverflow
        ? (isDark ? AppColors.onSurfaceDarkVariant : AppColors.textTertiary)
        : (isDark ? AppColors.primaryLighter : AppColors.primary);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceSM,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppDimens.radiusFull),
      ),
      child: Text(
        '#$label',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }
}
