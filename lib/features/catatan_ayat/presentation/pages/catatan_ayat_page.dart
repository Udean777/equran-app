import 'dart:async';
import 'dart:ui' as ui;

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/core/utils/bottom_sheet_utils.dart';
import 'package:equran_app/core/widgets/empty_state_widget.dart';
import 'package:equran_app/core/widgets/error_state_widget.dart';
import 'package:equran_app/core/widgets/loading_widget.dart';
import 'package:equran_app/features/catatan_ayat/domain/entities/catatan_ayat.dart';
import 'package:equran_app/features/catatan_ayat/presentation/cubit/catatan_ayat_cubit.dart';
import 'package:equran_app/features/catatan_ayat/presentation/widgets/catatan_editor_sheet.dart';
import 'package:equran_app/injection/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CatatanAyatPage extends StatelessWidget {
  const CatatanAyatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = getIt<CatatanAyatCubit>();
        unawaited(cubit.load());
        return cubit;
      },
      child: const _CatatanAyatView(),
    );
  }
}

class _CatatanAyatView extends StatelessWidget {
  const _CatatanAyatView();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;
    final iconColor = isDark ? AppColors.onSurfaceDark : AppColors.textPrimary;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.background,
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
              'Catatan Saya',
              style: AppTypography.serifHeadingMedium.copyWith(
                color: iconColor,
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
      ),
      body: BlocBuilder<CatatanAyatCubit, CatatanAyatState>(
        builder: (context, state) => switch (state) {
          CatatanAyatInitial() => const LoadingWidget(),
          CatatanAyatLoading() => const LoadingWidget(),
          CatatanAyatFailure(:final message) => ErrorStateWidget(
            message: message,
            onRetry: () => context.read<CatatanAyatCubit>().load(),
          ),
          CatatanAyatSuccess(:final catatan) => catatan.isEmpty
              ? const EmptyStateWidget(
                  message:
                      'Belum ada catatan.\nTambah catatan dari halaman baca surat.',
                )
              : _CatatanList(catatan: catatan),
        },
      ),
    );
  }
}

class _CatatanList extends StatelessWidget {
  const _CatatanList({required this.catatan});

  final List<CatatanAyat> catatan;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.pagePadding,
        AppDimens.spaceMD,
        AppDimens.pagePadding,
        AppDimens.spaceXL,
      ),
      itemCount: catatan.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppDimens.spaceSM),
      itemBuilder: (context, index) {
        final item = catatan[index];
        return _CatatanCard(
          catatan: item,
          onTap: () => _showEditor(context, item),
          onDelete: () => _confirmDelete(context, item),
        );
      },
    );
  }

  void _showEditor(BuildContext context, CatatanAyat item) {
    unawaited(
      showAppBottomSheet<void>(
        context,
        builder: (_) => BlocProvider.value(
          value: context.read<CatatanAyatCubit>(),
          child: CatatanEditorSheet(
            suratNomor: item.suratNomor,
            ayatNomor: item.ayatNomor,
            namaLatin: item.namaLatin,
            teksArab: item.teksArab,
            existing: item,
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, CatatanAyat item) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusXL),
          side: BorderSide(
            color: isDark ? AppColors.outlineDark : AppColors.outline,
          ),
        ),
        title: Text(
          'Hapus Catatan?',
          style: AppTypography.serifHeadingSmall.copyWith(
            color: isDark ? AppColors.onSurfaceDark : AppColors.textPrimary,
          ),
        ),
        content: Text(
          'Catatan untuk ${item.namaLatin} ayat ${item.ayatNomor} akan dihapus.',
          style: TextStyle(
            color: isDark
                ? AppColors.onSurfaceDarkVariant
                : AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Batal',
              style: TextStyle(
                color: isDark
                    ? AppColors.onSurfaceDarkVariant
                    : AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if ((confirmed ?? false) && context.mounted) {
      await context.read<CatatanAyatCubit>().delete(
        suratNomor: item.suratNomor,
        ayatNomor: item.ayatNomor,
      );
    }
  }
}

class _CatatanCard extends StatelessWidget {
  const _CatatanCard({
    required this.catatan,
    required this.onTap,
    required this.onDelete,
  });

  final CatatanAyat catatan;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;
    final borderColor =
        isDark ? AppColors.outlineDark : AppColors.outlineVariant;
    final dateStr = DateFormat('d MMM yyyy', 'id').format(catatan.savedAt);

    return Dismissible(
      key: Key('${catatan.suratNomor}:${catatan.ayatNomor}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppDimens.spaceMD),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(AppDimens.radiusLG),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
      ),
      confirmDismiss: (_) async {
        onDelete();
        return false;
      },
      child: Material(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimens.radiusLG),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimens.radiusLG),
              border: Border.all(color: borderColor),
            ),
            padding: const EdgeInsets.all(AppDimens.cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Row(
                  children: [
                    Container(
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
                        '${catatan.namaLatin} · ${catatan.ayatNomor}',
                        style: TextStyle(
                          color: isDark
                              ? AppColors.primaryLighter
                              : AppColors.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      dateStr,
                      style: TextStyle(
                        color: isDark
                            ? AppColors.onSurfaceDarkVariant
                            : AppColors.textTertiary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimens.spaceSM),

                // Teks Arab
                Directionality(
                  textDirection: ui.TextDirection.rtl,
                  child: Text(
                    catatan.teksArab,
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 18,
                      color: isDark
                          ? AppColors.primaryLighter
                          : AppColors.primary,
                      height: 1.8,
                    ),
                  ),
                ),

                Container(
                  height: 1,
                  margin: const EdgeInsets.symmetric(
                    vertical: AppDimens.spaceSM,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.gold.withValues(alpha: 0),
                        AppColors.gold.withValues(alpha: 0.3),
                        AppColors.gold.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),

                // Isi catatan
                Text(
                  catatan.isi,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark
                        ? AppColors.onSurfaceDark
                        : AppColors.textPrimary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
