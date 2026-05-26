import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/utils/failure_extension.dart';
import 'package:equran_app/core/widgets/error_state_widget.dart';
import 'package:equran_app/core/widgets/loading_widget.dart';
import 'package:equran_app/features/doa/domain/entities/doa.dart';
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
        DoaDetailSuccess(:final doa, :final isBookmarked) =>
          _DoaDetailContent(doa: doa, isBookmarked: isBookmarked),
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

class _DoaDetailContent extends StatelessWidget {
  const _DoaDetailContent({
    required this.doa,
    required this.isBookmarked,
  });

  final Doa doa;
  final bool isBookmarked;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          doa.nama,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            tooltip: isBookmarked ? 'Hapus dari favorit' : 'Simpan ke favorit',
            icon: Icon(
              isBookmarked
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_outline_rounded,
              color: isBookmarked ? AppColors.secondary : null,
            ),
            onPressed: () => _onToggleBookmark(context),
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
            _DoaHeaderCard(doa: doa),

            // 2. Arabic card — selalu tampil
            DoaArabicCard(ar: doa.ar),

            // 3. Latin (skip jika kosong)
            if (doa.tr.isNotEmpty)
              DoaTranslationCard(
                label: l10n.transliteration,
                text: doa.tr,
              ),

            // 4. Terjemahan (skip jika kosong)
            if (doa.idn.isNotEmpty)
              DoaTranslationCard(
                label: l10n.translation,
                text: doa.idn,
              ),

            // 5. Tentang collapsible (skip jika kosong)
            if (doa.tentang.isNotEmpty)
              DoaAboutCard(tentang: doa.tentang),
          ],
        ),
      ),
    );
  }

  void _onToggleBookmark(BuildContext context) {
    final cubit = context.read<DoaDetailCubit>();
    unawaited(cubit.toggleBookmark().then((_) {
      // Baca state terbaru setelah toggle
      final state = cubit.state;
      if (state is DoaDetailSuccess && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              state.isBookmarked
                  ? 'Doa disimpan ke favorit'
                  : 'Doa dihapus dari favorit',
            ),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }));
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
