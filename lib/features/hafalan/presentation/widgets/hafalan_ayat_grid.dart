import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:flutter/material.dart';

/// Grid nomor ayat — tap untuk toggle hafal/belum.
class HafalanAyatGrid extends StatelessWidget {
  const HafalanAyatGrid({
    required this.jumlahAyat,
    required this.ayatHafal,
    required this.onToggle,
    this.startAyat = 1,
    super.key,
  });

  final int jumlahAyat;
  final List<int> ayatHafal;
  final void Function(int ayatNomor) onToggle;
  final int startAyat;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return RepaintBoundary(
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          AppDimens.pagePadding,
          AppDimens.spaceSM,
          AppDimens.pagePadding,
          AppDimens.spaceMD,
        ),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 52,
          mainAxisSpacing: AppDimens.spaceSM,
          crossAxisSpacing: AppDimens.spaceSM,
        ),
        itemCount: jumlahAyat,
        itemBuilder: (context, index) {
          final nomor = startAyat + index;
          final isHafal = ayatHafal.contains(nomor);
          return RepaintBoundary(
            child: _AyatTile(
              key: ValueKey('ayat_${nomor}_$isHafal'),
              nomor: nomor,
              isHafal: isHafal,
              isDark: isDark,
              onTap: () => onToggle(nomor),
            ),
          );
        },
      ),
    );
  }
}

class _AyatTile extends StatelessWidget {
  const _AyatTile({
    required this.nomor,
    required this.isHafal,
    required this.isDark,
    required this.onTap,
    super.key,
  });

  final int nomor;
  final bool isHafal;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bgColor = isHafal
        ? (isDark ? AppColors.primaryLight : AppColors.primary)
        : (isDark ? AppColors.surfaceDarkVariant : AppColors.surfaceVariant);
    final textColor = isHafal
        ? AppColors.onPrimary
        : (isDark ? AppColors.onSurfaceDarkVariant : AppColors.textTertiary);
    final borderColor = isHafal
        ? Colors.transparent
        : (isDark ? AppColors.outlineDark : AppColors.outlineVariant);

    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(AppDimens.radiusMD),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.radiusMD),
        splashColor: AppColors.primaryContainer.withValues(alpha: 0.5),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimens.radiusMD),
            border: Border.all(color: borderColor),
          ),
          alignment: Alignment.center,
          child: isHafal
              ? Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      nomor.toString(),
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w700,
                        fontSize: nomor > 99 ? 9 : 11,
                      ),
                    ),
                    // Gold dot indicator
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        width: 5,
                        height: 5,
                        decoration: const BoxDecoration(
                          color: AppColors.gold,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                )
              : Text(
                  nomor.toString(),
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                    fontSize: nomor > 99 ? 9 : 11,
                  ),
                ),
        ),
      ),
    );
  }
}
