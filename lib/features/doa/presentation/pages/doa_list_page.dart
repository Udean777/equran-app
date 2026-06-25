import 'dart:async';

import 'package:equran_app/core/router/app_routes.dart';
import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/utils/bottom_sheet_utils.dart';
import 'package:equran_app/core/utils/failure_extension.dart';
import 'package:equran_app/core/widgets/app_drawer.dart';
import 'package:equran_app/core/widgets/app_search_bar.dart';
import 'package:equran_app/core/widgets/empty_state_widget.dart';
import 'package:equran_app/core/widgets/error_state_widget.dart';
import 'package:equran_app/core/widgets/loading_widget.dart';
import 'package:equran_app/features/doa/presentation/providers.dart';
import 'package:equran_app/features/doa/presentation/widgets/active_filter_chip.dart';
import 'package:equran_app/features/doa/presentation/widgets/doa_card.dart';
import 'package:equran_app/features/doa/presentation/widgets/doa_filter_sheet.dart';
import 'package:equran_app/features/doa/presentation/widgets/doa_list_app_bar.dart';
import 'package:equran_app/features/quran_reminder/presentation/widgets/streak_badge_slot.dart';
import 'package:equran_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DoaListPage extends ConsumerStatefulWidget {
  const DoaListPage({super.key});

  @override
  ConsumerState<DoaListPage> createState() => _DoaListPageState();
}

class _DoaListPageState extends ConsumerState<DoaListPage> {
  bool _searchVisible = false;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    unawaited(ref.read(doaListViewModelProvider.notifier).load());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _searchVisible = !_searchVisible;
      if (!_searchVisible) {
        _searchController.clear();
        ref.read(doaListViewModelProvider.notifier).search('');
      }
    });
  }

  void _showFilterSheet() {
    unawaited(
      showAppBottomSheet<void>(
        context,
        builder: (_) => const DoaFilterSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final canPop = Navigator.canPop(context);

    final state = ref.watch(doaListViewModelProvider);
    final hasActiveFilter =
        state.mapOrNull(success: (s) => s.hasActiveFilter) ?? false;
    final activeFilterLabel =
        state.mapOrNull(success: (s) => s.activeFilterLabel) ?? '';

    return Scaffold(
      drawer: canPop ? null : const AppDrawer(streakBadge: StreakBadgeSlot()),
      appBar: DoaListAppBar(
        l10n: l10n,
        canPop: canPop,
        searchVisible: _searchVisible,
        hasActiveFilter: hasActiveFilter,
        onToggleSearch: _toggleSearch,
        onFilter: _showFilterSheet,
      ),
      body: Column(
        children: [
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            child: _searchVisible
                ? AppSearchBar(
                    controller: _searchController,
                    hint: l10n.searchDoa,
                    autofocus: true,
                    onChanged: ref
                        .read(doaListViewModelProvider.notifier)
                        .search,
                  )
                : const SizedBox.shrink(),
          ),

          if (hasActiveFilter)
            ActiveFilterChip(
              label: activeFilterLabel,
              onClear: ref.read(doaListViewModelProvider.notifier).clearFilter,
            ),

          Expanded(
            child: switch (state) {
              DoaListInitial() => const SizedBox.shrink(),
              DoaListLoading() => const LoadingWidget(),
              DoaListSuccess() => _DoaListContent(state: state),
              DoaListFailure(:final failure) => ErrorStateWidget(
                message: failure.toUserMessage(),
                onRetry: ref.read(doaListViewModelProvider.notifier).retry,
              ),
            },
          ),
        ],
      ),
    );
  }
}

class _DoaListContent extends ConsumerWidget {
  const _DoaListContent({required this.state});

  final DoaListSuccess state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final doaList = state.filtered;

    if (doaList.isEmpty) {
      return EmptyStateWidget(message: l10n.noDoaFound);
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: ref.read(doaListViewModelProvider.notifier).refresh,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(
          AppDimens.pagePadding,
          AppDimens.spaceSM,
          AppDimens.pagePadding,
          AppDimens.spaceLG,
        ),
        itemCount: doaList.length,
        itemBuilder: (_, i) => DoaCard(
          key: ValueKey(doaList[i].id),
          doa: doaList[i],
          onTap: () => context.push(AppRoutes.doa(doaList[i].id)),
        ),
      ),
    );
  }
}
