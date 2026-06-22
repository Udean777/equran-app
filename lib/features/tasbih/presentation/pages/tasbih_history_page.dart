import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/utils/dialog_utils.dart';
import 'package:equran_app/core/widgets/luxury_app_bar.dart';
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
    final isDark = context.isDark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
      appBar: LuxuryAppBar(
        title: 'Riwayat Tasbih',
        actions: [
          BlocBuilder<TasbihCubit, TasbihState>(
            builder: (context, state) {
              if (state.sessions.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.delete_sweep_rounded),
                tooltip: 'Hapus semua riwayat',
                onPressed: () => _confirmClearAll(context),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<TasbihCubit, TasbihState>(
        builder: (context, state) {
          if (state.sessions.isEmpty) {
            return const Center(
              child: Text('Belum ada riwayat tasbih.'),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.pagePadding,
              vertical: AppDimens.spaceMD,
            ),
            itemCount: state.sessions.length,
            separatorBuilder: (_, _) =>
                const SizedBox(height: AppDimens.spaceSM),
            itemBuilder: (_, i) {
              final session = state.sessions[i];
              return TasbihSessionCard(
                session: session,
                onDelete: () => unawaited(
                  context.read<TasbihCubit>().deleteSession(session.id),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _confirmClearAll(BuildContext context) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Hapus Semua Riwayat?',
      content: 'Semua riwayat tasbih akan dihapus permanen.',
    );
    if (confirmed && context.mounted) {
      await context.read<TasbihCubit>().clearAllSessions();
    }
  }
}
