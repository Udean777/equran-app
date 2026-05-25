import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/bookmark/domain/entities/bookmark.dart';
import 'package:flutter/material.dart';

class BookmarkCard extends StatelessWidget {
  const BookmarkCard({
    required this.bookmark,
    required this.onTap,
    required this.onRemove,
    super.key,
  });

  final Bookmark bookmark;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceMD,
        vertical: AppDimens.spaceXS,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.radiusMD),
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.cardPadding),
          child: Row(
            children: [
              // Bookmark icon
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.secondary,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.bookmark_rounded,
                  color: AppColors.onSecondary,
                  size: AppDimens.iconSM,
                ),
              ),
              const SizedBox(width: AppDimens.spaceMD),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${bookmark.namaLatin} • Ayat ${bookmark.ayatNomor}',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: AppDimens.spaceXS),
                    Text(
                      bookmark.teksArab,
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 16,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: AppDimens.spaceXS),
                    Text(
                      bookmark.teksIndonesia,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              // Remove button
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded),
                color: Colors.grey[400],
                onPressed: onRemove,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
