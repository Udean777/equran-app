import 'dart:async';

import 'package:equran_app/core/utils/failure_extension.dart';
import 'package:equran_app/core/widgets/error_state_widget.dart';
import 'package:equran_app/core/widgets/loading_widget.dart';
import 'package:equran_app/features/surat_detail/presentation/cubit/surat_detail_cubit.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/ayat_card.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/surat_info_header.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/surat_nav_button.dart';
import 'package:equran_app/features/tafsir/presentation/widgets/tafsir_bottom_sheet.dart';
import 'package:equran_app/injection/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SuratDetailPage extends StatelessWidget {
  const SuratDetailPage({required this.nomor, super.key});

  final int nomor;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = getIt<SuratDetailCubit>();
        unawaited(cubit.load(nomor));
        return cubit;
      },
      child: _SuratDetailView(nomor: nomor),
    );
  }
}

class _SuratDetailView extends StatelessWidget {
  const _SuratDetailView({required this.nomor});

  final int nomor;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SuratDetailCubit, SuratDetailState>(
      builder: (context, state) => switch (state) {
        SuratDetailInitial() => const Scaffold(
          body: LoadingWidget(),
        ),
        SuratDetailLoading() => const Scaffold(
          body: LoadingWidget(),
        ),
        SuratDetailSuccess(:final detail) => Scaffold(
          appBar: AppBar(
            title: Text(detail.info.namaLatin),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _showTafsirBottomSheet(context, nomor),
            icon: const Icon(Icons.menu_book_rounded),
            label: const Text('Lihat Tafsir'),
          ),
          body: RefreshIndicator(
            onRefresh: () async => context.read<SuratDetailCubit>().load(nomor),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: SuratInfoHeader(detail: detail),
                ),
                SliverList.builder(
                  itemCount: detail.ayatList.length,
                  itemBuilder: (_, i) => AyatCard(
                    key: ValueKey(detail.ayatList[i].nomorAyat),
                    ayat: detail.ayatList[i],
                  ),
                ),
                SliverToBoxAdapter(
                  child: SuratNavButton(
                    suratSebelumnya: detail.suratSebelumnya,
                    suratSelanjutnya: detail.suratSelanjutnya,
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 80),
                ),
              ],
            ),
          ),
        ),
        SuratDetailFailure(:final failure) => Scaffold(
          appBar: AppBar(),
          body: ErrorStateWidget(
            message: failure.toUserMessage(),
            onRetry: () => context.read<SuratDetailCubit>().retry(nomor),
          ),
        ),
      },
    );
  }

  void _showTafsirBottomSheet(BuildContext context, int nomor) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (_) => TafsirBottomSheet(nomor: nomor),
      ),
    );
  }
}
