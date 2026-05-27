import 'dart:ui' as ui;

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/widgets/label_chip.dart';
import 'package:equran_app/core/widgets/luxury_divider.dart';
import 'package:equran_app/features/catatan_ayat/domain/entities/catatan_ayat.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Card catatan ayat — menampilkan label surat·ayat, teks Arab, isi catatan,
/// dan tanggal. Mendukung swipe-to-delete via [Dismissible].
class CatatanAyatCard extends StatelessWidget {
  const CatatanAyatCard({
    required this.catatan,
    required this.onTap,
    required this.onDelete,
    super.key,
  });

  final CatatanAyat catatan;
  final VoidCallback onTap;

  /// Dipanggil saat user swipe atau konfirmasi hapus.
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;
    final borderColor = isDark
        ? AppColors.outlineDark
        : AppColors.outlineVariant;
    final dateStr = DateFormat('d MMM yyyy', 'id').format(catatan.savedAt);

    return Dismissible(
      key: Key('${catatan.suratNomor}:${catatan.ayatNomor}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppDimens.spaceMD),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(AppDimens.radiusLG),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
      ),
      confirmDismiss: (_) async {
        onDelete();
        return false;
      },
      child: Material(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimens.radiusLG),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimens.radiusLG),
              border: Border.all(color: borderColor),
            ),
            padding: const EdgeInsets.all(AppDimens.cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header — label surat·ayat + tanggal
                Row(
                  children: [
                    LabelChip(
                      label: '${catatan.namaLatin} · ${catatan.ayatNomor}',
                    ),
                    const Spacer(),
                    Text(
                      dateStr,
                      style: TextStyle(
                        color: isDark
                            ? AppColors.onSurfaceDarkVariant
                            : AppColors.textTertiary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimens.spaceSM),

                // Teks Arab
                Directionality(
                  textDirection: ui.TextDirection.rtl,
                  child: Text(
                    catatan.teksArab,
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 18,
                      color: isDark
                          ? AppColors.primaryLighter
                          : AppColors.primary,
                      height: 1.8,
                    ),
                  ),
                ),

                const GoldDivider(),

                // Isi catatan
                Text(
                  catatan.isi,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark
                        ? AppColors.onSurfaceDark
                        : AppColors.textPrimary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
