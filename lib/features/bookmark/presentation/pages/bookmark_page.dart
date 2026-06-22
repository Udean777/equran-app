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
import 'package:equran_app/injection/injection_container.dart';
import 'package:equran_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BookmarkPage extends StatelessWidget {
  const BookmarkPage({super.key, this.doaSectionBuilder});

  final Widget Function(ValueChanged<bool>)? doaSectionBuilder;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = getIt<BookmarkCubit>();
        unawaited(cubit.load());
        return cubit;
      },
      child: _BookmarkView(doaSectionBuilder: doaSectionBuilder),
    );
  }
}

class _BookmarkView extends StatelessWidget {
  const _BookmarkView({this.doaSectionBuilder});

  final Widget Function(ValueChanged<bool>)? doaSectionBuilder;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: LuxuryAppBar(title: l10n.bookmark),
      body: BlocBuilder<BookmarkCubit, BookmarkState>(
        builder: (context, state) => switch (state) {
          BookmarkInitial() => const LoadingWidget(),
          BookmarkLoading() => const LoadingWidget(),
          BookmarkFailure(:final failure) => ErrorStateWidget(
            message: failure.toUserMessage(),
            onRetry: context.read<BookmarkCubit>().load,
          ),
          BookmarkSuccess() => _BookmarkContent(
            state: state,
            l10n: l10n,
            doaSectionBuilder: doaSectionBuilder,
          ),
        },
      ),
    );
  }
}

class _BookmarkContent extends StatefulWidget {
  const _BookmarkContent({
    required this.state,
    required this.l10n,
    this.doaSectionBuilder,
  });

  final BookmarkSuccess state;
  final AppLocalizations l10n;
  final Widget Function(ValueChanged<bool>)? doaSectionBuilder;

  @override
  State<_BookmarkContent> createState() => _BookmarkContentState();
}

class _BookmarkContentState extends State<_BookmarkContent> {
  var _isDoaSectionEmpty = true;

  @override
  Widget build(BuildContext context) {
    final lastRead = widget.state.lastRead;
    final bookmarks = widget.state.bookmarks;
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
                onRemove: () => context.read<BookmarkCubit>().removeBookmark(
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
