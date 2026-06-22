import 'dart:async';
import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/widgets/bottom_sheet_handle.dart';
import 'package:flutter/material.dart';

/// Model representasi dari satu opsi pada [AppSelect].
class AppSelectOption<T> {
  const AppSelectOption({
    required this.value,
    required this.label,
    this.icon,
  });

  final T value;
  final String label;
  final IconData? icon;
}

/// Widget custom select / dropdown selector dengan desain luxury premium.
class AppSelect<T> extends StatelessWidget {
  const AppSelect({
    required this.title,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
    this.placeholder = 'Pilih...',
    this.leadingIcon,
    this.isFullWidth = true,
    super.key,
  });

  final String title;
  final List<AppSelectOption<T>> options;
  final T selectedValue;
  final ValueChanged<T> onChanged;
  final String placeholder;
  final IconData? leadingIcon;
  final bool isFullWidth;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    final currentOption = options.cast<AppSelectOption<T>?>().firstWhere(
      (opt) => opt?.value == selectedValue,
      orElse: () => null,
    );
    final displayLabel = currentOption?.label ?? placeholder;
    final displayIcon = currentOption?.icon ?? leadingIcon;
    final hasActiveSelection = currentOption != null;

    final textColor = isDark ? AppColors.onSurfaceDark : AppColors.textPrimary;
    final iconColor = isDark ? AppColors.primaryLighter : AppColors.primary;
    final activeTextColor = isDark
        ? AppColors.primaryLighter
        : AppColors.primary;
    final fillColor = isDark
        ? AppColors.surfaceDarkVariant
        : AppColors.surfaceVariant;
    final borderColor = isDark ? AppColors.outlineDark : AppColors.outline;

    return Semantics(
      button: true,
      label: '$title selector, nilai saat ini: $displayLabel',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showSelectionBottomSheet(context, isDark),
          borderRadius: BorderRadius.circular(AppDimens.radiusLG),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.spaceMD,
              vertical: AppDimens.spaceSM + 2,
            ),
            decoration: BoxDecoration(
              color: fillColor,
              borderRadius: BorderRadius.circular(AppDimens.radiusLG),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
              children: [
                if (displayIcon != null) ...[
                  Icon(
                    displayIcon,
                    color: hasActiveSelection ? activeTextColor : iconColor,
                    size: AppDimens.iconSM + 2,
                  ),
                  const SizedBox(width: AppDimens.spaceSM),
                ],
                Expanded(
                  child: Text(
                    displayLabel,
                    style: TextStyle(
                      color: hasActiveSelection ? activeTextColor : textColor,
                      fontSize: 13,
                      fontWeight: hasActiveSelection
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: AppDimens.spaceXS),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: hasActiveSelection
                      ? activeTextColor
                      : textColor.withValues(alpha: 0.6),
                  size: AppDimens.iconSM + 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSelectionBottomSheet(BuildContext context, bool isDark) {
    final bottomSheetBgColor = isDark
        ? AppColors.backgroundDarkSecondary
        : AppColors.background;
    final dividerColor = isDark
        ? AppColors.outlineDark
        : AppColors.outlineVariant;
    final headerTextColor = isDark
        ? AppColors.onSurfaceDark
        : AppColors.textPrimary;
    final optionTextColor = isDark
        ? AppColors.onSurfaceDark
        : AppColors.textPrimary;
    final optionActiveColor = isDark
        ? AppColors.primaryLighter
        : AppColors.primary;
    final optionActiveBg = isDark
        ? AppColors.primaryDark
        : AppColors.primaryContainer;

    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: bottomSheetBgColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppDimens.radiusXL),
          ),
        ),
        builder: (modalContext) {
          return DraggableScrollableSheet(
            initialChildSize: options.length > 8 ? 0.6 : 0.45,
            minChildSize: 0.3,
            maxChildSize: 0.85,
            expand: false,
            builder: (scrollContext, scrollController) {
              return SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: AppDimens.spaceSM),
                    const BottomSheetHandle(),
                    const SizedBox(height: AppDimens.spaceMD),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimens.pagePadding,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: TextStyle(
                                color: headerTextColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close_rounded),
                            onPressed: () => Navigator.pop(modalContext),
                            style: IconButton.styleFrom(
                              backgroundColor: isDark
                                  ? AppColors.surfaceDark
                                  : Colors.grey[200],
                              padding: const EdgeInsets.all(AppDimens.spaceXS),
                              minimumSize: Size.zero,
                            ),
                            iconSize: 18,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimens.spaceSM),
                    Divider(color: dividerColor, height: 1),
                    const SizedBox(height: AppDimens.spaceSM),
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimens.pagePadding,
                          vertical: AppDimens.spaceXS,
                        ),
                        itemCount: options.length,
                        itemBuilder: (itemContext, index) {
                          final option = options[index];
                          final isSelected = option.value == selectedValue;

                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppDimens.spaceXS,
                            ),
                            child: Material(
                              color: isSelected
                                  ? optionActiveBg
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(
                                AppDimens.radiusMD,
                              ),
                              child: InkWell(
                                onTap: () {
                                  onChanged(option.value);
                                  Navigator.pop(modalContext);
                                },
                                borderRadius: BorderRadius.circular(
                                  AppDimens.radiusMD,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppDimens.spaceMD,
                                    vertical: AppDimens.spaceMD - 2,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      AppDimens.radiusMD,
                                    ),
                                    border: Border.all(
                                      color: isSelected
                                          ? optionActiveColor
                                          : Colors.transparent,
                                      width: 1.2,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      if (option.icon != null) ...[
                                        Icon(
                                          option.icon,
                                          color: isSelected
                                              ? optionActiveColor
                                              : optionTextColor.withValues(
                                                  alpha: 0.6,
                                                ),
                                          size: AppDimens.iconSM + 2,
                                        ),
                                        const SizedBox(
                                          width: AppDimens.spaceMD,
                                        ),
                                      ] else if (leadingIcon != null) ...[
                                        Icon(
                                          leadingIcon,
                                          color: isSelected
                                              ? optionActiveColor
                                              : optionTextColor.withValues(
                                                  alpha: 0.6,
                                                ),
                                          size: AppDimens.iconSM + 2,
                                        ),
                                        const SizedBox(
                                          width: AppDimens.spaceMD,
                                        ),
                                      ],
                                      Expanded(
                                        child: Text(
                                          option.label,
                                          style: TextStyle(
                                            color: isSelected
                                                ? optionActiveColor
                                                : optionTextColor,
                                            fontSize: 14,
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      if (isSelected)
                                        Icon(
                                          Icons.check_rounded,
                                          color: optionActiveColor,
                                          size: AppDimens.iconSM + 2,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
