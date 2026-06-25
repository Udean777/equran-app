import 'dart:async';

import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/utils/bottom_sheet_utils.dart';
import 'package:equran_app/core/utils/dialog_utils.dart';
import 'package:equran_app/core/utils/failure_extension.dart';
import 'package:equran_app/core/widgets/empty_state_widget.dart';
import 'package:equran_app/core/widgets/error_state_widget.dart';
import 'package:equran_app/core/widgets/loading_widget.dart';
import 'package:equran_app/core/widgets/luxury_app_bar.dart';
import 'package:equran_app/features/catatan_ayat/domain/entities/catatan_ayat.dart';
import 'package:equran_app/features/catatan_ayat/presentation/providers.dart';
import 'package:equran_app/features/catatan_ayat/presentation/viewmodels/catatan_ayat_state.dart';
import 'package:equran_app/features/catatan_ayat/presentation/widgets/catatan_ayat_card.dart';
import 'package:equran_app/features/catatan_ayat/presentation/widgets/catatan_editor_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CatatanAyatPage extends ConsumerStatefulWidget {
  const CatatanAyatPage({super.key});

  @override
  ConsumerState<CatatanAyatPage> createState() => _CatatanAyatPageState();
}

class _CatatanAyatPageState extends ConsumerState<CatatanAyatPage> {
  @override
  void initState() {
    super.initState();
    unawaited(ref.read(catatanAyatViewModelProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(catatanAyatViewModelProvider);

    return Scaffold(
      appBar: const LuxuryAppBar(title: 'Catatan Saya'),
      body: state.when(
        initial: () => const LoadingWidget(),
        loading: () => const LoadingWidget(),
        failure: (failure) => ErrorStateWidget(
          message: failure.toUserMessage(),
          onRetry: () => ref.read(catatanAyatViewModelProvider.notifier).load(),
        ),
        success: (catatan) => catatan.isEmpty
            ? const EmptyStateWidget(
                message:
                    'Belum ada catatan.\nTambah catatan dari halaman baca surat.',
              )
            : _CatatanList(catatan: catatan),
      ),
    );
  }
}

class _CatatanList extends ConsumerWidget {
  const _CatatanList({required this.catatan});

  final List<CatatanAyat> catatan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          onTap: () => _showEditor(context, ref, item),
          onDelete: () => _confirmDelete(context, ref, item),
        );
      },
    );
  }

  void _showEditor(BuildContext context, WidgetRef ref, CatatanAyat item) {
    unawaited(
      showAppBottomSheet<void>(
        context,
        builder: (_) => CatatanEditorSheet(
          suratNomor: item.suratNomor,
          ayatNomor: item.ayatNomor,
          namaLatin: item.namaLatin,
          teksArab: item.teksArab,
          existing: item,
        ),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    CatatanAyat item,
  ) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Hapus Catatan?',
      content:
          'Catatan untuk ${item.namaLatin} ayat ${item.ayatNomor} akan dihapus.',
    );
    if (confirmed && context.mounted) {
      await ref
          .read(catatanAyatViewModelProvider.notifier)
          .delete(
            suratNomor: item.suratNomor,
            ayatNomor: item.ayatNomor,
          );
    }
  }
}
