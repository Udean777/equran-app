import 'dart:async';

import 'package:equran_app/core/locale/cubit/language_cubit.dart';
import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/widgets/bottom_sheet_handle.dart';
import 'package:equran_app/features/settings/presentation/widgets/settings_toast.dart';
import 'package:equran_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Bottom sheet pemilih bahasa aplikasi.
class LanguageSelectorSheet extends StatelessWidget {
  const LanguageSelectorSheet({
    required this.current,
    required this.l10n,
    super.key,
  });

  final LanguageState current;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final languages = [
      (const LanguageState.id(), l10n.indonesia, 'Bahasa diubah ke Indonesia'),
      (const LanguageState.en(), l10n.english, 'Language changed to English'),
      (const LanguageState.ar(), l10n.arabic, 'تم تغيير اللغة إلى العربية'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceMD),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          const Padding(
            padding: EdgeInsets.only(bottom: AppDimens.spaceMD),
            child: BottomSheetHandle(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMD),
            child: Text(
              l10n.bahasa,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: AppDimens.spaceSM),
          ...languages.map(
            (entry) {
              final (lang, label, toastMessage) = entry;
              final isSelected = lang.runtimeType == current.runtimeType;
              final isDark = Theme.of(context).brightness == Brightness.dark;

              return InkWell(
                onTap: () {
                  unawaited(
                    context.read<LanguageCubit>().changeLanguage(lang),
                  );
                  showSettingsToast(context, toastMessage);
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.spaceMD,
                    vertical: AppDimens.spaceMD,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
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
                        child: Icon(
                          Icons.language_rounded,
                          size: 18,
                          color: isSelected
                              ? Colors.white
                              : (isDark
                                    ? AppColors.primaryLighter
                                    : AppColors.primary),
                        ),
                      ),
                      const SizedBox(width: AppDimens.spaceMD),
                      Expanded(
                        child: Text(
                          label,
                          style: TextStyle(
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                            fontSize: 15,
                            color: isSelected
                                ? AppColors.primary
                                : (isDark
                                      ? AppColors.onSurfaceDark
                                      : AppColors.textPrimary),
                          ),
                        ),
                      ),
                      if (isSelected)
                        const Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.primary,
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
