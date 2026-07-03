import 'dart:async';

import 'package:equran_app/core/providers.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';

const _fullscreenKey = 'fullscreen_mode';

final fullscreenProvider = NotifierProvider<FullscreenNotifier, bool>(
  FullscreenNotifier.new,
);

class FullscreenNotifier extends Notifier<bool> {
  Box<String> get _box => ref.read(settingsBoxProvider);

  @override
  bool build() => false;

  void load() {
    final saved = _box.get(_fullscreenKey);
    if (saved == 'true') {
      state = true;
      unawaited(_apply(true));
    }
  }

  Future<void> toggle() async {
    final next = !state;
    await _box.put(_fullscreenKey, next.toString());
    state = next;
    await _apply(next);
  }

  Future<void> reset() async {
    await _box.delete(_fullscreenKey);
    state = false;
    await _apply(false);
  }

  Future<void> _apply(bool enabled) async {
    if (enabled) {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      await SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: SystemUiOverlay.values,
      );
    }
  }
}
