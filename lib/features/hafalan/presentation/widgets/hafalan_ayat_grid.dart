import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:flutter/material.dart';

/// Grid nomor ayat — tap untuk toggle hafal/belum.
class HafalanAyatGrid extends StatelessWidget {
  const HafalanAyatGrid({
    required this.jumlahAyat,
    required this.ayatHafal,
    required this.onToggle,
    super.key,
  });

  final int jumlahAyat;
  final List<int> ayatHafal;
  final void Function(int ayatNomor) onToggle;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spaceMD,
          vertical: AppDimens.spaceSM,
        ),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 48,
          mainAxisSpacing: AppDimens.spaceXS,
          crossAxisSpacing: AppDimens.spaceXS,
        ),
        itemCount: jumlahAyat,
        itemBuilder: (context, index) {
          final nomor = index + 1;
          final isHafal = ayatHafal.contains(nomor);
          return RepaintBoundary(
            child: _AyatTile(
              key: ValueKey('ayat_${nomor}_$isHafal'),
              nomor: nomor,
              isHafal: isHafal,
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
    required this.onTap,
    super.key,
  });

  final int nomor;
  final bool isHafal;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isHafal ? AppColors.primary : Colors.grey[100],
          borderRadius: BorderRadius.circular(AppDimens.radiusSM),
          border: Border.all(
            color: isHafal
                ? AppColors.primary
                : Colors.grey[300]!,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          '$nomor',
          style: TextStyle(
            color: isHafal ? AppColors.onPrimary : Colors.grey[600],
            fontSize: 12,
            fontWeight:
                isHafal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
