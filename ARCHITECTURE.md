# eQuran App — Architecture Guide

## Clean Architecture Tri-Layer

```
feature_name/
├── data/
│   ├── constants/        API configs, endpoints
│   ├── datasources/      Local/remote data access
│   ├── models/           DTOs, JSON serialization
│   ├── repositories/     Repository implementations
│   └── services/         Infrastructure services (schedulers, etc)
├── domain/
│   ├── constants/        Business rules, thresholds
│   ├── entities/         Business models
│   ├── repositories/     Repository contracts
│   ├── services/         Domain services (orchestration)
│   └── usecases/         Use cases
└── presentation/
    ├── constants/        UI strings, colors, dimensions
    ├── pages/            Screen widgets
    ├── utils/            Presentation helpers
    ├── viewmodels/       Riverpod Notifiers
    └── widgets/          Reusable components
```

### Layer Rules

| Layer | Dependencies | Contains |
|-------|-------------|----------|
| **domain** | Pure Dart only | Entities, repository interfaces, use cases, domain services |
| **data** | domain + external packages | Repository implementations, data sources, models, DTOs |
| **presentation** | domain + Flutter | ViewModels (Notifiers), pages, widgets, UI constants |

**Golden rule**: `presentation` → `domain` ← `data`. Presentation never imports from `data` directly.

---

## State Management: Riverpod Notifier

All ViewModels extend one of these:

```dart
// Standard Notifier (persists for provider lifetime)
class MyViewModel extends Notifier<MyState> { ... }

// Auto-dispose Notifier (disposed when no longer watched)
class MyViewModel extends AutoDisposeNotifier<MyState> { ... }

// Family Notifier (parameterized, auto-dispose)
class MyViewModel extends AutoDisposeFamilyNotifier<MyState, int> { ... }
```

### ViewModel Template

```dart
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// State is a freezed sealed class
@freezed
sealed class CounterState with _$CounterState {
  const factory CounterState.initial() = CounterInitial;
  const factory CounterState.loading() = CounterLoading;
  const factory CounterState.success({required int value}) = CounterSuccess;
  const factory CounterState.failure(String message) = CounterFailure;
}

class CounterViewModel extends AutoDisposeNotifier<CounterState> {
  @override
  CounterState build() {
    // Eager loading (optional)
    unawaited(load());
    return const CounterState.initial();
  }

  // Dependencies via ref.read()
  GetCounterValue get _getCounterValue => ref.read(getCounterValueProvider);
  SaveCounterValue get _saveCounterValue => ref.read(saveCounterValueProvider);

  Future<void> load() async {
    state = const CounterState.loading();
    final result = await _getCounterValue();
    result.fold(
      (failure) => state = CounterState.failure(failure.toString()),
      (value) => state = CounterState.success(value: value),
    );
  }

  Future<void> increment() async {
    final current = state;
    if (current is! CounterSuccess) return;
    await _saveCounterValue(current.value + 1);
    unawaited(load());
  }
}
```

### Provider Registration

```dart
// Standard
final counterViewModelProvider =
    NotifierProvider<CounterViewModel, CounterState>(
      CounterViewModel.new,
    );

// Auto-dispose
final counterViewModelProvider =
    NotifierProvider.autoDispose<CounterViewModel, CounterState>(
      CounterViewModel.new,
    );

// Family (parameterized)
final counterViewModelProvider =
    NotifierProvider.autoDispose.family<CounterViewModel, CounterState, int>(
      CounterViewModel.new,
    );
```

### Consumer Pattern

```dart
// Read state
final state = ref.watch(counterViewModelProvider);

// Call methods
ref.read(counterViewModelProvider.notifier).increment();
```

> **Note**: `ref.read(provider)` returns **State**, not the ViewModel.
> Use `.notifier` to access the ViewModel instance.

---

## Cross-ViewModel Communication

Use `ref.read(otherProvider.notifier)` instead of constructor injection:

```dart
class DetailViewModel extends AutoDisposeFamilyNotifier<DetailState, int> {
  @override
  DetailState build(int id) { ... }

  // Access another ViewModel
  ListViewModel get _listNotifier => ref.read(listViewModelProvider.notifier);

  Future<void> delete(int id) async {
    await _repository.delete(id);
    await _loadDetail(id);
    await _listNotifier.load(); // Refresh the list
  }
}
```

For invalidating cached providers:

```dart
ref.invalidate(cachedDataProvider);
```

---

## Cleanup & Lifecycle

```dart
class AudioViewModel extends Notifier<AudioPlayerState> {
  StreamSubscription? _subscription;

  @override
  AudioPlayerState build() {
    _subscription = someStream.listen((event) {
      state = event;
    });
    ref.onDispose(() => unawaited(_subscription?.cancel()));
    return const AudioPlayerState.idle();
  }
}
```

- No `dispose()` override — use `ref.onDispose()`
- Timer cleanup: `ref.onDispose(() => _timer?.cancel())`
- No `mounted` property — subscription cancellation via `ref.onDispose` prevents stale state updates

---

## File Naming Conventions

| Layer | Convention | Example |
|-------|-----------|---------|
| Use case | `verb_noun.dart` | `get_surat_detail.dart` |
| Repository | `{feature}_repository.dart` | `hafalan_repository.dart` |
| Data source | `{feature}_{type}_datasource.dart` | `audio_remote_datasource.dart` |
| ViewModel | `{feature}_viewmodel.dart` | `surat_list_viewmodel.dart` |
| State | `{feature}_state.dart` | `jadwal_shalat_state.dart` |
| Provider | `providers.dart` | `hafalan/providers.dart` |
| Constants | `{feature}_constants.dart` | `tafsir_constants.dart` |

---

## Tech Stack (Current)

| Concern | Choice |
|---------|--------|
| State management | Riverpod 2.x (`flutter_riverpod`) |
| Navigation | GoRouter |
| Local DB | Hive CE |
| HTTP | Dio |
| Functional types | `fpdart` (Either) |
| Immutable models | Freezed |
| Audio player | `just_audio` + `audio_service` |
| Background audio | `audio_service` |
| Notifications | `flutter_local_notifications` |
| GPS | `geolocator` + `geocoding` |
| Qibla compass | `flutter_compass` |
| Location matching | Custom `LocationMatchingService` |
