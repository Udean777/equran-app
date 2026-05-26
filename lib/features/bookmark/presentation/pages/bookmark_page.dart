import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/core/utils/failure_extension.dart';
import 'package:equran_app/core/widgets/empty_state_widget.dart';
import 'package:equran_app/core/widgets/error_state_widget.dart';
import 'package:equran_app/core/widgets/loading_widget.dart';
import 'package:equran_app/features/bookmark/domain/entities/bookmark.dart';
import 'package:equran_app/features/bookmark/domain/entities/last_read.dart';
import 'package:equran_app/features/bookmark/presentation/cubit/bookmark_cubit.dart';
import 'package:equran_app/features/bookmark/presentation/widgets/bookmark_card.dart';
import 'package:equran_app/features/bookmark/presentation/widgets/last_read_card.dart';
import 'package:equran_app/features/doa/domain/entities/doa.dart';
import 'package:equran_app/features/doa/presentation/widgets/doa_card.dart';
import 'package:equran_app/injection/injection_container.dart';
import 'package:equran_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BookmarkPage extends StatelessWidget {
  const BookmarkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = getIt<BookmarkCubit>();
        unawaited(cubit.load());
        return cubit;
      },
      child: const _BookmarkView(),
    );
  }
}

class _BookmarkView extends StatelessWidget {
  const _BookmarkView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;
    final iconColor = isDark ? AppColors.onSurfaceDark : AppColors.textPrimary;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.background,
      appBar: AppBar(
        backgroundColor: surfaceColor,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: AppDimens.appBarHeightLG,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: iconColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.bookmark,
              style: AppTypography.serifHeadingMedium.copyWith(
                color: iconColor,
                height: 1,
                fontSize: 20,
              ),
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
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<BookmarkCubit, BookmarkState>(
        builder: (context, state) => switch (state) {
          BookmarkInitial() => const SizedBox.shrink(),
          BookmarkLoading() => const LoadingWidget(),
          BookmarkSuccess(:final bookmarks, :final bookmarkedDoas, :final lastRead) =>
            _BookmarkContent(
              bookmarks: bookmarks,
              bookmarkedDoas: bookmarkedDoas,
              lastRead: lastRead,
            ),
          BookmarkFailure(:final failure) => ErrorStateWidget(
            message: failure.toUserMessage(),
            onRetry: context.read<BookmarkCubit>().load,
          ),
        },
      ),
    );
  }
}

class _BookmarkContent extends StatelessWidget {
  const _BookmarkContent({
    required this.bookmarks,
    required this.bookmarkedDoas,
    required this.lastRead,
  });

  final List<Bookmark> bookmarks;
  final List<Doa> bookmarkedDoas;
  final LastRead? lastRead;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (bookmarks.isEmpty && bookmarkedDoas.isEmpty && lastRead == null) {
      return EmptyStateWidget(
        message: l10n.bookmarkEmpty,
        icon: Icons.bookmark_border_rounded,
      );
    }

    return ListView(
      padding: const EdgeInsets.only(bottom: AppDimens.spaceXL),
      children: [
        if (lastRead != null) LastReadCard(lastRead: lastRead!),
        if (bookmarks.isNotEmpty) ...[
          _SectionHeader(
            title: l10n.ayatTersimpan,
            icon: Icons.bookmark_rounded,
            isDark: isDark,
          ),
          ...bookmarks.map(
            (b) => BookmarkCard(
              key: ValueKey('${b.suratNomor}_${b.ayatNomor}'),
              bookmark: b,
              onTap: () => context.push(
                '/surat/${b.suratNomor}?ayat=${b.ayatNomor}',
              ),
              onRemove: () => context.read<BookmarkCubit>().removeBookmark(
                suratNomor: b.suratNomor,
                ayatNomor: b.ayatNomor,
              ),
            ),
          ),
        ],
        if (bookmarkedDoas.isNotEmpty) ...[
          _SectionHeader(
            title: l10n.doaTersimpan,
            icon: Icons.menu_book_rounded,
            isDark: isDark,
          ),
          ...bookmarkedDoas.map(
            (doa) => DoaCard(
              key: ValueKey(doa.id),
              doa: doa,
              onTap: () => context.push('/doa/${doa.id}'),
              onRemove: () =>
                  context.read<BookmarkCubit>().removeDoaBookmark(doa.id),
            ),
          ),
        ],
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.icon,
    required this.isDark,
  });

  final String title;
  final IconData icon;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.pagePadding,
        AppDimens.spaceMD,
        AppDimens.pagePadding,
        AppDimens.spaceXS,
      ),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 16,
            decoration: BoxDecoration(
              color: AppColors.gold,
              borderRadius: BorderRadius.circular(AppDimens.radiusFull),
            ),
          ),
          const SizedBox(width: AppDimens.spaceSM),
          Icon(
            icon,
            size: AppDimens.iconSM,
            color: isDark ? AppColors.primaryLighter : AppColors.primary,
          ),
          const SizedBox(width: AppDimens.spaceXS),
          Text(
            title,
            style: AppTypography.serifHeadingSmall.copyWith(
              color: isDark ? AppColors.onSurfaceDark : AppColors.textPrimary,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
