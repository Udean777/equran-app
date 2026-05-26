import 'dart:async';
import 'dart:ui' as ui;

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/utils/bottom_sheet_utils.dart';
import 'package:equran_app/core/widgets/empty_state_widget.dart';
import 'package:equran_app/core/widgets/loading_widget.dart';
import 'package:equran_app/features/hafalan/domain/entities/hafalan_surat.dart';
import 'package:equran_app/features/hafalan/presentation/cubit/hafalan_cubit.dart';
import 'package:equran_app/features/hafalan/presentation/widgets/hafalan_ayat_grid.dart';
import 'package:equran_app/features/hafalan/presentation/widgets/hafalan_reminder_sheet.dart';
import 'package:equran_app/features/hafalan/presentation/widgets/hafalan_status_badge.dart';
import 'package:equran_app/features/surat_list/domain/entities/surat.dart';
import 'package:equran_app/features/surat_list/presentation/cubit/surat_list_cubit.dart';
import 'package:equran_app/injection/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class HafalanDetailPage extends StatelessWidget {
  const HafalanDetailPage({required this.suratNomor, super.key});

  final int suratNomor;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            final cubit = getIt<HafalanCubit>();
            unawaited(cubit.load());
            return cubit;
          },
        ),
        BlocProvider(
          create: (_) {
            final cubit = getIt<SuratListCubit>();
            unawaited(cubit.load());
            return cubit;
          },
        ),
      ],
      child: _HafalanDetailView(suratNomor: suratNomor),
    );
  }
}

class _HafalanDetailView extends StatelessWidget {
  const _HafalanDetailView({required this.suratNomor});

  final int suratNomor;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SuratListCubit, SuratListState>(
      builder: (context, suratState) {
        if (suratState is! SuratListSuccess) {
          return const Scaffold(body: LoadingWidget());
        }

        final suratMatches = suratState.surats.where(
          (s) => s.nomor == suratNomor,
        );
        if (suratMatches.isEmpty) {
          return const Scaffold(
            body: EmptyStateWidget(message: 'Surat tidak ditemukan.'),
          );
        }
        final surat = suratMatches.first;

        return BlocBuilder<HafalanCubit, HafalanState>(
          builder: (context, hafalanState) {
            final hafalan = hafalanState is HafalanSuccess
                ? (hafalanState.hafalanList
                          .where((h) => h.suratNomor == suratNomor)
                          .isEmpty
                      ? null
                      : hafalanState.hafalanList.firstWhere(
                          (h) => h.suratNomor == suratNomor,
                        ))
                : null;

            return _HafalanDetailScaffold(
              surat: surat,
              hafalan: hafalan,
            );
          },
        );
      },
    );
  }
}

class _HafalanDetailScaffold extends StatelessWidget {
  const _HafalanDetailScaffold({
    required this.surat,
    required this.hafalan,
  });

  final Surat surat;
  final HafalanSurat? hafalan;

  @override
  Widget build(BuildContext context) {
    final ayatHafal = hafalan?.ayatHafal ?? [];
    final progress = surat.jumlahAyat > 0
        ? ayatHafal.length / surat.jumlahAyat
        : 0.0;
    final persen = (progress * 100).toStringAsFixed(0);
    final status = hafalan?.status ?? HafalanStatus.belum;

    return Scaffold(
      appBar: AppBar(
        title: Text(surat.namaLatin),
        actions: [
          // Hapus data hafalan
          if (hafalan != null)
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded),
              tooltip: 'Hapus data hafalan',
              onPressed: () => _confirmDelete(context),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header progress
            _ProgressHeader(
              surat: surat,
              ayatHafalCount: ayatHafal.length,
              progress: progress,
              persen: persen,
              status: status,
            ),

            // Status selector
            _StatusSelector(
              suratNomor: surat.nomor,
              currentStatus: status,
            ),

            // Section: Ayat
            const _SectionHeader(title: 'Ayat', icon: Icons.grid_view_rounded),
            HafalanAyatGrid(
              jumlahAyat: surat.jumlahAyat,
              ayatHafal: ayatHafal,
              onToggle: (ayatNomor) {
                final suratAsHafalan = HafalanSurat(
                  suratNomor: surat.nomor,
                  namaLatin: surat.namaLatin,
                  nama: surat.nama,
                  jumlahAyat: surat.jumlahAyat,
                );
                unawaited(
                  context.read<HafalanCubit>().toggleAyat(
                    suratNomor: surat.nomor,
                    ayatNomor: ayatNomor,
                    suratInfo: suratAsHafalan,
                  ),
                );
              },
            ),

            // Section: Muraja'ah — hanya tampil jika sudah selesai hafal
            if (hafalan != null && hafalan!.isSelesai) ...[
              const _SectionHeader(
                title: "Muraja'ah",
                icon: Icons.refresh_rounded,
              ),
              _MurajaahSection(hafalan: hafalan!),
            ],

            // Section: Mode Setoran
            const _SectionHeader(
              title: 'Mode Setoran',
              icon: Icons.record_voice_over_rounded,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.spaceMD,
                vertical: AppDimens.spaceXS,
              ),
              child: FilledButton.icon(
                onPressed: () =>
                    context.push('/hafalan/${surat.nomor}/setoran'),
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Mulai Setoran'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
              ),
            ),

            // Section: Catatan
            const _SectionHeader(
              title: 'Catatan',
              icon: Icons.edit_note_rounded,
            ),
            _CatatanField(
              suratNomor: surat.nomor,
              initialValue: hafalan?.catatan,
              suratInfo: HafalanSurat(
                suratNomor: surat.nomor,
                namaLatin: surat.namaLatin,
                nama: surat.nama,
                jumlahAyat: surat.jumlahAyat,
              ),
            ),

            const SizedBox(height: AppDimens.spaceXL),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Data Hafalan?'),
        content: Text(
          'Semua data hafalan ${surat.namaLatin} akan dihapus. '
          'Tindakan ini tidak bisa dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if ((confirmed ?? false) && context.mounted) {
      await context.read<HafalanCubit>().deleteSurat(surat.nomor);
      if (context.mounted) context.pop();
    }
  }
}

// ─── Sub-widgets ──────────────────────────────────────────────────────────────

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({
    required this.surat,
    required this.ayatHafalCount,
    required this.progress,
    required this.persen,
    required this.status,
  });

  final Surat surat;
  final int ayatHafalCount;
  final double progress;
  final String persen;
  final HafalanStatus status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.all(AppDimens.spaceMD),
      padding: const EdgeInsets.all(AppDimens.spaceMD),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Directionality(
                      textDirection: ui.TextDirection.rtl,
                      child: Text(
                        surat.nama,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontFamily: 'KFGQPC',
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    Text(
                      surat.arti,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              HafalanStatusBadge(status: status),
            ],
          ),
          const SizedBox(height: AppDimens.spaceMD),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: Colors.grey[200],
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppDimens.spaceSM),
              Text(
                '$ayatHafalCount/${surat.jumlahAyat} ($persen%)',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusSelector extends StatelessWidget {
  const _StatusSelector({
    required this.suratNomor,
    required this.currentStatus,
  });

  final int suratNomor;
  final HafalanStatus currentStatus;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Hanya tampilkan status yang bisa di-set manual (bukan perluMurajaah)
    final options = [
      HafalanStatus.belum,
      HafalanStatus.sedangDihafal,
      HafalanStatus.sudahHafal,
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMD),
      child: Row(
        children: [
          Text(
            'Status:',
            style: theme.textTheme.labelMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(width: AppDimens.spaceSM),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: options.map((s) {
                  final isSelected =
                      currentStatus == s ||
                      (currentStatus == HafalanStatus.perluMurajaah &&
                          s == HafalanStatus.sudahHafal);
                  return Padding(
                    padding: const EdgeInsets.only(right: AppDimens.spaceXS),
                    child: ChoiceChip(
                      label: Text(_statusLabel(s)),
                      selected: isSelected,
                      onSelected: (_) => unawaited(
                        context.read<HafalanCubit>().setStatus(
                          suratNomor: suratNomor,
                          status: s,
                        ),
                      ),
                      selectedColor: AppColors.primary.withValues(alpha: 0.15),
                      labelStyle: TextStyle(
                        color: isSelected ? AppColors.primary : null,
                        fontSize: 12,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _statusLabel(HafalanStatus status) {
    switch (status) {
      case HafalanStatus.belum:
        return 'Belum';
      case HafalanStatus.sedangDihafal:
        return 'Sedang';
      case HafalanStatus.sudahHafal:
        return 'Hafal';
      case HafalanStatus.perluMurajaah:
        return 'Murajaah';
    }
  }
}

class _MurajaahSection extends StatelessWidget {
  const _MurajaahSection({required this.hafalan});

  final HafalanSurat hafalan;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final nextDate = hafalan.tanggalMurajaahBerikutnya;
    final dateStr = nextDate != null
        ? DateFormat('d MMMM yyyy', 'id').format(nextDate)
        : '-';
    final levelStr = hafalan.isMurajaahSelesai
        ? 'Hafalan kuat ✓'
        : 'Level ${hafalan.murajaahLevel + 1}/5';

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceMD,
        vertical: AppDimens.spaceXS,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Info level + tanggal
          Container(
            padding: const EdgeInsets.all(AppDimens.spaceMD),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(AppDimens.radiusMD),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.timeline_rounded,
                  color: AppColors.primary,
                  size: AppDimens.iconMD,
                ),
                const SizedBox(width: AppDimens.spaceSM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        levelStr,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (!hafalan.isMurajaahSelesai)
                        Text(
                          'Berikutnya: $dateStr',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: hafalan.isMurajaahJatuhTempo
                                ? AppColors.error
                                : Colors.grey[500],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimens.spaceSM),

          // Tombol aksi muraja'ah
          OutlinedButton.icon(
            onPressed: () => unawaited(
              showAppBottomSheet<void>(
                context,
                builder: (_) => BlocProvider.value(
                  value: context.read<HafalanCubit>(),
                  child: HafalanReminderSheet(hafalan: hafalan),
                ),
              ),
            ),
            icon: const Icon(Icons.edit_calendar_rounded),
            label: const Text("Atur Jadwal Muraja'ah"),
          ),
        ],
      ),
    );
  }
}

class _CatatanField extends StatefulWidget {
  const _CatatanField({
    required this.suratNomor,
    required this.suratInfo,
    this.initialValue,
  });

  final int suratNomor;
  final String? initialValue;
  final HafalanSurat suratInfo;

  @override
  State<_CatatanField> createState() => _CatatanFieldState();
}

class _CatatanFieldState extends State<_CatatanField> {
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

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.spaceMD,
        AppDimens.spaceMD,
        AppDimens.spaceMD,
        AppDimens.spaceXS,
      ),
      child: Row(
        children: [
          Icon(icon, size: AppDimens.iconSM, color: AppColors.primary),
          const SizedBox(width: AppDimens.spaceXS),
          Text(
            title,
            style: theme.textTheme.labelLarge?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
