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

/// Menampilkan dialog sukses saat selesai membaca surah.
Future<void> showSuccessReadDialog(
  BuildContext context, {
  required String namaSurah,
  required VoidCallback onBackToHome,
}) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: false, // User must interact with it
    builder: (ctx) => _LuxurySuccessReadDialog(
      namaSurah: namaSurah,
      onBackToHome: onBackToHome,
    ),
  );
}

class _LuxurySuccessReadDialog extends StatelessWidget {
  const _LuxurySuccessReadDialog({
    required this.namaSurah,
    required this.onBackToHome,
  });

  final String namaSurah;
  final VoidCallback onBackToHome;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;
    final borderColor = isDark ? AppColors.outlineDark : AppColors.outline;
    final textPrimary = isDark ? AppColors.onSurfaceDark : AppColors.textPrimary;
    final textSecondary = isDark ? AppColors.onSurfaceDarkVariant : AppColors.textSecondary;

    return AlertDialog(
      backgroundColor: surfaceColor,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusXL),
        side: BorderSide(color: borderColor, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceLG,
        vertical: AppDimens.spaceXL,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon/Badge of achievement
          Container(
            padding: const EdgeInsets.all(AppDimens.spaceMD),
            decoration: BoxDecoration(
              color: isDark 
                  ? AppColors.primaryDark.withValues(alpha: 0.3) 
                  : AppColors.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.stars_rounded,
              color: isDark ? AppColors.primaryLighter : AppColors.primary,
              size: 56,
            ),
          ),
          const SizedBox(height: AppDimens.spaceLG),
          
          // Congratulations text
          Text(
            'Alhamdulillah!',
            style: AppTypography.serifHeadingMedium.copyWith(
              color: isDark ? AppColors.primaryLighter : AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimens.spaceXS),
          Text(
            'Kamu berhasil membaca surah',
            style: TextStyle(
              color: textSecondary,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            namaSurah,
            style: AppTypography.serifHeadingSmall.copyWith(
              color: textPrimary,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimens.spaceXL),
          
          // Action button - Back to main
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // close dialog
                onBackToHome();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? AppColors.primaryLighter : AppColors.primary,
                foregroundColor: isDark ? Colors.black : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimens.radiusLG),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Kembali ke Halaman Utama',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
