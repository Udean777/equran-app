import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:equran_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SuratNavButton extends StatelessWidget {
  const SuratNavButton({
    required this.suratSebelumnya,
    required this.suratSelanjutnya,
    super.key,
  });

  final SuratNavigation? suratSebelumnya;
  final SuratNavigation? suratSelanjutnya;

  @override
  Widget build(BuildContext context) {
    if (suratSebelumnya == null && suratSelanjutnya == null) {
      return const SizedBox.shrink();
    }

    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.pagePadding,
        AppDimens.spaceSM,
        AppDimens.pagePadding,
        AppDimens.spaceMD,
      ),
      child: Row(
        children: [
          if (suratSebelumnya != null)
            Expanded(
              child: _NavButton(
                label: l10n.sebelumnya,
                namaLatin: suratSebelumnya!.namaLatin,
                icon: Icons.arrow_back_rounded,
                isLeft: true,
                onTap: () => context.push('/surat/${suratSebelumnya!.nomor}'),
              ),
            ),
          if (suratSebelumnya != null && suratSelanjutnya != null)
            const SizedBox(width: AppDimens.spaceSM),
          if (suratSelanjutnya != null)
            Expanded(
              child: _NavButton(
                label: l10n.selanjutnya,
                namaLatin: suratSelanjutnya!.namaLatin,
                icon: Icons.arrow_forward_rounded,
                isLeft: false,
                onTap: () => context.push('/surat/${suratSelanjutnya!.nomor}'),
              ),
            ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.label,
    required this.namaLatin,
    required this.icon,
    required this.isLeft,
    required this.onTap,
  });

  final String label;
  final String namaLatin;
  final IconData icon;
  final bool isLeft;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor =
        isDark ? AppColors.primaryLighter : AppColors.primary;
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;
    final borderColor =
        isDark ? AppColors.outlineDark : AppColors.outlineVariant;

    return Material(
      color: surfaceColor,
      borderRadius: BorderRadius.circular(AppDimens.radiusLG),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
        splashColor: AppColors.primaryContainer.withValues(alpha: 0.4),
        child: Container(
          padding: const EdgeInsets.all(AppDimens.spaceMD),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimens.radiusLG),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            mainAxisAlignment:
                isLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
            children: [
              if (isLeft) ...[
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.primaryDark
                        : AppColors.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 14, color: primaryColor),
                ),
                const SizedBox(width: AppDimens.spaceSM),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: isLeft
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.end,
                  children: [
                    Text(
                      label.toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: isDark
                            ? AppColors.onSurfaceDarkVariant
                            : AppColors.textTertiary,
                        fontSize: 9,
                        letterSpacing: 0.8,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      namaLatin,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (!isLeft) ...[
                const SizedBox(width: AppDimens.spaceSM),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.primaryDark
                        : AppColors.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 14, color: primaryColor),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
