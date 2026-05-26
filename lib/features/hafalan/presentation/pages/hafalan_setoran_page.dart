import 'dart:async';
import 'dart:ui' as ui;

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/utils/failure_extension.dart';
import 'package:equran_app/core/widgets/error_state_widget.dart';
import 'package:equran_app/core/widgets/loading_widget.dart';
import 'package:equran_app/features/hafalan/domain/entities/hafalan_surat.dart';
import 'package:equran_app/features/hafalan/presentation/cubit/hafalan_cubit.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:equran_app/features/surat_detail/presentation/cubit/surat_detail_cubit.dart';
import 'package:equran_app/injection/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HafalanSetoranPage extends StatelessWidget {
  const HafalanSetoranPage({required this.suratNomor, super.key});

  final int suratNomor;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            final cubit = getIt<SuratDetailCubit>();
            unawaited(cubit.load(suratNomor));
            return cubit;
          },
        ),
        BlocProvider(
          create: (_) {
            final cubit = getIt<HafalanCubit>();
            unawaited(cubit.load());
            return cubit;
          },
        ),
      ],
      child: _HafalanSetoranView(suratNomor: suratNomor),
    );
  }
}

class _HafalanSetoranView extends StatelessWidget {
  const _HafalanSetoranView({required this.suratNomor});

  final int suratNomor;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SuratDetailCubit, SuratDetailState>(
      builder: (context, state) => switch (state) {
        SuratDetailInitial() => const Scaffold(body: LoadingWidget()),
        SuratDetailLoading() => const Scaffold(body: LoadingWidget()),
        SuratDetailFailure(:final failure) => Scaffold(
          appBar: AppBar(title: const Text('Mode Setoran')),
          body: ErrorStateWidget(
            message: failure.toUserMessage(),
            onRetry: () => context.read<SuratDetailCubit>().retry(suratNomor),
          ),
        ),
        SuratDetailSuccess(:final detail) => _SetoranSession(
          detail: detail,
          suratNomor: suratNomor,
        ),
      },
    );
  }
}

// ─── Sesi Setoran ─────────────────────────────────────────────────────────────

class _SetoranSession extends StatefulWidget {
  const _SetoranSession({
    required this.detail,
    required this.suratNomor,
  });

  final SuratDetail detail;
  final int suratNomor;

  @override
  State<_SetoranSession> createState() => _SetoranSessionState();
}

class _SetoranSessionState extends State<_SetoranSession> {
  late final List<Ayat> _ayatList;

  /// Index ayat yang sedang ditampilkan (0-based).
  int _currentIndex = 0;

  /// Hasil setoran: ayatNomor → true (hafal) / false (belum hafal).
  final Map<int, bool> _hasil = {};

  /// Apakah terjemahan sedang ditampilkan.
  bool _showTerjemahan = false;

  /// Apakah sesi sudah selesai.
  bool _isSelesai = false;

  @override
  void initState() {
    super.initState();
    _ayatList = widget.detail.ayatList;
  }

  Ayat get _currentAyat => _ayatList[_currentIndex];
  int get _totalAyat => _ayatList.length;
  int get _hafalCount => _hasil.values.where((v) => v).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isSelesai
              ? 'Hasil Setoran'
              : 'Setoran: ${widget.detail.info.namaLatin}',
        ),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          tooltip: 'Keluar',
          onPressed: () => _confirmExit(context),
        ),
      ),
      body: _isSelesai
          ? _HasilSetoran(
              detail: widget.detail,
              hasil: _hasil,
              onSimpan: () => _simpanHasil(context),
              onUlang: _ulangSetoran,
            )
          : _SetoranCard(
              ayat: _currentAyat,
              currentIndex: _currentIndex,
              totalAyat: _totalAyat,
              showTerjemahan: _showTerjemahan,
              onToggleTerjemahan: () =>
                  setState(() => _showTerjemahan = !_showTerjemahan),
              onHafal: () => _jawab(hafal: true),
              onBelumHafal: () => _jawab(hafal: false),
            ),
    );
  }

  void _jawab({required bool hafal}) {
    _hasil[_currentAyat.nomorAyat] = hafal;

    if (_currentIndex < _totalAyat - 1) {
      setState(() {
        _currentIndex++;
        _showTerjemahan = false;
      });
    } else {
      setState(() => _isSelesai = true);
    }
  }

  void _ulangSetoran() {
    setState(() {
      _currentIndex = 0;
      _hasil.clear();
      _showTerjemahan = false;
      _isSelesai = false;
    });
  }

  Future<void> _simpanHasil(BuildContext context) async {
    final hafalanCubit = context.read<HafalanCubit>();
    final existing = hafalanCubit.getSurat(widget.suratNomor);

    // Gabungkan hasil setoran dengan ayat yang sudah hafal sebelumnya
    final ayatHafalBaru = <int>{
      ...?existing?.ayatHafal,
    };

    for (final entry in _hasil.entries) {
      if (entry.value) {
        ayatHafalBaru.add(entry.key);
      } else {
        ayatHafalBaru.remove(entry.key);
      }
    }

    final suratInfo = HafalanSurat(
      suratNomor: widget.detail.info.nomor,
      namaLatin: widget.detail.info.namaLatin,
      nama: widget.detail.info.nama,
      jumlahAyat: widget.detail.info.jumlahAyat,
    );

    // Toggle setiap ayat yang berubah
    for (final entry in _hasil.entries) {
      final wasHafal = existing?.ayatHafal.contains(entry.key) ?? false;
      final isHafalNow = entry.value;
      if (wasHafal != isHafalNow) {
        await hafalanCubit.toggleAyat(
          suratNomor: widget.suratNomor,
          ayatNomor: entry.key,
          suratInfo: suratInfo,
        );
      }
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Hasil setoran disimpan: $_hafalCount/$_totalAyat ayat hafal',
          ),
        ),
      );
      context.pop();
    }
  }

  Future<void> _confirmExit(BuildContext context) async {
    if (_hasil.isEmpty) {
      context.pop();
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Keluar Setoran?'),
        content: const Text(
          'Progress setoran akan hilang jika keluar sekarang.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Lanjutkan'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
    if ((confirmed ?? false) && context.mounted) context.pop();
  }
}

// ─── Kartu Ayat ───────────────────────────────────────────────────────────────

class _SetoranCard extends StatelessWidget {
  const _SetoranCard({
    required this.ayat,
    required this.currentIndex,
    required this.totalAyat,
    required this.showTerjemahan,
    required this.onToggleTerjemahan,
    required this.onHafal,
    required this.onBelumHafal,
  });

  final Ayat ayat;
  final int currentIndex;
  final int totalAyat;
  final bool showTerjemahan;
  final VoidCallback onToggleTerjemahan;
  final VoidCallback onHafal;
  final VoidCallback onBelumHafal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Progress bar atas
        LinearProgressIndicator(
          value: (currentIndex + 1) / totalAyat,
          minHeight: 4,
          backgroundColor: Colors.grey[200],
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimens.spaceLG),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Label ayat
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.spaceMD,
                      vertical: AppDimens.spaceXS,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                    ),
                    child: Text(
                      'Ayat ${ayat.nomorAyat} dari $totalAyat',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppDimens.spaceXL),

                // Teks Arab
                Directionality(
                  textDirection: ui.TextDirection.rtl,
                  child: Text(
                    ayat.teksArab,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'KFGQPC',
                      fontSize: 28,
                      height: 2.2,
                      color: AppColors.primary,
                    ),
                  ),
                ),

                const SizedBox(height: AppDimens.spaceLG),

                // Terjemahan — toggle
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 200),
                  crossFadeState: showTerjemahan
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  firstChild: Center(
                    child: TextButton.icon(
                      onPressed: onToggleTerjemahan,
                      icon: const Icon(Icons.visibility_rounded, size: 16),
                      label: const Text('Tampilkan Terjemahan'),
                    ),
                  ),
                  secondChild: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        ayat.teksLatin,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey[500],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: AppDimens.spaceSM),
                      Text(
                        ayat.teksIndonesia,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: AppDimens.spaceXS),
                      Center(
                        child: TextButton.icon(
                          onPressed: onToggleTerjemahan,
                          icon: const Icon(
                            Icons.visibility_off_rounded,
                            size: 16,
                          ),
                          label: const Text('Sembunyikan'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Tombol jawab
        _JawabButtons(onHafal: onHafal, onBelumHafal: onBelumHafal),
      ],
    );
  }
}

class _JawabButtons extends StatelessWidget {
  const _JawabButtons({
    required this.onHafal,
    required this.onBelumHafal,
  });

  final VoidCallback onHafal;
  final VoidCallback onBelumHafal;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.spaceMD),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onBelumHafal,
              icon: const Icon(Icons.close_rounded, color: AppColors.error),
              label: const Text(
                'Belum Hafal',
                style: TextStyle(color: AppColors.error),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.error),
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimens.spaceMD,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppDimens.spaceMD),
          Expanded(
            child: FilledButton.icon(
              onPressed: onHafal,
              icon: const Icon(Icons.check_rounded),
              label: const Text('Hafal'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.success,
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimens.spaceMD,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Hasil Setoran ────────────────────────────────────────────────────────────

class _HasilSetoran extends StatelessWidget {
  const _HasilSetoran({
    required this.detail,
    required this.hasil,
    required this.onSimpan,
    required this.onUlang,
  });

  final SuratDetail detail;
  final Map<int, bool> hasil;
  final VoidCallback onSimpan;
  final VoidCallback onUlang;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalAyat = detail.ayatList.length;
    final hafalCount = hasil.values.where((v) => v).length;
    final belumCount = totalAyat - hafalCount;
    final persen = totalAyat > 0
        ? (hafalCount / totalAyat * 100).toStringAsFixed(0)
        : '0';

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimens.spaceMD),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Summary card
                Container(
                  padding: const EdgeInsets.all(AppDimens.spaceLG),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, Color(0xFF2E7D32)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(AppDimens.radiusLG),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.auto_stories_rounded,
                        color: AppColors.onPrimary,
                        size: 48,
                      ),
                      const SizedBox(height: AppDimens.spaceSM),
                      Text(
                        'Setoran Selesai',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: AppColors.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        detail.info.namaLatin,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.onPrimary.withValues(alpha: 0.8),
                        ),
                      ),
                      const SizedBox(height: AppDimens.spaceMD),
                      Text(
                        '$hafalCount/$totalAyat ayat ($persen%)',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: AppColors.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppDimens.spaceSM),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                          AppDimens.radiusFull,
                        ),
                        child: LinearProgressIndicator(
                          value: totalAyat > 0 ? hafalCount / totalAyat : 0,
                          minHeight: 8,
                          backgroundColor: AppColors.onPrimary.withValues(
                            alpha: 0.2,
                          ),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppDimens.spaceMD),

                // Stat row
                Row(
                  children: [
                    _StatBox(
                      label: 'Hafal',
                      value: '$hafalCount',
                      color: AppColors.success,
                    ),
                    const SizedBox(width: AppDimens.spaceSM),
                    _StatBox(
                      label: 'Belum Hafal',
                      value: '$belumCount',
                      color: AppColors.error,
                    ),
                  ],
                ),

                const SizedBox(height: AppDimens.spaceMD),

                // Detail per ayat
                Text(
                  'Detail per Ayat',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppDimens.spaceSM),
                Wrap(
                  spacing: AppDimens.spaceXS,
                  runSpacing: AppDimens.spaceXS,
                  children: hasil.entries.map((e) {
                    final isHafal = e.value;
                    return Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isHafal
                            ? AppColors.success.withValues(alpha: 0.15)
                            : AppColors.error.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(AppDimens.radiusSM),
                        border: Border.all(
                          color: isHafal ? AppColors.success : AppColors.error,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${e.key}',
                        style: TextStyle(
                          color: isHafal ? AppColors.success : AppColors.error,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),

        // Tombol aksi
        Container(
          padding: const EdgeInsets.all(AppDimens.spaceMD),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FilledButton.icon(
                onPressed: onSimpan,
                icon: const Icon(Icons.save_rounded),
                label: const Text('Simpan Hasil'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    vertical: AppDimens.spaceMD,
                  ),
                ),
              ),
              const SizedBox(height: AppDimens.spaceSM),
              OutlinedButton.icon(
                onPressed: onUlang,
                icon: const Icon(Icons.replay_rounded),
                label: const Text('Ulang Setoran'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppDimens.spaceMD,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppDimens.spaceMD),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppDimens.radiusMD),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
