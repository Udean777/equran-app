import 'dart:async';

import 'package:equran_app/core/router/app_routes.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/utils/failure_extension.dart';
import 'package:equran_app/core/widgets/empty_state_widget.dart';
import 'package:equran_app/core/widgets/error_state_widget.dart';
import 'package:equran_app/core/widgets/loading_widget.dart';
import 'package:equran_app/core/widgets/luxury_app_bar.dart';
import 'package:equran_app/core/widgets/section_header.dart';
import 'package:equran_app/features/bookmark/domain/entities/bookmark.dart';
import 'package:equran_app/features/bookmark/domain/entities/last_read.dart';
import 'package:equran_app/features/bookmark/presentation/providers.dart';
import 'package:equran_app/features/bookmark/presentation/widgets/bookmark_card.dart';
import 'package:equran_app/features/bookmark/presentation/widgets/last_read_card.dart';
import 'package:equran_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BookmarkPage extends ConsumerStatefulWidget {
  const BookmarkPage({super.key, this.doaSectionBuilder});

  final Widget Function(ValueChanged<bool>)? doaSectionBuilder;

  @override
  ConsumerState<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends ConsumerState<BookmarkPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(ref.read(bookmarkViewModelProvider.notifier).load());
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookmarkViewModelProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: LuxuryAppBar(title: l10n.bookmark),
      body: state.when(
        initial: () => const LoadingWidget(),
        loading: () => const LoadingWidget(),
        failure: (failure) => ErrorStateWidget(
          message: failure.toUserMessage(),
          onRetry: () => ref.read(bookmarkViewModelProvider.notifier).load(),
        ),
        success: (bookmarks, lastRead, suratProgressMap) => _BookmarkContent(
          bookmarks: bookmarks,
          lastRead: lastRead,
          l10n: l10n,
          doaSectionBuilder: widget.doaSectionBuilder,
        ),
      ),
    );
  }
}

class _BookmarkContent extends ConsumerWidget {
  const _BookmarkContent({
    required this.bookmarks,
    required this.lastRead,
    required this.l10n,
    this.doaSectionBuilder,
  });

  final List<Bookmark> bookmarks;
  final LastRead? lastRead;
  final AppLocalizations l10n;
  final Widget Function(ValueChanged<bool>)? doaSectionBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEmpty = lastRead == null && bookmarks.isEmpty;

    if (isEmpty && doaSectionBuilder == null) {
      return EmptyStateWidget(message: l10n.bookmarkEmpty);
    }

    return _BookmarkContentBody(
      bookmarks: bookmarks,
      lastRead: lastRead,
      l10n: l10n,
      doaSectionBuilder: doaSectionBuilder,
    );
  }
}

class _BookmarkContentBody extends StatefulWidget {
  const _BookmarkContentBody({
    required this.bookmarks,
    required this.lastRead,
    required this.l10n,
    this.doaSectionBuilder,
  });

  final List<Bookmark> bookmarks;
  final LastRead? lastRead;
  final AppLocalizations l10n;
  final Widget Function(ValueChanged<bool>)? doaSectionBuilder;

  @override
  State<_BookmarkContentBody> createState() => _BookmarkContentBodyState();
}

class _BookmarkContentBodyState extends State<_BookmarkContentBody> {
  var _isDoaSectionEmpty = true;

  @override
  Widget build(BuildContext context) {
    final lastRead = widget.lastRead;
    final bookmarks = widget.bookmarks;
    final isEmpty = lastRead == null && bookmarks.isEmpty && _isDoaSectionEmpty;

    if (isEmpty) {
      return EmptyStateWidget(message: widget.l10n.bookmarkEmpty);
    }

    return ListView(
      children: [
        if (lastRead != null) ...[
          SectionHeader(label: widget.l10n.lastRead),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.pagePadding,
            ),
            child: LastReadCard(lastRead: lastRead),
          ),
        ],

        if (bookmarks.isNotEmpty) ...[
          SectionHeader(label: widget.l10n.ayatTersimpan),
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
                onRemove: () => ProviderScope.containerOf(context)
                    .read(bookmarkViewModelProvider.notifier)
                    .removeBookmark(
                      suratNomor: b.suratNomor,
                      ayatNomor: b.ayatNomor,
                    ),
              ),
            ),
          ),
        ],

        if (widget.doaSectionBuilder != null) ...[
          widget.doaSectionBuilder!((isEmpty) {
            if (_isDoaSectionEmpty != isEmpty) {
              setState(() => _isDoaSectionEmpty = isEmpty);
            }
          }),
        ],

        const SizedBox(height: AppDimens.spaceXL),
      ],
    );
  }
}
