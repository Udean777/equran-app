import 'package:equran_app/core/constants/juz_constants.dart';
import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// AppBar untuk SuratDetailPage — luxury style, putih, serif title.
/// [currentAyatNomor] = nomor ayat aktif (0 = info card, null = tidak diketahui).
/// Label juz ditampilkan dinamis sesuai ayat yang sedang dibaca.
class SuratDetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SuratDetailAppBar({
    required this.detail,
    this.currentAyatNomor,
    super.key,
  });

  final SuratDetail detail;

  /// Nomor ayat yang sedang aktif di card stack.
  /// 0 = info card (tampilkan semua juz surat).
  /// null = tidak diketahui (fallback ke semua juz).
  final int? currentAyatNomor;

  @override
  Size get preferredSize => const Size.fromHeight(AppDimens.appBarHeightLG);

  /// Cari juz untuk ayat tertentu menggunakan [JuzConstants].
  /// Jika [ayatNomor] 0 atau null, kembalikan semua juz surat ini.
  String _buildJuzLabel(int suratNomor, int? ayatNomor) {
    if (ayatNomor == null || ayatNomor == 0) {
      final allJuz = JuzConstants.findJuzesForSurat(suratNomor);
      if (allJuz.isEmpty) return '';
      return 'Juz ${allJuz.join(', ')}';
    }

    final juz = JuzConstants.findJuzForAyat(suratNomor, ayatNomor);
    if (juz != null) return 'Juz $juz';
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final iconColor = context.textPrimaryColor;
    final surfaceColor = context.surfaceColor;
    final juzLabel = _buildJuzLabel(detail.nomor, currentAyatNomor);

    return AppBar(
      backgroundColor: surfaceColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      toolbarHeight: AppDimens.appBarHeightLG,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_rounded, color: iconColor),
        onPressed: () => context.pop(),
      ),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            detail.namaLatin,
            style: AppTypography.serifHeadingSmall.copyWith(
              color: context.textPrimaryColor,
              fontSize: 17,
              height: 1,
            ),
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
          if (juzLabel.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              juzLabel,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? AppColors.onSurfaceDark.withValues(alpha: 0.6)
                    : AppColors.textPrimary.withValues(alpha: 0.5),
                letterSpacing: 0.3,
              ),
            ),
          ],
        ],
      ),
      centerTitle: true,
    );
  }
}
