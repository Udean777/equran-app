import 'package:equran_app/core/providers.dart';
import 'package:equran_app/core/router/app_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appRouterProvider = Provider<AppRouter>((ref) {
  final box = ref.watch(settingsBoxProvider);
  return AppRouter(
    isOnboardingDone: () => box.get('onboarding_done') == 'true',
  );
});
