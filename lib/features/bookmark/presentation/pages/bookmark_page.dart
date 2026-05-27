import 'dart:async';

import 'package:equran_app/core/router/app_routes.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/utils/failure_extension.dart';
import 'package:equran_app/core/widgets/empty_state_widget.dart';
import 'package:equran_app/core/widgets/error_state_widget.dart';
import 'package:equran_app/core/widgets/loading_widget.dart';
import 'package:equran_app/core/widgets/luxury_app_bar.dart';
import 'package:equran_app/core/widgets/section_header.dart';
import 'package:equran_app/features/bookmark/presentation/cubit/bookmark_cubit.dart';
import 'package:equran_app/features/bookmark/presentation/widgets/bookmark_card.dart';
import 'package:equran_app/features/bookmark/presentation/widgets/last_read_card.dart';
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

    return Scaffold(
      appBar: const LuxuryAppBar(title: 'Bookmark'),
      body: BlocBuilder<BookmarkCubit, BookmarkState>(
        builder: (context, state) => switch (state) {
          BookmarkInitial() => const LoadingWidget(),
          BookmarkLoading() => const LoadingWidget(),
          BookmarkFailure(:final failure) => ErrorStateWidget(
            message: failure.toUserMessage(),
            onRetry: context.read<BookmarkCubit>().load,
          ),
          BookmarkSuccess() => _BookmarkContent(state: state, l10n: l10n),
        },
      ),
    );
  }
}

class _BookmarkContent extends StatelessWidget {
  const _BookmarkContent({required this.state, required this.l10n});

  final BookmarkSuccess state;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final lastRead = state.lastRead;
    final bookmarks = state.bookmarks;
    final doaBookmarks = state.bookmarkedDoas;

    final isEmpty =
        lastRead == null && bookmarks.isEmpty && doaBookmarks.isEmpty;

    if (isEmpty) {
      return EmptyStateWidget(message: l10n.bookmarkEmpty);
    }

    return ListView(
      children: [
        // Terakhir Dibaca
        if (lastRead != null) ...[
          const SectionHeader(label: 'Terakhir Dibaca'),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.pagePadding,
            ),
            child: LastReadCard(lastRead: lastRead),
          ),
        ],

        // Bookmark Ayat
        if (bookmarks.isNotEmpty) ...[
          const SectionHeader(label: 'Bookmark Ayat'),
          ...bookmarks.map(
            (b) => Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.pagePadding,
                vertical: AppDimens.spaceXS,
              ),
              child: BookmarkCard(
                bookmark: b,
                onTap: () => context.push(
                  AppRoutes.suratWithAyat(b.suratNomor, b.ayatNomor),
                ),
                onRemove: () => context.read<BookmarkCubit>().removeBookmark(
                  suratNomor: b.suratNomor,
                  ayatNomor: b.ayatNomor,
                ),
              ),
            ),
          ),
        ],

        // Bookmark Doa
        if (doaBookmarks.isNotEmpty) ...[
          const SectionHeader(label: 'Bookmark Doa'),
          ...doaBookmarks.map(
            (d) => Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.pagePadding,
                vertical: AppDimens.spaceXS,
              ),
              child: DoaCard(
                doa: d,
                onTap: () => context.push(AppRoutes.doa(d.id)),
              ),
            ),
          ),
        ],

        const SizedBox(height: AppDimens.spaceXL),
      ],
    );
  }
}
