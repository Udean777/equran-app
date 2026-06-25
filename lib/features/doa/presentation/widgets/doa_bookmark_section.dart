import 'dart:async';

import 'package:equran_app/core/router/app_routes.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/widgets/section_header.dart';
import 'package:equran_app/features/doa/presentation/providers.dart';
import 'package:equran_app/features/doa/presentation/widgets/doa_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DoaBookmarkSection extends ConsumerStatefulWidget {
  const DoaBookmarkSection({super.key, this.onEmptyStateChanged});

  final ValueChanged<bool>? onEmptyStateChanged;

  @override
  ConsumerState<DoaBookmarkSection> createState() => _DoaBookmarkSectionState();
}

class _DoaBookmarkSectionState extends ConsumerState<DoaBookmarkSection> {
  @override
  void initState() {
    super.initState();
    unawaited(ref.read(doaBookmarkViewModelProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(doaBookmarkViewModelProvider);

    final isEmpty = switch (state) {
      DoaBookmarkSuccess(:final bookmarkedDoas) => bookmarkedDoas.isEmpty,
      _ => true,
    };

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.onEmptyStateChanged?.call(isEmpty);
      }
    });

    if (isEmpty) return const SizedBox.shrink();

    final doas = (state as DoaBookmarkSuccess).bookmarkedDoas;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SectionHeader(label: 'Bookmark Doa'),
        ...doas.map(
          (d) => Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.pagePadding,
              vertical: AppDimens.spaceXS,
            ),
            child: DoaCard(
              doa: d,
              onTap: () => context.push(AppRoutes.doa(d.id)),
            ),
          ),
        ),
      ],
    );
  }
}
