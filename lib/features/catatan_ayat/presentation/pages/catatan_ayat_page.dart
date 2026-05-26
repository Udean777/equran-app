import 'dart:async';
import 'dart:ui' as ui;

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/utils/bottom_sheet_utils.dart';
import 'package:equran_app/core/widgets/empty_state_widget.dart';
import 'package:equran_app/core/widgets/error_state_widget.dart';
import 'package:equran_app/core/widgets/loading_widget.dart';
import 'package:equran_app/features/catatan_ayat/domain/entities/catatan_ayat.dart';
import 'package:equran_app/features/catatan_ayat/presentation/cubit/catatan_ayat_cubit.dart';
import 'package:equran_app/features/catatan_ayat/presentation/widgets/catatan_editor_sheet.dart';
import 'package:equran_app/injection/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

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
      appBar: AppBar(
        title: const Text('Catatan Saya'),
      ),
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
      padding: const EdgeInsets.all(AppDimens.spaceMD),
      itemCount: catatan.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppDimens.spaceSM),
      itemBuilder: (context, index) {
        final item = catatan[index];
        return _CatatanCard(
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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Catatan?'),
        content: Text(
          'Catatan untuk ${item.namaLatin} ayat ${item.ayatNomor} akan dihapus.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if ((confirmed ?? false) && context.mounted) {
      await context.read<CatatanAyatCubit>().delete(
        suratNomor: item.suratNomor,
        ayatNomor: item.ayatNomor,
      );
    }
  }
}

class _CatatanCard extends StatelessWidget {
  const _CatatanCard({
    required this.catatan,
    required this.onTap,
    required this.onDelete,
  });

  final CatatanAyat catatan;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('d MMM yyyy', 'id').format(catatan.savedAt);

    return Dismissible(
      key: Key('${catatan.suratNomor}:${catatan.ayatNomor}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppDimens.spaceMD),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(AppDimens.radiusMD),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
      ),
      confirmDismiss: (_) async {
        onDelete();
        return false; // cubit handle delete + reload
      },
      child: Card(
        margin: EdgeInsets.zero,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimens.radiusMD),
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header — nama surat + nomor ayat + tanggal
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimens.spaceSM,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppDimens.radiusSM),
                      ),
                      child: Text(
                        '${catatan.namaLatin} : ${catatan.ayatNomor}',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      dateStr,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimens.spaceSM),

                // Cuplikan teks Arab
                Directionality(
                  textDirection: ui.TextDirection.rtl,
                  child: Text(
                    catatan.teksArab,
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'KFGQPC',
                      fontSize: 16,
                      color: AppColors.primary,
                      height: 2,
                    ),
                  ),
                ),
                const Divider(height: AppDimens.spaceMD),

                // Isi catatan
                Text(
                  catatan.isi,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
