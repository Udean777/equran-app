import 'dart:async';

import 'package:equran_app/core/notifications/notification_service.dart';
import 'package:equran_app/core/router/app_routes.dart';
import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/onboarding/data/onboarding_service.dart';
import 'package:equran_app/features/onboarding/presentation/widgets/onboarding_slide_1.dart';
import 'package:equran_app/features/onboarding/presentation/widgets/onboarding_slide_2.dart';
import 'package:equran_app/features/onboarding/presentation/widgets/onboarding_slide_3.dart';
import 'package:equran_app/features/onboarding/presentation/widgets/onboarding_slide_4.dart';
import 'package:equran_app/features/onboarding/presentation/widgets/onboarding_slide_5.dart';
import 'package:equran_app/features/onboarding/presentation/widgets/onboarding_slide_6.dart';
import 'package:equran_app/injection/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _controller = PageController();
  final OnboardingService _onboardingService = getIt<OnboardingService>();
  final NotificationService _notifService = getIt<NotificationService>();

  int _currentPage = 0;
  static const _totalPages = 6;

  bool _locationGranted = false;
  bool _notifGranted = false;
  bool _permissionRequested = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      unawaited(
        _controller.animateToPage(
          _currentPage + 1,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        ),
      );
    } else {
      _finish();
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      unawaited(
        _controller.animateToPage(
          _currentPage - 1,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        ),
      );
    }
  }

  void _finish() {
    unawaited(_onboardingService.markDone());
    context.go(AppRoutes.home);
  }

  Future<void> _requestPermissions() async {
    try {
      final locPerm = await Geolocator.requestPermission();
      setState(() {
        _locationGranted =
            locPerm == LocationPermission.always ||
            locPerm == LocationPermission.whileInUse;
      });
    } on Object {
      setState(() => _locationGranted = false);
    }

    try {
      final granted = await _notifService.requestPermission();
      setState(() => _notifGranted = granted);
    } on Object {
      setState(() => _notifGranted = false);
    }

    setState(() => _permissionRequested = true);
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: const Color(0xFF0A2E1A),
      body: Column(
        children: [
          // PageView — mengisi sisa ruang
          Expanded(
            child: PageView(
              controller: _controller,
              // Nonaktifkan swipe saat slide izin belum selesai
              physics: (_currentPage == 1 && !_permissionRequested)
                  ? const NeverScrollableScrollPhysics()
                  : const BouncingScrollPhysics(),
              onPageChanged: (i) => setState(() => _currentPage = i),
              children: [
                const OnboardingSlide1(),
                OnboardingSlide2(
                  locationGranted: _locationGranted,
                  notifGranted: _notifGranted,
                  permissionRequested: _permissionRequested,
                  onRequestPermissions: _requestPermissions,
                ),
                const OnboardingSlide3(),
                const OnboardingSlide4(),
                const OnboardingSlide5(),
                const OnboardingSlide6(),
              ],
            ),
          ),

          // Bottom nav — sembunyikan saat slide izin belum selesai
          if (_currentPage != 1 || _permissionRequested)
            _BottomNav(
              currentPage: _currentPage,
              totalPages: _totalPages,
              isLastPage: _currentPage == _totalPages - 1,
              isPermissionSlide: _currentPage == 1,
              permissionRequested: _permissionRequested,
              bottomPadding: bottomPadding,
              onNext: _nextPage,
              onPrev: _prevPage,
              onSkip: _finish,
              onFinish: _finish,
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Bottom navigation
// ---------------------------------------------------------------------------

class _BottomNav extends StatelessWidget {
  const _BottomNav({
    required this.currentPage,
    required this.totalPages,
    required this.isLastPage,
    required this.isPermissionSlide,
    required this.permissionRequested,
    required this.bottomPadding,
    required this.onNext,
    required this.onPrev,
    required this.onSkip,
    required this.onFinish,
  });

  final int currentPage;
  final int totalPages;
  final bool isLastPage;
  final bool isPermissionSlide;
  final bool permissionRequested;
  final double bottomPadding;
  final VoidCallback onNext;
  final VoidCallback onPrev;
  final VoidCallback onSkip;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF0A2E1A).withValues(alpha: 0),
            const Color(0xFF0A2E1A),
          ],
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        AppDimens.pagePadding,
        AppDimens.spaceLG,
        AppDimens.pagePadding,
        bottomPadding + AppDimens.spaceLG,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Dot indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              totalPages,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(
                  horizontal: AppDimens.spaceXS,
                ),
                width: i == currentPage ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: i == currentPage
                      ? AppColors.gold
                      : AppColors.gold.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppDimens.spaceMD),

          // Buttons row
          Row(
            children: [
              if (currentPage > 0) ...[
                Expanded(
                  child: _NavButton(
                    label: 'Kembali',
                    isPrimary: false,
                    onTap: onPrev,
                  ),
                ),
                const SizedBox(width: AppDimens.spaceMD),
              ],
              Expanded(
                flex: currentPage > 0 ? 1 : 1,
                child: isLastPage
                    ? _NavButton(
                        label: 'Mulai Sekarang',
                        isPrimary: true,
                        onTap: onFinish,
                      )
                    : isPermissionSlide && !permissionRequested
                    ? _NavButton(
                        label: 'Lewati',
                        isPrimary: false,
                        onTap: onNext,
                      )
                    : _NavButton(
                        label: 'Lanjut',
                        isPrimary: true,
                        onTap: onNext,
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Nav button
// ---------------------------------------------------------------------------

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.label,
    required this.isPrimary,
    required this.onTap,
  });

  final String label;
  final bool isPrimary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (isPrimary) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.gold, AppColors.goldDark],
            ),
            borderRadius: BorderRadius.circular(AppDimens.radiusFull),
            boxShadow: [
              BoxShadow(
                color: AppColors.gold.withValues(alpha: 0.35),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.onGold,
              fontWeight: FontWeight.w700,
              fontSize: 15,
              letterSpacing: 0.3,
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppDimens.radiusFull),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
