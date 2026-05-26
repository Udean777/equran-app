import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// Menampilkan dialog konfirmasi dengan luxury styling yang konsisten.
///
/// Return `true` jika user konfirmasi, `false` jika batal atau dismiss.
///
/// Contoh:
/// ```dart
/// final confirmed = await showConfirmDialog(
///   context,
///   title: 'Hapus Data',
///   content: 'Tindakan ini tidak bisa dibatalkan.',
/// );
/// if (confirmed) { ... }
/// ```
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String content,
  String confirmLabel = 'Hapus',
  String cancelLabel = 'Batal',
  bool isDestructive = true,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => _LuxuryConfirmDialog(
      title: title,
      content: content,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
      isDestructive: isDestructive,
    ),
  );
  return result ?? false;
}

/// Dialog konfirmasi dengan luxury styling — tidak dipakai langsung,
/// selalu akses via [showConfirmDialog].
class _LuxuryConfirmDialog extends StatelessWidget {
  const _LuxuryConfirmDialog({
    required this.title,
    required this.content,
    required this.confirmLabel,
    required this.cancelLabel,
    required this.isDestructive,
  });

  final String title;
  final String content;
  final String confirmLabel;
  final String cancelLabel;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;
    final borderColor = isDark ? AppColors.outlineDark : AppColors.outline;
    final textPrimary = isDark
        ? AppColors.onSurfaceDark
        : AppColors.textPrimary;
    final textSecondary = isDark
        ? AppColors.onSurfaceDarkVariant
        : AppColors.textSecondary;

    return AlertDialog(
      backgroundColor: surfaceColor,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusXL),
        side: BorderSide(color: borderColor),
      ),
      title: Text(
        title,
        style: AppTypography.serifHeadingSmall.copyWith(color: textPrimary),
      ),
      content: Text(
        content,
        style: TextStyle(
          color: textSecondary,
          fontSize: 14,
          height: 1.5,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            cancelLabel,
            style: TextStyle(color: textSecondary),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: isDestructive
              ? TextButton.styleFrom(foregroundColor: AppColors.error)
              : TextButton.styleFrom(
                  foregroundColor: isDark
                      ? AppColors.primaryLighter
                      : AppColors.primary,
                ),
          child: Text(confirmLabel),
        ),
      ],
    );
  }
}
