import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/cubit/theme_cubit.dart';
import 'package:equran_app/core/utils/failure_extension.dart';
import 'package:equran_app/core/widgets/app_drawer.dart';
import 'package:equran_app/core/widgets/empty_state_widget.dart';
import 'package:equran_app/core/widgets/error_state_widget.dart';
import 'package:equran_app/core/widgets/loading_widget.dart';
import 'package:equran_app/features/bookmark/presentation/cubit/bookmark_cubit.dart';
import 'package:equran_app/features/bookmark/presentation/widgets/last_read_card.dart';
import 'package:equran_app/features/doa/presentation/widgets/doa_quick_actions_widget.dart';
import 'package:equran_app/features/hafalan/domain/entities/hafalan_surat.dart';
import 'package:equran_app/features/hafalan/presentation/cubit/hafalan_cubit.dart';
import 'package:equran_app/features/quran_reminder/presentation/cubit/quran_streak_cubit.dart';
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
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: Text(l10n.appTitle),
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu_rounded),
            tooltip: 'Menu',
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        actions: [
          BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, themeState) => IconButton(
              tooltip: themeState.map(
                light: (_) => l10n.darkMode,
                dark: (_) => 'Mode Sepia',
                sepia: (_) => l10n.lightMode,
              ),
              icon: Icon(
                themeState.map(
                  light: (_) => Icons.dark_mode_rounded,
                  dark: (_) => Icons.auto_stories_rounded,
                  sepia: (_) => Icons.light_mode_rounded,
                ),
              ),
              onPressed: () => context.read<ThemeCubit>().cycle(),
            ),
          ),
          IconButton(
            tooltip: l10n.settings,
            icon: const Icon(Icons.settings_rounded),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: context.read<SuratListCubit>().refresh,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  // Last Read Card
                  BlocBuilder<BookmarkCubit, BookmarkState>(
                    // Hanya rebuild jika lastRead berubah
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
                  // Muraja'ah reminder card
                  BlocBuilder<HafalanCubit, HafalanState>(
                    // Hanya rebuild jika suratMurajaahHariIni berubah
                    buildWhen: (prev, curr) {
                      final prevList = prev is HafalanSuccess
                          ? prev.suratMurajaahHariIni
                          : null;
                      final currList = curr is HafalanSuccess
                          ? curr.suratMurajaahHariIni
                          : null;
                      return prevList != currList;
                    },
                    builder: (context, state) {
                      if (state is! HafalanSuccess) {
                        return const SizedBox.shrink();
                      }
                      final murajaahList = state.suratMurajaahHariIni;
                      if (murajaahList.isEmpty) return const SizedBox.shrink();
                      return _MurajaahReminderCard(suratList: murajaahList);
                    },
                  ),
                  // Streak chip
                  BlocBuilder<QuranStreakCubit, int>(
                    // Hanya rebuild jika streak count berubah
                    buildWhen: (prev, curr) => prev != curr,
                    builder: (context, streak) {
                      if (streak == 0) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimens.spaceMD,
                          vertical: AppDimens.spaceXS,
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppDimens.spaceSM,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(
                                  AppDimens.radiusFull,
                                ),
                                border: Border.all(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.3,
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.local_fire_department_rounded,
                                    color: Colors.orange,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '$streak hari berturut-turut',
                                    style: const TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  // Doa Quick Actions — 2 doa relevan berdasarkan waktu
                  const DoaQuickActionsWidget(),
                ],
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SearchBarDelegate(
                child: SearchBarWidget(
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
                SuratListSuccess() => _SuratListContent(state: state),
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

class _SuratListContent extends StatelessWidget {
  const _SuratListContent({required this.state});

  final SuratListSuccess state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final surats = state.filtered;

    if (surats.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: EmptyStateWidget(message: l10n.emptySearch),
      );
    }

    // Ambil lastRead untuk tampilkan progress bar di surat yang sedang dibaca
    final lastRead = context.watch<BookmarkCubit>().state.mapOrNull(
      success: (s) => s.lastRead,
    );

    return SliverPadding(
      padding: const EdgeInsets.only(bottom: 16),
      sliver: SliverList.builder(
        itemCount: surats.length,
        itemBuilder: (_, i) {
          final surat = surats[i];
          final isLastRead =
              lastRead != null && lastRead.suratNomor == surat.nomor;
          return SuratCard(
            key: ValueKey(surat.nomor),
            surat: surat,
            onTap: () => context.push('/surat/${surat.nomor}'),
            onPlayTap: () =>
                context.push('/surat/${surat.nomor}?autoPlay=true'),
            scrollPercent: isLastRead ? lastRead.scrollPercent : null,
          );
        },
      ),
    );
  }
}

class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  _SearchBarDelegate({required this.child});

  final Widget child;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final isPinned = shrinkOffset > 0 || overlapsContent;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: isPinned
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: child,
    );
  }

  @override
  double get maxExtent => 72;

  @override
  double get minExtent => 72;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

// ─── Muraja'ah Reminder Card ──────────────────────────────────────────────────

class _MurajaahReminderCard extends StatelessWidget {
  const _MurajaahReminderCard({required this.suratList});

  final List<HafalanSurat> suratList;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final names = suratList.take(3).map((s) => s.namaLatin).join(', ');
    final extra = suratList.length > 3 ? ' +${suratList.length - 3}' : '';

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.spaceMD,
        AppDimens.spaceXS,
        AppDimens.spaceMD,
        AppDimens.spaceXS,
      ),
      child: InkWell(
        onTap: () => context.push('/hafalan'),
        borderRadius: BorderRadius.circular(AppDimens.radiusMD),
        child: Container(
          padding: const EdgeInsets.all(AppDimens.spaceMD),
          decoration: BoxDecoration(
            color: AppColors.error.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppDimens.radiusMD),
            border: Border.all(
              color: AppColors.error.withValues(alpha: 0.25),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimens.spaceSM),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppDimens.radiusSM),
                ),
                child: const Icon(
                  Icons.refresh_rounded,
                  color: AppColors.error,
                  size: AppDimens.iconMD,
                ),
              ),
              const SizedBox(width: AppDimens.spaceMD),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Muraja'ah Hari Ini",
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: AppColors.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$names$extra',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.error.withValues(alpha: 0.8),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.error.withValues(alpha: 0.6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
