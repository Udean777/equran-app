import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor =
        isDark ? AppColors.onSurfaceDark : AppColors.textPrimary;
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: surfaceColor,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: AppDimens.appBarHeightLG,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: iconColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              doa.nama,
              style: AppTypography.serifHeadingSmall.copyWith(
                color: isDark ? AppColors.onSurfaceDark : AppColors.textPrimary,
                fontSize: 16,
                height: 1,
              ),
              overflow: TextOverflow.ellipsis,
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
          IconButton(
            tooltip: isBookmarked ? 'Hapus dari favorit' : 'Simpan ke favorit',
            icon: Icon(
              isBookmarked
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_outline_rounded,
              color: isBookmarked ? AppColors.gold : iconColor,
            ),
            onPressed: () => _onToggleBookmark(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          top: AppDimens.spaceSM,
          bottom: AppDimens.spaceXXL,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card
            _DoaHeaderCard(doa: doa, isDark: isDark),

            // Arabic card
            DoaArabicCard(ar: doa.ar),

            // Latin
            if (doa.tr.isNotEmpty)
              DoaTranslationCard(
                label: l10n.transliteration,
                text: doa.tr,
              ),

            // Terjemahan
            if (doa.idn.isNotEmpty)
              DoaTranslationCard(
                label: l10n.translation,
                text: doa.idn,
              ),

            // Tentang
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
          ),
        );
      }
    }));
  }
}

// ---------------------------------------------------------------------------
// Header card
// ---------------------------------------------------------------------------

class _DoaHeaderCard extends StatelessWidget {
  const _DoaHeaderCard({required this.doa, required this.isDark});

  final Doa doa;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;
    final borderColor =
        isDark ? AppColors.outlineDark : AppColors.outlineVariant;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.pagePadding,
        AppDimens.spaceSM,
        AppDimens.pagePadding,
        AppDimens.spaceXS,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(AppDimens.radiusLG),
          border: Border.all(color: borderColor),
        ),
        padding: const EdgeInsets.all(AppDimens.cardPaddingLG),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nama dengan gold accent bar
            Row(
              children: [
                Container(
                  width: 3,
                  height: 20,
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius:
                        BorderRadius.circular(AppDimens.radiusFull),
                  ),
                ),
                const SizedBox(width: AppDimens.spaceSM),
                Expanded(
                  child: Text(
                    doa.nama,
                    style: AppTypography.serifHeadingSmall.copyWith(
                      color: isDark
                          ? AppColors.primaryLighter
                          : AppColors.primary,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppDimens.spaceSM),

            // Grup
            Text(
              doa.grup,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark
                    ? AppColors.onSurfaceDarkVariant
                    : AppColors.textTertiary,
                fontStyle: FontStyle.italic,
              ),
            ),

            // Tag chips
            if (doa.tag.isNotEmpty) ...[
              const SizedBox(height: AppDimens.spaceMD),
              Wrap(
                spacing: AppDimens.spaceXS,
                runSpacing: AppDimens.spaceXS,
                children: doa.tag
                    .map(
                      (tag) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimens.spaceSM,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.primaryDark
                              : AppColors.primaryContainer,
                          borderRadius:
                              BorderRadius.circular(AppDimens.radiusFull),
                        ),
                        child: Text(
                          '#$tag',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? AppColors.primaryLighter
                                : AppColors.primary,
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
