import 'package:equran_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Helper untuk menampilkan toast feedback di halaman Settings.
///
/// Gunakan [showSettingsToast] untuk menampilkan pesan toast, baik untuk aksi
/// sukses (default) maupun aksi gagal (dengan menyetel `isSuccess: false`).
///
/// Contoh:
/// ```dart
/// showSettingsToast(context, 'Notifikasi Subuh aktif');
/// showSettingsToast(context, 'Notifikasi Subuh dimatikan', isSuccess: false);
/// ```
void showSettingsToast(
  BuildContext context,
  String message, {
  bool isSuccess = true,
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isSuccess
                  ? Icons.check_circle_rounded
                  : Icons.info_outline_rounded,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: isSuccess ? AppColors.primary : AppColors.textSecondary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
}
