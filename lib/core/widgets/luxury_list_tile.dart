import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:flutter/material.dart';

/// List tile luxury — icon container + title + optional subtitle + trailing.
///
/// Otomatis menyesuaikan warna berdasarkan theme (light/dark).
///
/// Contoh:
/// ```dart
/// // Tile sederhana dengan arrow
/// LuxuryListTile(
///   icon: Icons.text_fields_rounded,
///   title: 'Tampilan Teks',
///   subtitle: 'Ukuran & jenis font Arab',
///   trailing: Icon(Icons.arrow_forward_ios_rounded, size: 14),
///   onTap: () => _showFontSettings(context),
/// )
///
/// // Tile dengan Switch
/// LuxuryListTile(
///   icon: Icons.notifications_outlined,
///   title: 'Notifikasi',
///   trailing: Switch(value: isOn, onChanged: onChanged),
/// )
/// ```
class LuxuryListTile extends StatelessWidget {
  const LuxuryListTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.iconColor,
    this.iconBackgroundColor,
    super.key,
  });

  /// Icon yang ditampilkan di container kiri.
  final IconData icon;

  /// Teks judul utama.
  final String title;

  /// Teks subtitle opsional di bawah title.
  final String? subtitle;

  /// Widget trailing opsional (arrow, switch, badge, dsb).
  final Widget? trailing;

  /// Callback tap. Jika null, tile tidak tappable.
  final VoidCallback? onTap;

  /// Override warna icon. Jika null, pakai primary dari theme.
  final Color? iconColor;

  /// Override warna background icon container. Jika null, pakai primaryContainer.
  final Color? iconBackgroundColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveIconColor =
        iconColor ?? (isDark ? AppColors.primaryLighter : AppColors.primary);
    final effectiveIconBg = iconBackgroundColor ??
        (isDark ? AppColors.primaryDark : AppColors.primaryContainer);
    final titleColor =
        isDark ? AppColors.onSurfaceDark : AppColors.textPrimary;
    final subtitleColor =
        isDark ? AppColors.onSurfaceDarkVariant : AppColors.textTertiary;

    final content = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.cardPadding,
        vertical: AppDimens.spaceMD,
      ),
      child: Row(
        children: [
          // Icon container
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: effectiveIconBg,
              borderRadius: BorderRadius.circular(AppDimens.radiusMD),
            ),
            child: Icon(icon, size: AppDimens.iconSM, color: effectiveIconColor),
          ),
          const SizedBox(width: AppDimens.spaceMD),

          // Title + subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: titleColor,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: TextStyle(fontSize: 12, color: subtitleColor),
                  ),
                ],
              ],
            ),
          ),

          // Trailing
          ?trailing,
        ],
      ),
    );

    if (onTap == null) return content;

    return InkWell(onTap: onTap, child: content);
  }
}
