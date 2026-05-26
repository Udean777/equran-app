import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/bookmark/domain/entities/last_read.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LastReadCard extends StatelessWidget {
  const LastReadCard({
    required this.lastRead,
    super.key,
  });

  final LastRead lastRead;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.spaceMD,
        AppDimens.spaceMD,
        AppDimens.spaceMD,
        AppDimens.spaceXS,
      ),
      child: InkWell(
        onTap: () => context.push(
          '/surat/${lastRead.suratNomor}?ayat=${lastRead.ayatNomor}',
        ),
        borderRadius: BorderRadius.circular(AppDimens.radiusMD),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, Color(0xFF2E7D32)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppDimens.radiusMD),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppDimens.spaceMD),
                child: Row(
                  children: [
                    const Icon(
                      Icons.menu_book_rounded,
                      color: AppColors.onPrimary,
                      size: AppDimens.iconLG,
                    ),
                    const SizedBox(width: AppDimens.spaceMD),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Lanjutkan Membaca',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: AppColors.onPrimary.withValues(alpha: 0.8),
                            ),
                          ),
                          const SizedBox(height: AppDimens.spaceXS),
                          Text(
                            lastRead.namaLatin,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: AppColors.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            lastRead.totalAyat > 0
                                ? 'Ayat ${lastRead.ayatNomor} dari ${lastRead.totalAyat}'
                                : 'Ayat ${lastRead.ayatNomor}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.onPrimary.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: AppColors.onPrimary,
                      size: AppDimens.iconSM,
                    ),
                  ],
                ),
              ),
              // Progress bar — hanya tampil jika totalAyat > 0
              if (lastRead.totalAyat > 0)
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(AppDimens.radiusMD),
                    bottomRight: Radius.circular(AppDimens.radiusMD),
                  ),
                  child: LinearProgressIndicator(
                    value: lastRead.scrollPercent,
                    minHeight: 4,
                    backgroundColor: AppColors.onPrimary.withValues(alpha: 0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.onPrimary,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
