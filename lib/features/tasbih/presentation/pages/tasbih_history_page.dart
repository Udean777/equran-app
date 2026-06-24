import 'dart:async';

import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/context_ext.dart';
import 'package:equran_app/core/utils/dialog_utils.dart';
import 'package:equran_app/core/widgets/luxury_app_bar.dart';
import 'package:equran_app/features/tasbih/presentation/cubit/tasbih_cubit.dart';
import 'package:equran_app/features/tasbih/presentation/widgets/tasbih_session_card.dart';
import 'package:equran_app/l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      appBar: LuxuryAppBar(
        title: l10n.tasbihHistoryTitle,
        actions: [
          BlocBuilder<TasbihCubit, TasbihState>(
            builder: (context, state) {
              if (state.sessions.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.delete_sweep_rounded),
                tooltip: l10n.tasbihDeleteAllHistory,
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
              child: Text(l10n.tasbihEmptyHistory),
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
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showConfirmDialog(
      context,
      title: l10n.tasbihDeleteAllConfirmTitle,
      content: l10n.tasbihDeleteAllConfirmMessage,
    );
    if (confirmed && context.mounted) {
      await context.read<TasbihCubit>().clearAllSessions();
    }
  }
}
