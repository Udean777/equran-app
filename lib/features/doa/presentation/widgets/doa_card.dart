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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nama doa
              Row(
                children: [
                  Expanded(
                    child: Text(
                      doa.nama,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  if (onRemove != null)
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded),
                      color: Colors.grey[400],
                      onPressed: onRemove,
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                ],
              ),
              const SizedBox(height: AppDimens.spaceXS),
              // Grup
              Text(
                doa.grup,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
              // Preview terjemahan (skip jika kosong)
              if (doa.idn.isNotEmpty) ...[
                const SizedBox(height: AppDimens.spaceXS),
                Text(
                  doa.idn,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
              // Tag chips
              if (doa.tag.isNotEmpty) ...[
                const SizedBox(height: AppDimens.spaceSM),
                _TagChips(tags: doa.tag),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _TagChips extends StatelessWidget {
  const _TagChips({required this.tags});

  final List<String> tags;

  static const _maxVisible = 3;

  @override
  Widget build(BuildContext context) {
    final visible = tags.take(_maxVisible).toList();
    final overflow = tags.length - _maxVisible;

    return Wrap(
      spacing: AppDimens.spaceXS,
      runSpacing: AppDimens.spaceXS,
      children: [
        ...visible.map(
          (tag) => _TagChip(label: tag),
        ),
        if (overflow > 0) _TagChip(label: '+$overflow', isOverflow: true),
      ],
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.label, this.isOverflow = false});

  final String label;
  final bool isOverflow;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceSM,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: isOverflow
            ? (isDark ? Colors.grey[800] : Colors.grey[200])
            : AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimens.radiusFull),
      ),
      child: Text(
        '#$label',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: isOverflow
              ? (isDark ? Colors.grey[400] : Colors.grey[600])
              : AppColors.primary,
        ),
      ),
    );
  }
}
