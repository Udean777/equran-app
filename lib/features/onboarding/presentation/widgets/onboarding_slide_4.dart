import 'package:equran_app/features/onboarding/presentation/widgets/onboarding_shared.dart';
import 'package:flutter/material.dart';

/// Slide 4 — Fitur Jadwal Shalat & Adzan
class OnboardingSlide4 extends StatelessWidget {
  const OnboardingSlide4({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnboardingSlideBase(
      child: OnboardingFeatureSlide(
        icon: Icons.mosque_rounded,
        title: 'Jadwal Shalat & Adzan',
        subtitle: 'Tepat waktu setiap hari',
        description:
            'Jadwal shalat akurat berdasarkan lokasi GPS kamu. '
            'Notifikasi adzan otomatis agar tidak terlewat satu pun waktu shalat.',
        features: [
          OnboardingFeaturePoint(
            icon: Icons.location_on_rounded,
            text: 'Jadwal shalat otomatis sesuai lokasi GPS',
          ),
          OnboardingFeaturePoint(
            icon: Icons.notifications_active_rounded,
            text: 'Notifikasi adzan dengan suara adzan asli',
          ),
          OnboardingFeaturePoint(
            icon: Icons.nightlight_round,
            text: 'Alarm imsak & sahur untuk Ramadan',
          ),
          OnboardingFeaturePoint(
            icon: Icons.explore_rounded,
            text: 'Kompas kiblat real-time',
          ),
        ],
      ),
    );
  }
}
