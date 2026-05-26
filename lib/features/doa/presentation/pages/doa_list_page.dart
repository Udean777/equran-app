import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
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

    final canPop = Navigator.canPop(context);

    return Scaffold(
      drawer: canPop ? null : const AppDrawer(),
      appBar: AppBar(
        title: Text(l10n.doaList),
        leading: canPop
            ? const BackButton()
            : Builder(
                builder: (ctx) => IconButton(
                  icon: const Icon(Icons.menu_rounded),
                  tooltip: 'Menu',
                  onPressed: () => Scaffold.of(ctx).openDrawer(),
                ),
              ),
        actions: [
          IconButton(
            tooltip: 'Cari',
            icon: Icon(
              _searchVisible ? Icons.search_off_rounded : Icons.search_rounded,
            ),
            onPressed: _toggleSearch,
          ),
          BlocBuilder<DoaListCubit, DoaListState>(
            builder: (context, state) {
              final hasFilter =
                  state.mapOrNull(
                    success: (s) => s.hasActiveFilter,
                  ) ??
                  false;
              return IconButton(
                tooltip: l10n.filterDoa,
                icon: Badge(
                  isLabelVisible: hasFilter,
                  child: const Icon(Icons.filter_list_rounded),
                ),
                onPressed: _showFilterSheet,
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar (collapsible)
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            child: _searchVisible
                ? _DoaSearchBar(
                    controller: _searchController,
                    onChanged: context.read<DoaListCubit>().search,
                    hint: l10n.searchDoa,
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

class _DoaSearchBar extends StatelessWidget {
  const _DoaSearchBar({
    required this.controller,
    required this.onChanged,
    required this.hint,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.spaceMD,
        AppDimens.spaceMD,
        AppDimens.spaceMD,
        AppDimens.spaceSM,
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        autofocus: true,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.primary,
          ),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (_, value, _) => value.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear_rounded),
                    onPressed: () {
                      controller.clear();
                      onChanged('');
                    },
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}

class _ActiveFilterChip extends StatelessWidget {
  const _ActiveFilterChip({
    required this.label,
    required this.onClear,
  });

  final String label;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceMD,
        vertical: AppDimens.spaceXS,
      ),
      child: Row(
        children: [
          Chip(
            label: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
            backgroundColor: AppColors.primary,
            deleteIcon: const Icon(
              Icons.close_rounded,
              size: 16,
              color: Colors.white,
            ),
            onDeleted: onClear,
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}

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
      onRefresh: context.read<DoaListCubit>().refresh,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 16),
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
