import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/features/tasbih/presentation/cubit/tasbih_cubit.dart';
import 'package:equran_app/features/tasbih/presentation/widgets/tasbih_session_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TasbihHistoryPage extends StatefulWidget {
  const TasbihHistoryPage({super.key});

  @override
  State<TasbihHistoryPage> createState() => _TasbihHistoryPageState();
}

class _TasbihHistoryPageState extends State<TasbihHistoryPage> {
  @override
  void initState() {
    super.initState();
    unawaited(context.read<TasbihCubit>().loadSessions());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;
    final iconColor = isDark ? AppColors.onSurfaceDark : AppColors.textPrimary;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
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
              'Riwayat Tasbih',
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
        actions: [
          BlocBuilder<TasbihCubit, TasbihState>(
            builder: (context, state) {
              if (state.sessions.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: Icon(
                  Icons.delete_sweep_rounded,
                  color: AppColors.error.withValues(alpha: 0.7),
                ),
                tooltip: 'Hapus semua',
                onPressed: () => _confirmClearAll(context),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<TasbihCubit, TasbihState>(
        builder: (context, state) {
          if (state.sessions.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppDimens.spaceXXL),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.surfaceDarkVariant
                            : AppColors.surfaceVariant,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark
                              ? AppColors.outlineDark
                              : AppColors.outlineVariant,
                        ),
                      ),
                      child: Icon(
                        Icons.history_rounded,
                        size: 32,
                        color: isDark
                            ? AppColors.onSurfaceDarkVariant
                            : AppColors.textTertiary,
                      ),
                    ),
                    const SizedBox(height: AppDimens.spaceMD),
                    Text(
                      'Belum ada riwayat',
                      style: AppTypography.serifHeadingSmall.copyWith(
                        color: isDark
                            ? AppColors.onSurfaceDark
                            : AppColors.textPrimary,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: AppDimens.spaceSM),
                    Text(
                      'Selesaikan satu sesi tasbih\nuntuk melihat riwayat di sini.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isDark
                            ? AppColors.onSurfaceDarkVariant
                            : AppColors.textTertiary,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(
              AppDimens.pagePadding,
              AppDimens.spaceMD,
              AppDimens.pagePadding,
              AppDimens.spaceXL,
            ),
            itemCount: state.sessions.length,
            separatorBuilder: (_, _) =>
                const SizedBox(height: AppDimens.spaceSM),
            itemBuilder: (context, index) {
              final session = state.sessions[index];
              return TasbihSessionCard(
                session: session,
                onDelete: () =>
                    context.read<TasbihCubit>().deleteSession(session.id),
              );
            },
          );
        },
      ),
    );
  }

  void _confirmClearAll(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    unawaited(
      showDialog<void>(
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
            'Hapus Semua Riwayat',
            style: AppTypography.serifHeadingSmall.copyWith(
              color: isDark ? AppColors.onSurfaceDark : AppColors.textPrimary,
            ),
          ),
          content: Text(
            'Semua riwayat tasbih akan dihapus permanen. Lanjutkan?',
            style: TextStyle(
              color: isDark
                  ? AppColors.onSurfaceDarkVariant
                  : AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
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
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
              onPressed: () {
                unawaited(context.read<TasbihCubit>().clearAllSessions());
                Navigator.pop(ctx);
              },
              child: const Text('Hapus'),
            ),
          ],
        ),
      ),
    );
  }
}
