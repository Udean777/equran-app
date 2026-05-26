import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/hafalan/domain/entities/hafalan_surat.dart';
import 'package:equran_app/features/hafalan/presentation/cubit/hafalan_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Field catatan pribadi untuk surat hafalan.
class HafalanCatatanField extends StatefulWidget {
  const HafalanCatatanField({
    required this.suratNomor,
    required this.suratInfo,
    this.initialValue,
    super.key,
  });

  final int suratNomor;
  final String? initialValue;
  final HafalanSurat suratInfo;

  @override
  State<HafalanCatatanField> createState() => _HafalanCatatanFieldState();
}

class _HafalanCatatanFieldState extends State<HafalanCatatanField> {
  late final TextEditingController _controller;
  bool _isDirty = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
    _controller.addListener(() {
      if (!_isDirty) setState(() => _isDirty = true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceMD,
        vertical: AppDimens.spaceXS,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _controller,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Tulis catatan pribadi untuk surat ini...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimens.radiusMD),
              ),
              contentPadding: const EdgeInsets.all(AppDimens.spaceMD),
            ),
          ),
          if (_isDirty) ...[
            const SizedBox(height: AppDimens.spaceSM),
            FilledButton(
              onPressed: () => _saveCatatan(context),
              child: const Text('Simpan Catatan'),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _saveCatatan(BuildContext context) async {
    final existing =
        context.read<HafalanCubit>().getSurat(widget.suratNomor) ??
        widget.suratInfo;
    final updated = existing.copyWith(
      catatan: _controller.text.trim().isEmpty ? null : _controller.text.trim(),
    );
    await context.read<HafalanCubit>().saveHafalanSurat(updated);
    if (context.mounted) {
      setState(() => _isDirty = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Catatan disimpan')),
      );
    }
  }
}
