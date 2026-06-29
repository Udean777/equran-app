import 'dart:async';

import 'package:equran_app/core/constants/quran_constants.dart';
import 'package:equran_app/core/router/app_routes.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/utils/failure_extension.dart';
import 'package:equran_app/core/widgets/app_drawer.dart';
import 'package:equran_app/core/widgets/app_search_bar.dart';
import 'package:equran_app/core/widgets/error_state_widget.dart';
import 'package:equran_app/core/widgets/loading_widget.dart';
import 'package:equran_app/core/widgets/section_header.dart';
import 'package:equran_app/features/bookmark/presentation/providers.dart';
import 'package:equran_app/features/bookmark/presentation/widgets/last_read_card.dart';
import 'package:equran_app/features/doa/presentation/widgets/doa_quick_actions_widget.dart';
import 'package:equran_app/features/hafalan/presentation/providers.dart';
import 'package:equran_app/features/quran_reminder/presentation/providers.dart';
import 'package:equran_app/features/quran_reminder/presentation/widgets/streak_badge_slot.dart';
import 'package:equran_app/features/reading_progress/presentation/providers.dart';
import 'package:equran_app/features/reading_progress/presentation/widgets/reading_stats_header_card.dart';
import 'package:equran_app/features/surat_list/presentation/providers.dart';
import 'package:equran_app/features/surat_list/presentation/widgets/murajaah_reminder_card.dart';
import 'package:equran_app/features/surat_list/presentation/widgets/search_bar_delegate.dart';
import 'package:equran_app/features/surat_list/presentation/widgets/streak_chip.dart';
import 'package:equran_app/features/surat_list/presentation/widgets/surat_list_app_bar.dart';
import 'package:equran_app/features/surat_list/presentation/widgets/surat_list_content.dart';
import 'package:equran_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SuratListPage extends StatelessWidget {
  const SuratListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SuratListView();
  }
}

class _SuratListView extends ConsumerWidget {
  const _SuratListView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(suratListViewModelProvider);
    final notifier = ref.read(suratListViewModelProvider.notifier);

    return Scaffold(
      drawer: const AppDrawer(streakBadge: StreakBadgeSlot()),
      appBar: const SuratListAppBar(),
      body: RefreshIndicator(
        onRefresh: notifier.refresh,
        child: CustomScrollView(
          slivers: [
            const _SuratListHeader(),

            SliverPersistentHeader(
              pinned: true,
              delegate: SearchBarDelegate(
                child: AppSearchBar(
                  hint: AppLocalizations.of(context)!.searchHint,
                  onChanged: notifier.onQueryChanged,
                ),
              ),
            ),

            switch (state) {
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
                    ref
                        .watch(bookmarkViewModelProvider)
                        .mapOrNull(
                          success: (s) => s.suratProgressMap,
                        ) ??
                    const <int, double>{},
              ),
              SuratListFailure(:final failure) => SliverFillRemaining(
                hasScrollBody: false,
                child: ErrorStateWidget(
                  message: failure.toUserMessage(),
                  onRetry: notifier.retry,
                ),
              ),
            },
          ],
        ),
      ),
    );
  }
}

class _SuratListHeader extends ConsumerWidget {
  const _SuratListHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    final bookmarkState = ref.watch(bookmarkViewModelProvider);
    final lastRead = bookmarkState.mapOrNull(
      success: (s) => s.lastRead,
    );

    final hafalanState = ref.watch(hafalanListViewModelProvider);
    final murajaahList = hafalanState is HafalanListSuccess
        ? hafalanState.suratMurajaahHariIni
        : null;

    final readingProgressState = ref.watch(readingProgressViewModelProvider);
    final readingStats = readingProgressState.statsOrNull;

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (readingStats != null && (readingStats.totalAyatRead > 0 || readingStats.totalHariDenganData > 0))
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimens.pagePadding,
                AppDimens.spaceMD,
                AppDimens.pagePadding,
                AppDimens.spaceXS,
              ),
              child: GestureDetector(
                onTap: () => unawaited(context.push(AppRoutes.readingStats)),
                child: ReadingStatsHeaderCard(
                  stats: readingStats,
                  streak: ref.watch(quranStreakViewModelProvider).mapOrNull(loaded: (s) => s.streak) ?? 0,
                ),
              ),
            ),

          if (lastRead != null) LastReadCard(lastRead: lastRead),

          if (murajaahList != null && murajaahList.isNotEmpty)
            MurajaahReminderCard(
              suratList: murajaahList,
              onTap: () {
                unawaited(context.push(AppRoutes.hafalan));
              },
            ),

          const _StreakChipWidget(),

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

class _StreakChipWidget extends ConsumerWidget {
  const _StreakChipWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(quranStreakViewModelProvider);
    final streak = state.mapOrNull(loaded: (s) => s.streak) ?? 0;
    if (streak == 0) return const SizedBox.shrink();
    return StreakChip(streak: streak);
  }
}
