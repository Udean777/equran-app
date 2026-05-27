import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/hafalan/domain/entities/hafalan_surat.dart';
import 'package:flutter/material.dart';

/// Card reminder muraja'ah harian — menampilkan daftar surat yang perlu
/// dimuraja'ah hari ini dengan desain mewah dan premium.
class MurajaahReminderCard extends StatelessWidget {
  const MurajaahReminderCard({
    required this.suratList,
    required this.onTap,
    super.key,
  });

  final List<HafalanSurat> suratList;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Ambil maksimal 3 surat untuk ditampilkan sebagai chips
    final displaySurats = suratList.take(3).toList();
    final hasExtra = suratList.length > 3;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.pagePadding,
        AppDimens.spaceXS,
        AppDimens.pagePadding,
        AppDimens.spaceXS,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimens.radiusLG),
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF12241A), const Color(0xFF1B3626)]
                : [const Color(0xFFFAFDFB), const Color(0xFFEEF6F1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: AppColors.gold.withValues(alpha: isDark ? 0.35 : 0.45),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimens.radiusLG),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppDimens.radiusLG),
            splashColor: AppColors.gold.withValues(alpha: 0.1),
            highlightColor: AppColors.gold.withValues(alpha: 0.05),
            child: Padding(
              padding: const EdgeInsets.all(AppDimens.cardPaddingLG),
              child: Row(
                children: [
                  // Circular glowing icon
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.gold.withValues(alpha: isDark ? 0.15 : 0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.gold.withValues(alpha: isDark ? 0.3 : 0.4),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.gold.withValues(alpha: isDark ? 0.1 : 0.05),
                          blurRadius: 6,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.auto_stories_rounded,
                      color: AppColors.gold,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: AppDimens.spaceMD),

                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "MURAJA'AH HARI INI",
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: isDark ? AppColors.goldLight : AppColors.goldDark,
                                fontWeight: FontWeight.w800,
                                fontSize: 10.5,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(width: AppDimens.spaceXS),
                            Container(
                              width: 5,
                              height: 5,
                              decoration: const BoxDecoration(
                                color: AppColors.gold,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),

                        // Chips layout
                        Wrap(
                          spacing: AppDimens.spaceXS,
                          runSpacing: 4,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            ...displaySurats.map((s) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppDimens.spaceXS + 1,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.gold.withValues(alpha: 0.12)
                                    : AppColors.gold.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(AppDimens.radiusSM),
                                border: Border.all(
                                  color: AppColors.gold.withValues(alpha: isDark ? 0.35 : 0.3),
                                  width: 0.8,
                                ),
                              ),
                              child: Text(
                                s.namaLatin,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: isDark ? AppColors.goldLight : AppColors.goldDark,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                ),
                              ),
                            )),
                            if (hasExtra)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppDimens.spaceXS + 1,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.primaryLighter.withValues(alpha: 0.15)
                                      : AppColors.primaryContainer,
                                  borderRadius: BorderRadius.circular(AppDimens.radiusSM),
                                  border: Border.all(
                                    color: isDark
                                        ? AppColors.primaryLighter.withValues(alpha: 0.3)
                                        : AppColors.primary.withValues(alpha: 0.25),
                                    width: 0.8,
                                  ),
                                ),
                                child: Text(
                                  '+${suratList.length - 3} lainnya',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: isDark ? AppColors.primaryLighter : AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppDimens.spaceSM),

                  // Start Action Button
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.gold.withValues(alpha: 0.2)
                          : AppColors.gold,
                      borderRadius: BorderRadius.circular(AppDimens.radiusMD),
                      border: isDark
                          ? Border.all(
                              color: AppColors.gold.withValues(alpha: 0.4),
                            )
                          : null,
                      boxShadow: [
                        if (!isDark)
                          BoxShadow(
                            color: AppColors.gold.withValues(alpha: 0.25),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Mulai',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: isDark ? AppColors.goldLighter : Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 11,
                            letterSpacing: 0.4,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: isDark ? AppColors.goldLighter : Colors.white,
                          size: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
