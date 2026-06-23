import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:flutter/material.dart';

/// Menampilkan dialog konfirmasi modal untuk aksi settings yang sensitif.
///
/// Parameter:
/// - [title]: Judul dialog.
/// - [message]: Pesan deskripsi aksi yang akan dilakukan.
/// - [cancelText]: Teks tombol batal (default: 'Batal').
/// - [confirmText]: Teks tombol konfirmasi (default: 'OK').
/// - [isDestructive]: Jika `true`, tombol konfirmasi berwarna merah ([AppColors.error]).
///
/// Mengembalikan `true` jika user menekan tombol konfirmasi,
/// `false` jika batal, atau `null` jika dialog ditutup dengan cara lain.
Future<bool?> showSettingsConfirmationDialog({
  required BuildContext context,
  required String title,
  required String message,
  String? cancelText,
  String? confirmText,
  bool isDestructive = false,
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      final isDark = Theme.of(context).brightness == Brightness.dark;

      return AlertDialog(
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusXL),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isDark ? AppColors.onSurfaceDark : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          message,
          style: TextStyle(
            color: isDark
                ? AppColors.onSurfaceDarkVariant
                : AppColors.textSecondary,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(
              foregroundColor: isDark
                  ? AppColors.onSurfaceDarkVariant
                  : AppColors.textSecondary,
            ),
            child: Text(cancelText ?? 'Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDestructive
                  ? AppColors.error
                  : AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimens.radiusMD),
              ),
            ),
            child: Text(confirmText ?? 'OK'),
          ),
        ],
      );
    },
  );
}
