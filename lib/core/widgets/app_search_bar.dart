import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:flutter/material.dart';

/// Search bar dengan styling luxury — filled background, prefix search icon,
/// suffix clear button, focused border primary.
///
/// Mengelola [TextEditingController] internal jika [controller] tidak di-pass.
/// Jika [controller] di-pass dari luar, caller bertanggung jawab untuk dispose.
///
/// Otomatis menyesuaikan warna berdasarkan theme (light/dark).
///
/// Contoh:
/// ```dart
/// // Managed internally
/// AppSearchBar(
///   hint: 'Cari surah...',
///   onChanged: cubit.onQueryChanged,
/// )
///
/// // Controller dari luar (untuk akses clear, dsb)
/// AppSearchBar(
///   controller: _searchController,
///   hint: 'Cari doa...',
///   autofocus: true,
///   onChanged: cubit.search,
/// )
/// ```
class AppSearchBar extends StatefulWidget {
  const AppSearchBar({
    required this.onChanged,
    this.controller,
    this.hint,
    this.autofocus = false,
    super.key,
  });

  /// Callback dipanggil setiap kali teks berubah.
  final ValueChanged<String> onChanged;

  /// Controller eksternal opsional. Jika null, widget buat controller sendiri.
  final TextEditingController? controller;

  /// Hint text. Default: 'Cari...'.
  final String? hint;

  /// Autofocus saat widget pertama kali muncul. Default false.
  final bool autofocus;

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  late final TextEditingController _controller;
  late final bool _ownsController;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
      _ownsController = false;
    } else {
      _controller = TextEditingController();
      _ownsController = true;
    }
  }

  @override
  void dispose() {
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final textColor = isDark ? AppColors.onSurfaceDark : AppColors.textPrimary;
    final hintColor = isDark
        ? AppColors.onSurfaceDarkVariant
        : AppColors.textTertiary;
    final iconColor = isDark ? AppColors.primaryLighter : AppColors.primary;
    final fillColor = isDark
        ? AppColors.surfaceDarkVariant
        : AppColors.surfaceVariant;
    final borderColor = isDark ? AppColors.outlineDark : AppColors.outline;
    final focusedBorderColor = isDark
        ? AppColors.primaryLighter
        : AppColors.primary;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.pagePadding,
        AppDimens.spaceSM,
        AppDimens.pagePadding,
        AppDimens.spaceSM,
      ),
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        autofocus: widget.autofocus,
        style: TextStyle(color: textColor, fontSize: 14),
        decoration: InputDecoration(
          hintText: widget.hint ?? 'Cari...',
          hintStyle: TextStyle(color: hintColor, fontSize: 14),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: iconColor,
            size: AppDimens.iconMD,
          ),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: _controller,
            builder: (_, value, _) => value.text.isNotEmpty
                ? IconButton(
                    icon: Icon(
                      Icons.clear_rounded,
                      color: hintColor,
                      size: AppDimens.iconSM + 2,
                    ),
                    onPressed: () {
                      _controller.clear();
                      widget.onChanged('');
                    },
                  )
                : const SizedBox.shrink(),
          ),
          filled: true,
          fillColor: fillColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusLG),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusLG),
            borderSide: BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusLG),
            borderSide: BorderSide(color: focusedBorderColor, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppDimens.spaceMD,
            vertical: AppDimens.spaceSM + 2,
          ),
        ),
      ),
    );
  }
}
