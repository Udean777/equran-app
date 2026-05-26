import 'dart:async';

import 'package:equran_app/core/utils/failure_extension.dart';
import 'package:equran_app/core/widgets/error_state_widget.dart';
import 'package:equran_app/core/widgets/loading_widget.dart';
import 'package:equran_app/core/widgets/luxury_app_bar.dart';
import 'package:equran_app/features/doa/domain/entities/doa.dart';
import 'package:equran_app/features/doa/presentation/cubit/doa_detail_cubit.dart';
import 'package:equran_app/features/doa/presentation/widgets/doa_about_card.dart';
import 'package:equran_app/features/doa/presentation/widgets/doa_arabic_card.dart';
import 'package:equran_app/features/doa/presentation/widgets/doa_translation_card.dart';
import 'package:equran_app/injection/injection_container.dart';
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
        DoaDetailFailure(:final failure) => Scaffold(
          appBar: const LuxuryAppBar(title: 'Doa'),
          body: ErrorStateWidget(
            message: failure.toUserMessage(),
            onRetry: () => context.read<DoaDetailCubit>().load(id),
          ),
        ),
        DoaDetailSuccess(:final doa) => _DoaDetailScaffold(doa: doa),
      },
    );
  }
}

class _DoaDetailScaffold extends StatelessWidget {
  const _DoaDetailScaffold({required this.doa});

  final Doa doa;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DoaDetailCubit>();

    return Scaffold(
      appBar: LuxuryAppBar(
        title: doa.nama,
        actions: [
          BlocBuilder<DoaDetailCubit, DoaDetailState>(
            builder: (context, state) {
              final isBookmarked =
                  state.mapOrNull(success: (s) => s.isBookmarked) ?? false;
              return IconButton(
                icon: Icon(
                  isBookmarked
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_outline_rounded,
                ),
                tooltip: isBookmarked ? 'Hapus bookmark' : 'Tambah bookmark',
                onPressed: () => unawaited(cubit.toggleBookmark()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          DoaArabicCard(ar: doa.ar),
          DoaTranslationCard(label: 'Terjemahan', text: doa.idn),
          DoaAboutCard(tentang: doa.tentang),
        ],
      ),
    );
  }
}
