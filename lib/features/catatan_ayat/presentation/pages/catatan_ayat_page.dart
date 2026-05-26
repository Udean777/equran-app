import 'dart:async';

import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/utils/bottom_sheet_utils.dart';
import 'package:equran_app/core/utils/dialog_utils.dart';
import 'package:equran_app/core/widgets/empty_state_widget.dart';
import 'package:equran_app/core/widgets/error_state_widget.dart';
import 'package:equran_app/core/widgets/loading_widget.dart';
import 'package:equran_app/core/widgets/luxury_app_bar.dart';
import 'package:equran_app/features/catatan_ayat/domain/entities/catatan_ayat.dart';
import 'package:equran_app/features/catatan_ayat/presentation/cubit/catatan_ayat_cubit.dart';
import 'package:equran_app/features/catatan_ayat/presentation/widgets/catatan_ayat_card.dart';
import 'package:equran_app/features/catatan_ayat/presentation/widgets/catatan_editor_sheet.dart';
import 'package:equran_app/injection/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return Scaffold(
      appBar: const LuxuryAppBar(title: 'Catatan Saya'),
      body: BlocBuilder<CatatanAyatCubit, CatatanAyatState>(
        builder: (context, state) => switch (state) {
          CatatanAyatInitial() => const LoadingWidget(),
          CatatanAyatLoading() => const LoadingWidget(),
          CatatanAyatFailure(:final message) => ErrorStateWidget(
            message: message,
            onRetry: () => context.read<CatatanAyatCubit>().load(),
          ),
          CatatanAyatSuccess(:final catatan) =>
            catatan.isEmpty
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
        return CatatanAyatCard(
          key: ValueKey('${item.suratNomor}:${item.ayatNomor}'),
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
    final confirmed = await showConfirmDialog(
      context,
      title: 'Hapus Catatan?',
      content:
          'Catatan untuk ${item.namaLatin} ayat ${item.ayatNomor} akan dihapus.',
    );
    if (confirmed && context.mounted) {
      await context.read<CatatanAyatCubit>().delete(
        suratNomor: item.suratNomor,
        ayatNomor: item.ayatNomor,
      );
    }
  }
}
