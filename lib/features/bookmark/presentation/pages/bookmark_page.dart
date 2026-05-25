import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/utils/failure_extension.dart';
import 'package:equran_app/core/widgets/empty_state_widget.dart';
import 'package:equran_app/core/widgets/error_state_widget.dart';
import 'package:equran_app/core/widgets/loading_widget.dart';
import 'package:equran_app/features/bookmark/domain/entities/bookmark.dart';
import 'package:equran_app/features/bookmark/domain/entities/last_read.dart';
import 'package:equran_app/features/bookmark/presentation/cubit/bookmark_cubit.dart';
import 'package:equran_app/features/bookmark/presentation/widgets/bookmark_card.dart';
import 'package:equran_app/features/bookmark/presentation/widgets/last_read_card.dart';
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
      appBar: AppBar(
        title: Text(l10n.bookmark),
      ),
      body: BlocBuilder<BookmarkCubit, BookmarkState>(
        builder: (context, state) => switch (state) {
          BookmarkInitial() => const SizedBox.shrink(),
          BookmarkLoading() => const LoadingWidget(),
          BookmarkSuccess(:final bookmarks, :final lastRead) =>
            _BookmarkContent(bookmarks: bookmarks, lastRead: lastRead),
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
    required this.lastRead,
  });

  final List<Bookmark> bookmarks;
  final LastRead? lastRead;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (bookmarks.isEmpty && lastRead == null) {
      return EmptyStateWidget(
        message: l10n.bookmarkEmpty,
        icon: Icons.bookmark_border_rounded,
      );
    }

    return ListView(
      children: [
        if (lastRead != null) LastReadCard(lastRead: lastRead!),
        if (bookmarks.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimens.spaceMD,
              AppDimens.spaceMD,
              AppDimens.spaceMD,
              AppDimens.spaceXS,
            ),
            child: Text(
              l10n.ayatTersimpan,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
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
      ],
    );
  }
}
