import 'package:equran_app/core/providers.dart';
import 'package:equran_app/features/onboarding/data/onboarding_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final onboardingServiceProvider = Provider<OnboardingService>((ref) {
  return OnboardingService(ref.watch(settingsBoxProvider));
});
