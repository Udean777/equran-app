import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/core/utils/bottom_sheet_utils.dart';
import 'package:equran_app/core/utils/failure_extension.dart';
import 'package:equran_app/core/widgets/app_drawer.dart';
import 'package:equran_app/core/widgets/empty_state_widget.dart';
import 'package:equran_app/core/widgets/error_state_widget.dart';
import 'package:equran_app/core/widgets/loading_widget.dart';
import 'package:equran_app/features/doa/presentation/cubit/doa_list_cubit.dart';
import 'package:equran_app/features/doa/presentation/widgets/doa_card.dart';
import 'package:equran_app/features/doa/presentation/widgets/doa_filter_sheet.dart';
import 'package:equran_app/injection/injection_container.dart';
import 'package:equran_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DoaListPage extends StatelessWidget {
  const DoaListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = getIt<DoaListCubit>();
        unawaited(cubit.load());
        return cubit;
      },
      child: const _DoaListView(),
    );
  }
}

class _DoaListView extends StatefulWidget {
  const _DoaListView();

  @override
  State<_DoaListView> createState() => _DoaListViewState();
}

class _DoaListViewState extends State<_DoaListView> {
  bool _searchVisible = false;
  final _searchController = TextEditingController();

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
        context.read<DoaListCubit>().search('');
      }
    });
  }

  void _showFilterSheet() {
    unawaited(
      showAppBottomSheet<void>(
        context,
        builder: (_) => BlocProvider.value(
          value: context.read<DoaListCubit>(),
          child: const DoaFilterSheet(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final canPop = Navigator.canPop(context);

    return Scaffold(
      drawer: canPop ? null : const AppDrawer(),
      appBar: _DoaListAppBar(
        l10n: l10n,
        isDark: isDark,
        canPop: canPop,
        searchVisible: _searchVisible,
        onToggleSearch: _toggleSearch,
        onFilter: _showFilterSheet,
      ),
      body: Column(
        children: [
          // Search bar collapsible
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            child: _searchVisible
                ? _DoaSearchBar(
                    controller: _searchController,
                    onChanged: context.read<DoaListCubit>().search,
                    hint: l10n.searchDoa,
                    isDark: isDark,
                  )
                : const SizedBox.shrink(),
          ),

          // Active filter chip
          BlocBuilder<DoaListCubit, DoaListState>(
            builder: (context, state) {
              final success = state.mapOrNull(success: (s) => s);
              if (success == null || !success.hasActiveFilter) {
                return const SizedBox.shrink();
              }
              return _ActiveFilterChip(
                label: success.activeFilterLabel,
                isDark: isDark,
                onClear: context.read<DoaListCubit>().clearFilter,
              );
            },
          ),

          // Content
          Expanded(
            child: BlocBuilder<DoaListCubit, DoaListState>(
              builder: (context, state) => switch (state) {
                DoaListInitial() => const SizedBox.shrink(),
                DoaListLoading() => const LoadingWidget(),
                DoaListSuccess() => _DoaListContent(state: state),
                DoaListFailure(:final failure) => ErrorStateWidget(
                  message: failure.toUserMessage(),
                  onRetry: context.read<DoaListCubit>().retry,
                ),
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// AppBar
// ---------------------------------------------------------------------------

class _DoaListAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _DoaListAppBar({
    required this.l10n,
    required this.isDark,
    required this.canPop,
    required this.searchVisible,
    required this.onToggleSearch,
    required this.onFilter,
  });

  final AppLocalizations l10n;
  final bool isDark;
  final bool canPop;
  final bool searchVisible;
  final VoidCallback onToggleSearch;
  final VoidCallback onFilter;

  @override
  Size get preferredSize => const Size.fromHeight(AppDimens.appBarHeightLG);

  @override
  Widget build(BuildContext context) {
    final iconColor =
        isDark ? AppColors.onSurfaceDark : AppColors.textPrimary;

    return AppBar(
      backgroundColor:
          isDark ? AppColors.surfaceDark : AppColors.surface,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      surfaceTintColor: Colors.transparent,
      toolbarHeight: AppDimens.appBarHeightLG,
      leading: canPop
          ? BackButton(color: iconColor)
          : Builder(
              builder: (ctx) => IconButton(
                icon: Icon(Icons.menu_rounded, color: iconColor),
                onPressed: () => Scaffold.of(ctx).openDrawer(),
              ),
            ),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.doaList,
            style: AppTypography.serifHeadingMedium.copyWith(
              color: isDark ? AppColors.onSurfaceDark : AppColors.textPrimary,
              height: 1,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 3),
          Container(
            width: 20,
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
        // Search toggle
        IconButton(
          icon: Icon(
            searchVisible
                ? Icons.search_off_rounded
                : Icons.search_rounded,
            color: searchVisible
                ? (isDark ? AppColors.primaryLighter : AppColors.primary)
                : iconColor,
          ),
          onPressed: onToggleSearch,
        ),

        // Filter dengan badge
        BlocBuilder<DoaListCubit, DoaListState>(
          builder: (context, state) {
            final hasFilter =
                state.mapOrNull(success: (s) => s.hasActiveFilter) ?? false;
            return IconButton(
              icon: Badge(
                isLabelVisible: hasFilter,
                backgroundColor: AppColors.gold,
                smallSize: 8,
                child: Icon(
                  Icons.tune_rounded,
                  color: hasFilter
                      ? (isDark ? AppColors.primaryLighter : AppColors.primary)
                      : iconColor,
                ),
              ),
              onPressed: onFilter,
            );
          },
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Search bar
// ---------------------------------------------------------------------------

class _DoaSearchBar extends StatelessWidget {
  const _DoaSearchBar({
    required this.controller,
    required this.onChanged,
    required this.hint,
    required this.isDark,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hint;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.pagePadding,
        AppDimens.spaceSM,
        AppDimens.pagePadding,
        AppDimens.spaceSM,
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        autofocus: true,
        style: TextStyle(
          color: isDark ? AppColors.onSurfaceDark : AppColors.textPrimary,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: isDark
                ? AppColors.onSurfaceDarkVariant
                : AppColors.textTertiary,
            fontSize: 14,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: isDark ? AppColors.primaryLighter : AppColors.primary,
            size: AppDimens.iconMD,
          ),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (_, value, _) => value.text.isNotEmpty
                ? IconButton(
                    icon: Icon(
                      Icons.clear_rounded,
                      color: isDark
                          ? AppColors.onSurfaceDarkVariant
                          : AppColors.textTertiary,
                      size: AppDimens.iconSM + 2,
                    ),
                    onPressed: () {
                      controller.clear();
                      onChanged('');
                    },
                  )
                : const SizedBox.shrink(),
          ),
          filled: true,
          fillColor: isDark
              ? AppColors.surfaceDarkVariant
              : AppColors.surfaceVariant,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusLG),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusLG),
            borderSide: BorderSide(
              color: isDark ? AppColors.outlineDark : AppColors.outline,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusLG),
            borderSide: BorderSide(
              color: isDark ? AppColors.primaryLighter : AppColors.primary,
              width: 1.5,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppDimens.spaceMD,
            vertical: AppDimens.spaceSM + 2,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Active filter chip
// ---------------------------------------------------------------------------

class _ActiveFilterChip extends StatelessWidget {
  const _ActiveFilterChip({
    required this.label,
    required this.isDark,
    required this.onClear,
  });

  final String label;
  final bool isDark;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.pagePadding,
        AppDimens.spaceXS,
        AppDimens.pagePadding,
        AppDimens.spaceXS,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.spaceSM + 2,
              vertical: AppDimens.spaceXS,
            ),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.primaryDark
                  : AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(AppDimens.radiusFull),
              border: Border.all(
                color: isDark
                    ? AppColors.primaryLight.withValues(alpha: 0.3)
                    : AppColors.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.filter_list_rounded,
                  size: 12,
                  color: isDark ? AppColors.primaryLighter : AppColors.primary,
                ),
                const SizedBox(width: AppDimens.spaceXS),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.primaryLighter
                        : AppColors.primary,
                  ),
                ),
                const SizedBox(width: AppDimens.spaceXS),
                GestureDetector(
                  onTap: onClear,
                  child: Icon(
                    Icons.close_rounded,
                    size: 13,
                    color: isDark
                        ? AppColors.primaryLighter
                        : AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// List content
// ---------------------------------------------------------------------------

class _DoaListContent extends StatelessWidget {
  const _DoaListContent({required this.state});

  final DoaListSuccess state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final doaList = state.filtered;

    if (doaList.isEmpty) {
      return EmptyStateWidget(message: l10n.noDoaFound);
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: context.read<DoaListCubit>().refresh,
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
          onTap: () => context.push('/doa/${doaList[i].id}'),
        ),
      ),
    );
  }
}
