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
      padding: const EdgeInsets.all(AppDimens.spaceMD),
      child: Row(
        children: [
          if (suratSebelumnya != null)
            Expanded(
              child: _NavButton(
                label: l10n.sebelumnya,
                namaLatin: suratSebelumnya!.namaLatin,
                icon: Icons.arrow_back_ios_rounded,
                isLeft: true,
                onTap: () =>
                    context.push('/surat/${suratSebelumnya!.nomor}'),
              ),
            ),
          if (suratSebelumnya != null && suratSelanjutnya != null)
            const SizedBox(width: AppDimens.spaceSM),
          if (suratSelanjutnya != null)
            Expanded(
              child: _NavButton(
                label: l10n.selanjutnya,
                namaLatin: suratSelanjutnya!.namaLatin,
                icon: Icons.arrow_forward_ios_rounded,
                isLeft: false,
                onTap: () =>
                    context.push('/surat/${suratSelanjutnya!.nomor}'),
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

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.radiusMD),
      child: Container(
        padding: const EdgeInsets.all(AppDimens.spaceMD),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(AppDimens.radiusMD),
        ),
        child: Row(
          mainAxisAlignment:
              isLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
          children: [
            if (isLeft) ...[
              Icon(icon, size: AppDimens.iconSM, color: AppColors.primary),
              const SizedBox(width: AppDimens.spaceXS),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: isLeft
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.end,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.grey[500],
                    ),
                  ),
                  Text(
                    namaLatin,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (!isLeft) ...[
              const SizedBox(width: AppDimens.spaceXS),
              Icon(icon, size: AppDimens.iconSM, color: AppColors.primary),
            ],
          ],
        ),
      ),
    );
  }
}
