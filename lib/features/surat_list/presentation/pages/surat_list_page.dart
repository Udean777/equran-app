import 'dart:async';

import 'package:equran_app/core/theme/cubit/theme_cubit.dart';
import 'package:equran_app/core/utils/failure_extension.dart';
import 'package:equran_app/core/widgets/empty_state_widget.dart';
import 'package:equran_app/core/widgets/error_state_widget.dart';
import 'package:equran_app/core/widgets/loading_widget.dart';
import 'package:equran_app/features/bookmark/presentation/cubit/bookmark_cubit.dart';
import 'package:equran_app/features/bookmark/presentation/widgets/last_read_card.dart';
import 'package:equran_app/features/surat_list/presentation/cubit/surat_list_cubit.dart';
import 'package:equran_app/features/surat_list/presentation/widgets/search_bar_widget.dart';
import 'package:equran_app/features/surat_list/presentation/widgets/surat_card.dart';
import 'package:equran_app/injection/injection_container.dart';
import 'package:equran_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SuratListPage extends StatelessWidget {
  const SuratListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            final cubit = getIt<SuratListCubit>();
            unawaited(cubit.load());
            return cubit;
          },
        ),
        BlocProvider(
          create: (_) {
            final cubit = getIt<BookmarkCubit>();
            unawaited(cubit.load());
            return cubit;
          },
        ),
      ],
      child: const _SuratListView(),
    );
  }
}

class _SuratListView extends StatelessWidget {
  const _SuratListView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, themeState) => IconButton(
              tooltip: themeState.isDark ? l10n.lightMode : l10n.darkMode,
              icon: Icon(
                themeState.isDark
                    ? Icons.light_mode_rounded
                    : Icons.dark_mode_rounded,
              ),
              onPressed: context.read<ThemeCubit>().toggle,
            ),
          ),
          IconButton(
            tooltip: l10n.settings,
            icon: const Icon(Icons.settings_rounded),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Last Read Card
          BlocBuilder<BookmarkCubit, BookmarkState>(
            builder: (context, state) {
              final lastRead = state.mapOrNull(success: (s) => s.lastRead);
              if (lastRead == null) return const SizedBox.shrink();
              return LastReadCard(lastRead: lastRead);
            },
          ),
          SearchBarWidget(
            onChanged: context.read<SuratListCubit>().onQueryChanged,
          ),
          Expanded(
            child: BlocBuilder<SuratListCubit, SuratListState>(
              builder: (context, state) => switch (state) {
                SuratListInitial() => const SizedBox.shrink(),
                SuratListLoading() => const LoadingWidget(),
                SuratListSuccess() => _SuratListContent(state: state),
                SuratListFailure(:final failure) => ErrorStateWidget(
                  message: failure.toUserMessage(),
                  onRetry: context.read<SuratListCubit>().retry,
                ),
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SuratListContent extends StatelessWidget {
  const _SuratListContent({required this.state});

  final SuratListSuccess state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final surats = state.filtered;

    if (surats.isEmpty) {
      return EmptyStateWidget(message: l10n.emptySearch);
    }

    return RefreshIndicator(
      onRefresh: context.read<SuratListCubit>().refresh,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 16),
        itemCount: surats.length,
        itemBuilder: (_, i) => SuratCard(
          key: ValueKey(surats[i].nomor),
          surat: surats[i],
          onTap: () => context.push('/surat/${surats[i].nomor}'),
        ),
      ),
    );
  }
}
