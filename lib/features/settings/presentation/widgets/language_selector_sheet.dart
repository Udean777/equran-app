import 'dart:async';

import 'package:equran_app/core/locale/cubit/language_cubit.dart';
import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/widgets/bottom_sheet_handle.dart';
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
      (const LanguageState.id(), l10n.indonesia),
      (const LanguageState.en(), l10n.english),
      (const LanguageState.ar(), l10n.arabic),
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
              final (lang, label) = entry;
              final isSelected = lang.runtimeType == current.runtimeType;

              return ListTile(
                leading: Icon(
                  Icons.language_rounded,
                  size: 24,
                  color: isSelected ? AppColors.primary : null,
                ),
                title: Text(
                  label,
                  style: TextStyle(
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: isSelected ? AppColors.primary : null,
                  ),
                ),
                trailing: isSelected
                    ? const Icon(Icons.check_rounded, color: AppColors.primary)
                    : null,
                onTap: () {
                  unawaited(
                    context.read<LanguageCubit>().changeLanguage(lang),
                  );
                  Navigator.pop(context);
                },
              );
            },
          ),
          const SizedBox(height: AppDimens.spaceMD),
        ],
      ),
    );
  }
}
