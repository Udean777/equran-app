import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:flutter/material.dart';

/// Header section dengan label bold — dipakai untuk memisahkan
/// kelompok konten dalam satu halaman.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.label,
    this.showBackButton = false,
    this.onBack,
    super.key,
  });

  final String label;
  final bool showBackButton;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.spaceMD,
        AppDimens.spaceMD,
        AppDimens.spaceMD,
        AppDimens.spaceXS,
      ),
      child: Row(
        children: [
          if (showBackButton) ...[
            IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: onBack ?? () => Navigator.maybePop(context),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: AppDimens.spaceSM),
          ],
          Text(
            label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
