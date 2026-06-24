import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/surat_detail/presentation/theme/share_templates_theme.dart';
import 'package:flutter/material.dart';

class TemplateSelector extends StatelessWidget {
  const TemplateSelector({
    required this.selectedStyle,
    required this.onTemplateChanged,
    super.key,
  });

  final ShareTemplateStyle selectedStyle;
  final ValueChanged<ShareTemplateStyle> onTemplateChanged;

  @override
  Widget build(BuildContext context) {
    final textTertiary = context.textTertiaryColor;
    final textPrimary = context.textPrimaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PILIH DESAIN',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: textTertiary,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: AppDimens.spaceSM),
        SizedBox(
          height: 80,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.pagePadding,
            ),
            scrollDirection: Axis.horizontal,
            itemCount: ShareTemplateStyle.values.length,
            separatorBuilder: (_, _) =>
                const SizedBox(width: AppDimens.spaceMD),
            itemBuilder: (context, index) {
              final style = ShareTemplateStyle.values[index];
              final isSelected = selectedStyle == style;
              return _TemplateItem(
                style: style,
                isSelected: isSelected,
                textPrimary: textPrimary,
                textTertiary: textTertiary,
                onTap: () => onTemplateChanged(style),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _TemplateItem extends StatelessWidget {
  const _TemplateItem({
    required this.style,
    required this.isSelected,
    required this.textPrimary,
    required this.textTertiary,
    required this.onTap,
  });

  final ShareTemplateStyle style;
  final bool isSelected;
  final Color textPrimary;
  final Color textTertiary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: style.backgroundColors,
                stops: style.stops,
              ),
              border: isSelected
                  ? Border.all(
                      color: AppColors.gold,
                      width: 2.5,
                    )
                  : Border.all(
                      color: context.borderColor,
                    ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.gold.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.gold,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 6),
          Text(
            style.displayName,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? textPrimary : textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}
