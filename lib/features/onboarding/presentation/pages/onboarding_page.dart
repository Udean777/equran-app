import 'dart:async';

import 'package:equran_app/core/notifications/notification_service.dart';
import 'package:equran_app/core/router/app_routes.dart';
import 'package:equran_app/features/onboarding/constants/onboarding_constants.dart';
import 'package:equran_app/features/onboarding/data/onboarding_service.dart';
import 'package:equran_app/features/onboarding/presentation/widgets/onboarding_bottom_nav.dart';
import 'package:equran_app/features/onboarding/presentation/widgets/onboarding_slide_1.dart';
import 'package:equran_app/features/onboarding/presentation/widgets/onboarding_slide_2.dart';
import 'package:equran_app/features/onboarding/presentation/widgets/onboarding_slide_3.dart';
import 'package:equran_app/features/onboarding/presentation/widgets/onboarding_slide_4.dart';
import 'package:equran_app/features/onboarding/presentation/widgets/onboarding_slide_5.dart';
import 'package:equran_app/features/onboarding/presentation/widgets/onboarding_slide_6.dart';
import 'package:equran_app/injection/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: OnboardingColors.background,
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
              OnboardingBottomNav(
                currentPage: _currentPage,
                totalPages: _totalPages,
                isLastPage: _currentPage == _totalPages - 1,
                isPermissionSlide: _currentPage == 1,
                permissionRequested: _permissionRequested,
                allPermissionsGranted: _locationGranted && _notifGranted,
                bottomPadding: bottomPadding,
                onNext: _nextPage,
                onPrev: _prevPage,
                onSkip: _finish,
                onFinish: _finish,
              ),
          ],
        ),
      ),
    );
  }
}
