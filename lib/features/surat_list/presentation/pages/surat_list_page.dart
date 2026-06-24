import 'dart:async';

import 'package:equran_app/core/constants/quran_constants.dart';
import 'package:equran_app/core/router/app_routes.dart';
import 'package:equran_app/core/utils/failure_extension.dart';
import 'package:equran_app/core/widgets/app_drawer.dart';
import 'package:equran_app/core/widgets/app_search_bar.dart';
import 'package:equran_app/core/widgets/error_state_widget.dart';
import 'package:equran_app/core/widgets/loading_widget.dart';
import 'package:equran_app/core/widgets/section_header.dart';
import 'package:equran_app/features/bookmark/presentation/cubit/bookmark_cubit.dart';
import 'package:equran_app/features/bookmark/presentation/widgets/last_read_card.dart';
import 'package:equran_app/features/doa/presentation/widgets/doa_quick_actions_widget.dart';
import 'package:equran_app/features/hafalan/presentation/cubit/hafalan_list_cubit.dart';
import 'package:equran_app/features/hafalan/presentation/cubit/hafalan_list_state.dart';
import 'package:equran_app/features/quran_reminder/presentation/cubit/quran_streak_cubit.dart';
import 'package:equran_app/features/quran_reminder/presentation/widgets/streak_badge_slot.dart';
import 'package:equran_app/features/surat_list/presentation/cubit/surat_list_cubit.dart';
import 'package:equran_app/features/surat_list/presentation/widgets/murajaah_reminder_card.dart';
import 'package:equran_app/features/surat_list/presentation/widgets/search_bar_delegate.dart';
import 'package:equran_app/features/surat_list/presentation/widgets/streak_chip.dart';
import 'package:equran_app/features/surat_list/presentation/widgets/surat_list_app_bar.dart';
import 'package:equran_app/features/surat_list/presentation/widgets/surat_list_content.dart';
import 'package:equran_app/injection/injection_container.dart';
import 'package:equran_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SuratListPage extends StatelessWidget {
  const SuratListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = getIt<SuratListCubit>();
        unawaited(cubit.load());
        return cubit;
      },
      child: const _SuratListView(),
    );
  }
}

class _SuratListView extends StatelessWidget {
  const _SuratListView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(streakBadge: StreakBadgeSlot()),
      appBar: const SuratListAppBar(),
      body: RefreshIndicator(
        onRefresh: context.read<SuratListCubit>().refresh,
        child: CustomScrollView(
          slivers: [
            const _SuratListHeader(),

            SliverPersistentHeader(
              pinned: true,
              delegate: SearchBarDelegate(
                child: AppSearchBar(
                  hint: AppLocalizations.of(context)!.searchHint,
                  onChanged: context.read<SuratListCubit>().onQueryChanged,
                ),
              ),
            ),

            BlocBuilder<SuratListCubit, SuratListState>(
              builder: (context, state) => switch (state) {
                SuratListInitial() => const SliverToBoxAdapter(
                  child: SizedBox.shrink(),
                ),
                SuratListLoading() => const SliverFillRemaining(
                  hasScrollBody: false,
                  child: LoadingWidget(),
                ),
                SuratListSuccess() => SuratListContent(
                  surats: state.filtered,
                  suratProgressMap:
                      context.watch<BookmarkCubit>().state.mapOrNull(
                        success: (s) => s.suratProgressMap,
                      ) ??
                      const <int, double>{},
                ),
                SuratListFailure(:final failure) => SliverFillRemaining(
                  hasScrollBody: false,
                  child: ErrorStateWidget(
                    message: failure.toUserMessage(),
                    onRetry: context.read<SuratListCubit>().retry,
                  ),
                ),
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SuratListHeader extends StatelessWidget {
  const _SuratListHeader();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<BookmarkCubit, BookmarkState>(
            buildWhen: (prev, curr) =>
                prev.mapOrNull(success: (s) => s.lastRead) !=
                curr.mapOrNull(success: (s) => s.lastRead),
            builder: (context, state) {
              final lastRead = state.mapOrNull(
                success: (s) => s.lastRead,
              );
              if (lastRead == null) return const SizedBox.shrink();
              return LastReadCard(lastRead: lastRead);
            },
          ),

          BlocBuilder<HafalanListCubit, HafalanListState>(
            buildWhen: (prev, curr) {
              final prevList = prev is HafalanListSuccess
                  ? prev.suratMurajaahHariIni
                  : null;
              final currList = curr is HafalanListSuccess
                  ? curr.suratMurajaahHariIni
                  : null;
              return prevList != currList;
            },
            builder: (context, state) {
              if (state is! HafalanListSuccess) {
                return const SizedBox.shrink();
              }
              final murajaahList = state.suratMurajaahHariIni;
              if (murajaahList.isEmpty) {
                return const SizedBox.shrink();
              }
              return MurajaahReminderCard(
                suratList: murajaahList,
                onTap: () {
                  unawaited(context.push(AppRoutes.hafalan));
                },
              );
            },
          ),

          BlocBuilder<QuranStreakCubit, QuranStreakState>(
            buildWhen: (prev, curr) => prev != curr,
            builder: (context, state) {
              final streak = state.mapOrNull(loaded: (s) => s.streak) ?? 0;
              if (streak == 0) return const SizedBox.shrink();
              return StreakChip(streak: streak);
            },
          ),

          const DoaQuickActionsWidget(),

          SectionHeader(
            label: l10n.suratListHeader,
            trailing: Text(
              l10n.totalSurat(QuranConstants.totalSurat),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
