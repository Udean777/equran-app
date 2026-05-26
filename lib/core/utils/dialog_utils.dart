import 'package:flutter/material.dart';

/// Helper untuk menampilkan dialog konfirmasi dengan styling konsisten.
///
/// Return `true` jika user konfirmasi, `false` jika batal atau dismiss.
///
/// Contoh:
/// ```dart
/// final confirmed = await showConfirmDialog(
///   context,
///   title: 'Hapus Semua',
///   content: 'Yakin ingin menghapus semua data?',
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
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: Text(cancelLabel),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          style: isDestructive
              ? TextButton.styleFrom(
                  foregroundColor: Theme.of(ctx).colorScheme.error,
                )
              : null,
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return result ?? false;
}
