import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/core/theme/cubit/theme_cubit.dart';
import 'package:equran_app/core/utils/failure_extension.dart';
import 'package:equran_app/core/widgets/app_drawer.dart';
import 'package:equran_app/core/widgets/app_search_bar.dart';
import 'package:equran_app/core/widgets/empty_state_widget.dart';
import 'package:equran_app/core/widgets/error_state_widget.dart';
import 'package:equran_app/core/widgets/loading_widget.dart';
import 'package:equran_app/core/widgets/section_header.dart';
import 'package:equran_app/features/bookmark/presentation/cubit/bookmark_cubit.dart';
import 'package:equran_app/features/bookmark/presentation/widgets/last_read_card.dart';
import 'package:equran_app/features/doa/presentation/widgets/doa_quick_actions_widget.dart';
import 'package:equran_app/features/hafalan/presentation/cubit/hafalan_cubit.dart';
import 'package:equran_app/features/quran_reminder/presentation/cubit/quran_streak_cubit.dart';
import 'package:equran_app/features/surat_list/presentation/cubit/surat_list_cubit.dart';
import 'package:equran_app/features/surat_list/presentation/widgets/murajaah_reminder_card.dart';
import 'package:equran_app/features/surat_list/presentation/widgets/search_bar_delegate.dart';
import 'package:equran_app/features/surat_list/presentation/widgets/streak_chip.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: _SuratListAppBar(l10n: l10n, isDark: isDark),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: context.read<SuratListCubit>().refresh,
        child: CustomScrollView(
          slivers: [
            // Header section
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Last Read Card
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

                  // Muraja'ah reminder card
                  BlocBuilder<HafalanCubit, HafalanState>(
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
                      return MurajaahReminderCard(
                        suratList: murajaahList,
                        onTap: () => context.push('/hafalan'),
                      );
                    },
                  ),

                  // Streak chip
                  BlocBuilder<QuranStreakCubit, int>(
                    buildWhen: (prev, curr) => prev != curr,
                    builder: (context, streak) {
                      if (streak == 0) return const SizedBox.shrink();
                      return StreakChip(streak: streak);
                    },
                  ),

                  // Doa Quick Actions
                  const DoaQuickActionsWidget(),

                  // Section header "Daftar Surah"
                  SectionHeader(
                    label: 'Daftar Surah',
                    trailing: Text(
                      '114 Surah',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: isDark
                            ? AppColors.onSurfaceDarkVariant
                            : AppColors.textTertiary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Sticky search bar
            SliverPersistentHeader(
              pinned: true,
              delegate: SearchBarDelegate(
                child: AppSearchBar(
                  hint: 'Cari surah...',
                  onChanged: context.read<SuratListCubit>().onQueryChanged,
                ),
              ),
            ),

            // Surat list
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

// ── AppBar ────────────────────────────────────────────────────────────────────

class _SuratListAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _SuratListAppBar({required this.l10n, required this.isDark});

  final AppLocalizations l10n;
  final bool isDark;

  @override
  Size get preferredSize => const Size.fromHeight(AppDimens.appBarHeightLG);

  @override
  Widget build(BuildContext context) {
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;
    final contentColor = isDark
        ? AppColors.onSurfaceDark
        : AppColors.textPrimary;

    return AppBar(
      backgroundColor: surfaceColor,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      shadowColor: AppColors.outline,
      surfaceTintColor: Colors.transparent,
      toolbarHeight: AppDimens.appBarHeightLG,
      leading: Builder(
        builder: (ctx) => IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: () => Scaffold.of(ctx).openDrawer(),
        ),
      ),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'eQuran',
            style: AppTypography.serifHeadingMedium.copyWith(
              color: contentColor,
              height: 1,
            ),
          ),
          const SizedBox(height: 2),
          Container(
            width: 24,
            height: 1.5,
            decoration: BoxDecoration(
              color: AppColors.gold,
              borderRadius: BorderRadius.circular(AppDimens.radiusFull),
            ),
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themeState) => IconButton(
            tooltip: themeState.map(
              light: (_) => l10n.darkMode,
              dark: (_) => l10n.lightMode,
            ),
            icon: Icon(
              themeState.map(
                light: (_) => Icons.dark_mode_outlined,
                dark: (_) => Icons.light_mode_outlined,
              ),
              color: contentColor,
            ),
            onPressed: () => context.read<ThemeCubit>().cycle(),
          ),
        ),
        IconButton(
          tooltip: l10n.settings,
          icon: Icon(Icons.settings_outlined, color: contentColor),
          onPressed: () => context.push('/settings'),
        ),
      ],
    );
  }
}

// ── Surat list content ────────────────────────────────────────────────────────

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

    final lastRead = context.watch<BookmarkCubit>().state.mapOrNull(
      success: (s) => s.lastRead,
    );

    return SliverPadding(
      padding: const EdgeInsets.only(
        left: AppDimens.pagePadding,
        right: AppDimens.pagePadding,
        bottom: AppDimens.spaceLG,
      ),
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
