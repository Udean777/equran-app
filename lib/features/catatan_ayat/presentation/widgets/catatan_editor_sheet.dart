import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/widgets/bottom_sheet_handle.dart';
import 'package:equran_app/features/catatan_ayat/domain/entities/catatan_ayat.dart';
import 'package:equran_app/features/catatan_ayat/presentation/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CatatanEditorSheet extends ConsumerStatefulWidget {
  const CatatanEditorSheet({
    required this.suratNomor,
    required this.ayatNomor,
    required this.namaLatin,
    required this.teksArab,
    this.existing,
    super.key,
  });

  final int suratNomor;
  final int ayatNomor;
  final String namaLatin;
  final String teksArab;

  /// Catatan yang sudah ada — null jika belum ada catatan untuk ayat ini.
  final CatatanAyat? existing;

  @override
  ConsumerState<CatatanEditorSheet> createState() => _CatatanEditorSheetState();
}

class _CatatanEditorSheetState extends ConsumerState<CatatanEditorSheet> {
  late final TextEditingController _controller;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.existing?.isi ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    final isDark = context.isDark;
    return Padding(
      padding: EdgeInsets.only(
        left: AppDimens.spaceMD,
        right: AppDimens.spaceMD,
        top: AppDimens.spaceMD,
        bottom: MediaQuery.viewInsetsOf(context).bottom + AppDimens.spaceLG,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Handle
          const Center(child: BottomSheetHandle()),
          const SizedBox(height: AppDimens.spaceMD),

          // Header
          Row(
            children: [
              const Icon(
                Icons.edit_note_rounded,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: AppDimens.spaceSM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEdit ? 'Edit Catatan' : 'Tambah Catatan',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${widget.namaLatin} : ${widget.ayatNomor}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? AppColors.onSurfaceDarkVariant
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceSM),

          // Cuplikan teks Arab
          Container(
            padding: const EdgeInsets.all(AppDimens.spaceSM),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(AppDimens.radiusSM),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.15),
              ),
            ),
            child: Text(
              widget.teksArab,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'KFGQPC',
                fontSize: 16,
                color: AppColors.primary,
                height: 2,
              ),
            ),
          ),
          const SizedBox(height: AppDimens.spaceMD),

          // TextField catatan
          TextField(
            controller: _controller,
            maxLines: 5,
            minLines: 3,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: 'Tulis catatan, tafsir pribadi, atau refleksi...',
              hintStyle: TextStyle(
                color: isDark
                    ? AppColors.onSurfaceDarkVariant
                    : AppColors.textTertiary,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: AppDimens.spaceMD),

          // Tombol Simpan
          FilledButton.icon(
            onPressed: _isSaving ? null : _save,
            icon: _isSaving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.onPrimary,
                    ),
                  )
                : const Icon(Icons.save_rounded),
            label: Text(_isSaving ? 'Menyimpan...' : 'Simpan'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),

          // Tombol Hapus — hanya muncul jika edit
          if (isEdit) ...[
            const SizedBox(height: AppDimens.spaceSM),
            OutlinedButton.icon(
              onPressed: _isSaving ? null : _delete,
              icon: const Icon(Icons.delete_outline_rounded),
              label: const Text('Hapus Catatan'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _save() async {
    final isi = _controller.text.trim();
    if (isi.isEmpty) return;

    setState(() => _isSaving = true);
    try {
      final catatan = CatatanAyat(
        suratNomor: widget.suratNomor,
        ayatNomor: widget.ayatNomor,
        namaLatin: widget.namaLatin,
        teksArab: widget.teksArab,
        isi: isi,
        savedAt: DateTime.now(),
      );
      await ref.read(catatanAyatViewModelProvider.notifier).save(catatan);
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _delete() async {
    setState(() => _isSaving = true);
    try {
      await ref
          .read(catatanAyatViewModelProvider.notifier)
          .delete(
            suratNomor: widget.suratNomor,
            ayatNomor: widget.ayatNomor,
          );
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}
