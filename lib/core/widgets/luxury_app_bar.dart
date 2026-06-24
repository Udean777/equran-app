import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// AppBar luxury dengan serif title + gold ornament line.
///
/// Leading behavior (auto-detect):
/// - Jika [leading] di-pass → pakai widget tersebut
/// - Jika `Navigator.canPop` → tampilkan [BackButton]
/// - Jika ada drawer di Scaffold → tampilkan hamburger button
/// - Jika tidak ada keduanya → tidak ada leading
///
/// Contoh:
/// ```dart
/// // Auto-detect leading
/// LuxuryAppBar(title: 'Pengaturan')
///
/// // Dengan actions
/// LuxuryAppBar(
///   title: 'Al-Quran',
///   actions: [IconButton(...)],
/// )
///
/// // Leading eksplisit (misal hamburger manual)
/// LuxuryAppBar(
///   title: 'Beranda',
///   leading: Builder(
///     builder: (ctx) => IconButton(
///       icon: const Icon(Icons.menu_rounded),
///       onPressed: () => Scaffold.of(ctx).openDrawer(),
///     ),
///   ),
/// )
/// ```
class LuxuryAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LuxuryAppBar({
    required this.title,
    this.leading,
    this.actions,
    this.bottom,
    this.titleFontSize = 20,
    super.key,
  });

  /// Teks judul AppBar.
  final String title;

  /// Widget leading kustom. Jika null, auto-detect dari Navigator/Scaffold.
  final Widget? leading;

  /// Action buttons di sisi kanan.
  final List<Widget>? actions;

  /// Widget di bawah toolbar (misal TabBar).
  final PreferredSizeWidget? bottom;

  /// Ukuran font judul. Default 20.
  final double titleFontSize;

  @override
  Size get preferredSize => Size.fromHeight(
    AppDimens.appBarHeightLG + (bottom?.preferredSize.height ?? 0),
  );

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;
    final contentColor = isDark
        ? AppColors.onSurfaceDark
        : AppColors.textPrimary;

    return AppBar(
      backgroundColor: surfaceColor,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      shadowColor: AppColors.outline,
      surfaceTintColor: Colors.transparent,
      toolbarHeight: AppDimens.appBarHeightLG,
      leading: leading ?? _buildLeading(context, contentColor),
      automaticallyImplyLeading: false,
      title: _LuxuryAppBarTitle(
        title: title,
        color: contentColor,
        fontSize: titleFontSize,
      ),
      centerTitle: true,
      actions: actions,
      bottom: bottom,
    );
  }

  /// Auto-detect leading: back button jika bisa pop, hamburger jika ada drawer.
  Widget? _buildLeading(BuildContext context, Color color) {
    if (Navigator.canPop(context)) {
      return IconButton(
        icon: Icon(Icons.arrow_back_rounded, color: color),
        onPressed: () => Navigator.maybePop(context),
      );
    }

    // Cek apakah Scaffold punya drawer — pakai Builder agar context benar
    return Builder(
      builder: (ctx) {
        final scaffold = Scaffold.maybeOf(ctx);
        if (scaffold?.hasDrawer ?? false) {
          return IconButton(
            icon: Icon(Icons.menu_rounded, color: color),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

/// Title widget internal — serif heading + gold ornament line.
class _LuxuryAppBarTitle extends StatelessWidget {
  const _LuxuryAppBarTitle({
    required this.title,
    required this.color,
    required this.fontSize,
  });

  final String title;
  final Color color;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: AppTypography.serifHeadingMedium.copyWith(
            color: color,
            height: 1,
            fontSize: fontSize,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 3),
        Container(
          width: 20,
          height: 1.5,
          decoration: BoxDecoration(
            color: AppColors.gold,
            borderRadius: BorderRadius.circular(AppDimens.radiusFull),
          ),
        ),
      ],
    );
  }
}
