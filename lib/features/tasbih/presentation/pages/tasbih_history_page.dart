import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Tasbih'),
        actions: [
          BlocBuilder<TasbihCubit, TasbihState>(
            builder: (context, state) {
              if (state.sessions.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.delete_sweep_rounded),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history_rounded,
                    size: 64,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: AppDimens.spaceMD),
                  Text(
                    'Belum ada riwayat',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: AppDimens.spaceSM),
                  Text(
                    'Selesaikan satu sesi tasbih\nuntuk melihat riwayat di sini.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(AppDimens.spaceMD),
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
    unawaited(
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Hapus Semua Riwayat'),
          content: const Text(
            'Semua riwayat tasbih akan dihapus permanen. Lanjutkan?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.error,
              ),
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
