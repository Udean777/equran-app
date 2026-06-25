import 'dart:async';

import 'package:equran_app/core/utils/failure_extension.dart';
import 'package:equran_app/core/widgets/error_state_widget.dart';
import 'package:equran_app/core/widgets/loading_widget.dart';
import 'package:equran_app/core/widgets/luxury_app_bar.dart';
import 'package:equran_app/features/doa/domain/entities/doa.dart';
import 'package:equran_app/features/doa/presentation/providers.dart';
import 'package:equran_app/features/doa/presentation/widgets/doa_about_card.dart';
import 'package:equran_app/features/doa/presentation/widgets/doa_arabic_card.dart';
import 'package:equran_app/features/doa/presentation/widgets/doa_translation_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DoaDetailPage extends ConsumerStatefulWidget {
  const DoaDetailPage({required this.id, super.key});

  final int id;

  @override
  ConsumerState<DoaDetailPage> createState() => _DoaDetailPageState();
}

class _DoaDetailPageState extends ConsumerState<DoaDetailPage> {
  @override
  void initState() {
    super.initState();
    unawaited(
      ref.read(doaDetailViewModelProvider.notifier).load(widget.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(doaDetailViewModelProvider);

    return switch (state) {
      DoaDetailInitial() => const Scaffold(body: LoadingWidget()),
      DoaDetailLoading() => const Scaffold(body: LoadingWidget()),
      DoaDetailFailure(:final failure) => Scaffold(
        appBar: const LuxuryAppBar(title: 'Doa'),
        body: ErrorStateWidget(
          message: failure.toUserMessage(),
          onRetry: () =>
              ref.read(doaDetailViewModelProvider.notifier).load(widget.id),
        ),
      ),
      DoaDetailSuccess(:final doa) => _DoaDetailScaffold(doa: doa),
    };
  }
}

class _DoaDetailScaffold extends ConsumerWidget {
  const _DoaDetailScaffold({required this.doa});

  final Doa doa;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBookmarked =
        ref
            .watch(doaDetailViewModelProvider)
            .mapOrNull(
              success: (s) => s.isBookmarked,
            ) ??
        false;

    return Scaffold(
      appBar: LuxuryAppBar(
        title: doa.nama,
        actions: [
          IconButton(
            icon: Icon(
              isBookmarked
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_outline_rounded,
            ),
            tooltip: isBookmarked ? 'Hapus bookmark' : 'Tambah bookmark',
            onPressed: () => unawaited(
              ref.read(doaDetailViewModelProvider.notifier).toggleBookmark(),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          DoaArabicCard(ar: doa.ar),
          DoaTranslationCard(label: 'Latin', text: doa.tr),
          DoaTranslationCard(label: 'Terjemahan', text: doa.idn),
          DoaAboutCard(tentang: doa.tentang),
        ],
      ),
    );
  }
}
