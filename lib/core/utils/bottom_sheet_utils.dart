import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:flutter/material.dart';

/// Helper untuk menampilkan bottom sheet dengan styling konsisten.
///
/// Return [Future<T?>] sehingga caller bisa handle result dari sheet.
///
/// Contoh:
/// ```dart
/// final result = await showAppBottomSheet<String>(
///   context,
///   builder: (ctx) => MySheet(),
/// );
/// ```
Future<T?> showAppBottomSheet<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  bool isScrollControlled = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppDimens.radiusLG),
      ),
    ),
    builder: builder,
  );
}
