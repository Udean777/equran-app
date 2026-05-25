import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/tasbih/domain/entities/tasbih_session.dart';
import 'package:equran_app/features/tasbih/presentation/cubit/tasbih_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

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
              return _SessionCard(
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

class _SessionCard extends StatelessWidget {
  const _SessionCard({
    required this.session,
    required this.onDelete,
  });

  final TasbihSession session;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('dd MMM yyyy, HH:mm', 'id').format(
      session.createdAt.toLocal(),
    );
    final isComplete = session.count >= session.target;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.spaceMD),
        child: Row(
          children: [
            // Icon status
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isComplete
                    ? AppColors.success.withValues(alpha: 0.1)
                    : AppColors.warning.withValues(alpha: 0.1),
              ),
              child: Icon(
                isComplete
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
                color: isComplete ? AppColors.success : AppColors.warning,
                size: 24,
              ),
            ),
            const SizedBox(width: AppDimens.spaceMD),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.presetName,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${session.count} / ${session.target}x',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dateStr,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),

            // Delete
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded),
              color: Colors.grey[400],
              onPressed: onDelete,
              tooltip: 'Hapus',
            ),
          ],
        ),
      ),
    );
  }
}
