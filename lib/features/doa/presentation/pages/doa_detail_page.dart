import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/utils/failure_extension.dart';
import 'package:equran_app/core/widgets/error_state_widget.dart';
import 'package:equran_app/core/widgets/loading_widget.dart';
import 'package:equran_app/features/doa/domain/entities/doa.dart';
import 'package:equran_app/features/doa/domain/usecases/get_doa_bookmarks.dart';
import 'package:equran_app/features/doa/domain/usecases/toggle_doa_bookmark.dart';
import 'package:equran_app/features/doa/presentation/cubit/doa_detail_cubit.dart';
import 'package:equran_app/features/doa/presentation/widgets/doa_about_card.dart';
import 'package:equran_app/features/doa/presentation/widgets/doa_arabic_card.dart';
import 'package:equran_app/features/doa/presentation/widgets/doa_translation_card.dart';
import 'package:equran_app/injection/injection_container.dart';
import 'package:equran_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DoaDetailPage extends StatelessWidget {
  const DoaDetailPage({required this.id, super.key});

  final int id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = getIt<DoaDetailCubit>();
        unawaited(cubit.load(id));
        return cubit;
      },
      child: _DoaDetailView(id: id),
    );
  }
}

class _DoaDetailView extends StatelessWidget {
  const _DoaDetailView({required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoaDetailCubit, DoaDetailState>(
      builder: (context, state) => switch (state) {
        DoaDetailInitial() => const Scaffold(body: LoadingWidget()),
        DoaDetailLoading() => const Scaffold(body: LoadingWidget()),
        DoaDetailSuccess(:final doa) => _DoaDetailContent(doa: doa),
        DoaDetailFailure(:final failure) => Scaffold(
          appBar: AppBar(),
          body: ErrorStateWidget(
            message: failure.toUserMessage(),
            onRetry: () => context.read<DoaDetailCubit>().retry(),
          ),
        ),
      },
    );
  }
}

class _DoaDetailContent extends StatefulWidget {
  const _DoaDetailContent({required this.doa});

  final Doa doa;

  @override
  State<_DoaDetailContent> createState() => _DoaDetailContentState();
}

class _DoaDetailContentState extends State<_DoaDetailContent> {
  late final GetDoaBookmarks _getBookmarks;
  late final ToggleDoaBookmark _toggleBookmark;
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _getBookmarks = getIt<GetDoaBookmarks>();
    _toggleBookmark = getIt<ToggleDoaBookmark>();
    unawaited(_loadBookmarkStatus());
  }

  Future<void> _loadBookmarkStatus() async {
    final result = await _getBookmarks();
    result.fold(
      (_) {},
      (ids) {
        if (mounted) {
          setState(() => _isBookmarked = ids.contains(widget.doa.id));
        }
      },
    );
  }

  Future<void> _onToggleBookmark() async {
    final result = await _toggleBookmark(widget.doa.id);
    result.fold(
      (_) {},
      (isNowBookmarked) {
        if (mounted) {
          setState(() => _isBookmarked = isNowBookmarked);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isNowBookmarked
                    ? 'Doa disimpan ke favorit'
                    : 'Doa dihapus dari favorit',
              ),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.doa.nama,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            tooltip: _isBookmarked ? 'Hapus dari favorit' : 'Simpan ke favorit',
            icon: Icon(
              _isBookmarked
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_outline_rounded,
              color: _isBookmarked ? AppColors.secondary : null,
            ),
            onPressed: _onToggleBookmark,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          top: AppDimens.spaceSM,
          bottom: AppDimens.spaceLG,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header card — nama, grup, tag chips
            _DoaHeaderCard(doa: widget.doa),

            // 2. Arabic card — selalu tampil
            DoaArabicCard(ar: widget.doa.ar),

            // 3. Latin (skip jika kosong)
            if (widget.doa.tr.isNotEmpty)
              DoaTranslationCard(
                label: l10n.transliteration,
                text: widget.doa.tr,
              ),

            // 4. Terjemahan (skip jika kosong)
            if (widget.doa.idn.isNotEmpty)
              DoaTranslationCard(
                label: l10n.translation,
                text: widget.doa.idn,
              ),

            // 5. Tentang collapsible (skip jika kosong)
            if (widget.doa.tentang.isNotEmpty)
              DoaAboutCard(tentang: widget.doa.tentang),
          ],
        ),
      ),
    );
  }
}

class _DoaHeaderCard extends StatelessWidget {
  const _DoaHeaderCard({required this.doa});

  final Doa doa;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceMD,
        vertical: AppDimens.spaceXS,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nama
            Text(
              doa.nama,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppDimens.spaceXS),
            // Grup
            Text(
              doa.grup,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                fontStyle: FontStyle.italic,
              ),
            ),
            // Tag chips
            if (doa.tag.isNotEmpty) ...[
              const SizedBox(height: AppDimens.spaceSM),
              Wrap(
                spacing: AppDimens.spaceXS,
                runSpacing: AppDimens.spaceXS,
                children: doa.tag
                    .map(
                      (tag) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimens.spaceSM,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(
                            AppDimens.radiusFull,
                          ),
                        ),
                        child: Text(
                          '#$tag',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
