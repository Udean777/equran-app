import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/doa/presentation/cubit/doa_list_cubit.dart';
import 'package:equran_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DoaFilterSheet extends StatefulWidget {
  const DoaFilterSheet({super.key});

  @override
  State<DoaFilterSheet> createState() => _DoaFilterSheetState();
}

class _DoaFilterSheetState extends State<DoaFilterSheet> {
  String? _selectedGrup;
  String? _selectedTag;

  @override
  void initState() {
    super.initState();
    final state = context.read<DoaListCubit>().state;
    if (state is DoaListSuccess) {
      _selectedGrup = state.activeGrup;
      _selectedTag = state.activeTag;
    }
  }

  void _selectGrup(String grup) {
    setState(() {
      _selectedGrup = _selectedGrup == grup ? null : grup;
      _selectedTag = null; // XOR: clear tag
    });
  }

  void _selectTag(String tag) {
    setState(() {
      _selectedTag = _selectedTag == tag ? null : tag;
      _selectedGrup = null; // XOR: clear grup
    });
  }

  void _apply() {
    final cubit = context.read<DoaListCubit>();
    if (_selectedGrup != null) {
      cubit.filterByGrup(_selectedGrup);
    } else if (_selectedTag != null) {
      cubit.filterByTag(_selectedTag);
    } else {
      cubit.clearFilter();
    }
    Navigator.of(context).pop();
  }

  void _clear() {
    setState(() {
      _selectedGrup = null;
      _selectedTag = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = context.read<DoaListCubit>().state;
    if (state is! DoaListSuccess) return const SizedBox.shrink();

    return DraggableScrollableSheet(
      initialChildSize: AppDimens.bottomSheetInitialChildSize,
      minChildSize: AppDimens.bottomSheetMinChildSize,
      maxChildSize: AppDimens.bottomSheetMaxChildSize,
      expand: false,
      builder: (context, scrollController) => Column(
        children: [
          // Handle
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceSM),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(AppDimens.radiusFull),
              ),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.spaceMD,
              vertical: AppDimens.spaceSM,
            ),
            child: Row(
              children: [
                Text(
                  l10n.filterDoa,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: _clear,
                  child: Text(l10n.clearFilter),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Scrollable content
          Expanded(
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(AppDimens.spaceMD),
              children: [
                // Filter by Grup
                Text(
                  l10n.filterByGrup,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: AppDimens.spaceSM),
                Wrap(
                  spacing: AppDimens.spaceSM,
                  runSpacing: AppDimens.spaceSM,
                  children: state.grupList
                      .map(
                        (grup) => _FilterChip(
                          label: grup,
                          selected: _selectedGrup == grup,
                          onTap: () => _selectGrup(grup),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: AppDimens.spaceLG),
                // Filter by Tag
                Text(
                  l10n.filterByTag,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: AppDimens.spaceSM),
                Wrap(
                  spacing: AppDimens.spaceSM,
                  runSpacing: AppDimens.spaceSM,
                  children: state.tagList
                      .map(
                        (tag) => _FilterChip(
                          label: '#$tag',
                          selected: _selectedTag == tag,
                          onTap: () => _selectTag(tag),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: AppDimens.spaceLG),
              ],
            ),
          ),
          // Apply button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppDimens.spaceMD),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _apply,
                  child: Text(l10n.applyFilter),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = selected
        ? AppColors.primary
        : (isDark ? Colors.grey[600]! : Colors.grey[400]!);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spaceMD,
          vertical: AppDimens.spaceSM,
        ),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.transparent,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(AppDimens.radiusFull),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
            color: selected ? Colors.white : theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
