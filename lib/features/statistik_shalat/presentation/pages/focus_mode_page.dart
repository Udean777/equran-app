import 'dart:async';
import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/features/statistik_shalat/domain/entities/shalat_log.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class FocusModePage extends StatefulWidget {
  const FocusModePage({required this.waktu, super.key});

  final WaktuShalat waktu;

  @override
  State<FocusModePage> createState() => _FocusModePageState();
}

class _FocusModePageState extends State<FocusModePage>
    with WidgetsBindingObserver {
  bool _isRunning = false;
  bool _isFailed = false;
  int _durationMinutes = 3;
  late int _remainingSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _remainingSeconds = _durationMinutes * 60;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    unawaited(WakelockPlus.disable());
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_isRunning &&
        (state == AppLifecycleState.paused ||
            state == AppLifecycleState.inactive)) {
      _failFocus();
    }
  }

  void _startFocus() {
    setState(() {
      _isRunning = true;
      _isFailed = false;
      _remainingSeconds = _durationMinutes * 60;
    });
    unawaited(WakelockPlus.enable());

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        _successFocus();
      }
    });
  }

  void _failFocus() {
    _timer?.cancel();
    unawaited(WakelockPlus.disable());
    setState(() {
      _isRunning = false;
      _isFailed = true;
    });
  }

  void _successFocus() {
    _timer?.cancel();
    unawaited(WakelockPlus.disable());
    if (mounted) {
      context.pop(true);
    }
  }

  void _cancel() {
    context.pop(false);
  }

  String get _timerText {
    final m = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    // Memaksa tema gelap agar lebih 'zen'
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        backgroundColor: AppColors.surfaceDark,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppDimens.pagePadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  // Ikon
                  Icon(
                    _isFailed
                        ? Icons.warning_rounded
                        : Icons.self_improvement_rounded,
                    size: 80,
                    color: _isFailed ? AppColors.error : AppColors.gold,
                  ),
                  const SizedBox(height: AppDimens.spaceLG),

                  // Teks Judul
                  Text(
                    _isFailed ? 'Khusyuk Terganggu' : 'Mode Khusyuk',
                    style: AppTypography.serifHeadingMedium.copyWith(
                      color: AppColors.onSurfaceDark,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimens.spaceSM),

                  // Teks Deskripsi
                  Text(
                    _isFailed
                        ? 'Wah, kamu ketahuan membuka aplikasi lain! Waktu shalat dibatalkan, silakan mulai dari awal jika kamu benar-benar ingin shalat.'
                        : (_isRunning
                              ? 'Layar ini akan terus menyala. Silakan letakkan HP Anda dan tunaikan shalat ${widget.waktu.label} dengan khusyuk.'
                              : 'Tentukan durasi shalat Anda. HP dilarang ditutup atau pindah aplikasi selama durasi ini.'),
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.onSurfaceDarkVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimens.spaceXXL),

                  // Timer atau Customizer
                  if (_isRunning)
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.gold.withValues(alpha: 0.3),
                          width: 4,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          _timerText,
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: AppColors.gold,
                            fontFeatures: [FontFeature.tabularFigures()],
                          ),
                        ),
                      ),
                    )
                  else
                    Column(
                      children: [
                        Text(
                          'Durasi: $_durationMinutes Menit',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.onSurfaceDark,
                          ),
                        ),
                        const SizedBox(height: AppDimens.spaceMD),
                        Slider(
                          value: _durationMinutes.toDouble(),
                          min: 3,
                          max: 15,
                          divisions: 12,
                          activeColor: AppColors.gold,
                          onChanged: (val) {
                            setState(() {
                              _durationMinutes = val.toInt();
                              _remainingSeconds = _durationMinutes * 60;
                            });
                          },
                        ),
                      ],
                    ),

                  const Spacer(),

                  // Tombol Aksi
                  if (_isRunning)
                    TextButton.icon(
                      onPressed: _failFocus,
                      icon: const Icon(Icons.close_rounded),
                      label: const Text('Batalkan Shalat'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.error,
                      ),
                    )
                  else
                    Column(
                      children: [
                        FilledButton(
                          onPressed: _startFocus,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.gold,
                            foregroundColor: AppColors.surfaceDark,
                            minimumSize: const Size(double.infinity, 56),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppDimens.radiusLG,
                              ),
                            ),
                          ),
                          child: const Text(
                            'Mulai Shalat',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppDimens.spaceMD),
                        TextButton(
                          onPressed: _cancel,
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.onSurfaceDarkVariant,
                          ),
                          child: const Text('Kembali'),
                        ),
                      ],
                    ),
                  const SizedBox(height: AppDimens.spaceLG),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
