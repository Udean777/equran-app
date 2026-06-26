# Contributing to eQuran App

## Architecture Principles

1. **Clean Architecture tri-layer**: `presentation` → `domain` ← `data`
   - `presentation/`: Flutter widgets, Riverpod Notifiers, UI constants
   - `domain/`: Pure Dart entities, repository interfaces, use cases
   - `data/`: Repository impls, data sources, DTOs, platform services
2. **No cross-layer shortcuts**: Presentation never imports from `data/` directly
3. **State management**: `Notifier` only — no `StateNotifier`, no `ChangeNotifier`
4. **Immutable state**: Use `@freezed` sealed classes for ViewModel state
5. **Error handling**: Use `fpdart` `Either<Failure, T>` for all async operations

## Adding a New Feature

### Quick Scaffold

```bash
./scripts/create_feature.sh <feature_name>
```

This creates the full directory structure and template files.

### Manual Steps

1. **Domain layer** (no Flutter deps):
   - Define entity class in `domain/entities/`
   - Define repository interface in `domain/repositories/`
   - Use case classes in `domain/usecases/` — one public method per class

2. **Data layer**:
   - Implement data sources in `data/datasources/`
   - Implement repository in `data/repositories/`
   - DTO/models in `data/models/`

3. **Presentation layer**:
   - State class in `presentation/viewmodels/` — `@freezed` sealed class
   - ViewModel in `presentation/viewmodels/` — `extends AutoDisposeNotifier<State>`
   - Provider registration in `presentation/providers.dart`
   - Pages and widgets in `presentation/pages/` and `presentation/widgets/`

### Wire Providers

```dart
// presentation/providers.dart
final getMyDataProvider = Provider<GetMyData>((ref) {
  return GetMyData(ref.read(myRepositoryProvider));
});

final myViewModelProvider =
    NotifierProvider.autoDispose<MyViewModel, MyState>(
      MyViewModel.new,
    );
```

## ViewModel Migration Guide

### Migrating from StateNotifier

**Before**:
```dart
class MyViewModel extends StateNotifier<MyState> {
  MyViewModel(this._usecase) : super(const MyState.initial());
  final UseCase _usecase;

  Future<void> load() async { ... }
}

final myProvider = StateNotifierProvider<MyViewModel, MyState>(
  (ref) => MyViewModel(ref.read(usecaseProvider)),
);
```

**After**:
```dart
class MyViewModel extends AutoDisposeNotifier<MyState> {
  @override
  MyState build() => const MyState.initial();

  UseCase get _usecase => ref.read(usecaseProvider);

  Future<void> load() async { ... }
}

final myProvider = NotifierProvider.autoDispose<MyViewModel, MyState>(
  MyViewModel.new,
);
```

### Checklist
- [ ] Change `extends StateNotifier<S>` → `extends Notifier<S>` or `extends AutoDisposeNotifier<S>`
- [ ] Remove constructor, add `@override S build()`
- [ ] Replace constructor-injected deps with `ref.read(provider)` getters
- [ ] Replace `StateNotifierProvider` → `NotifierProvider` / `NotifierProvider.autoDispose`
- [ ] Replace factory `(ref) => VM(ref.read(...))` → `VM.new`
- [ ] If family: `extends AutoDisposeFamilyNotifier<S, Arg>`, `build(Arg arg)`, `ref.arg` → `build(arg)`
- [ ] Move eager loading from provider factory to `build()`
- [ ] Replace `dispose()` override with `ref.onDispose(() => ...)` in `build()`
- [ ] Replace `mounted` checks with `ref.onDispose` for subscription cleanup
- [ ] Run `flutter analyze` and `flutter test`

## Code Review Checklist

- [ ] No `StateNotifier`, no `ChangeNotifier`, no `setState` business logic
- [ ] No cross-layer violations (`presentation` → `data` imports)
- [ ] ViewModel extends correct base: `Notifier`, `AutoDisposeNotifier`, or `AutoDisposeFamilyNotifier`
- [ ] Provider uses correct constructor: `VM.new` (not factory lambda)
- [ ] State is `@freezed` sealed class (freezed union)
- [ ] All async calls use `Either<Failure, T>` pattern
- [ ] Stream subscriptions disposed via `ref.onDispose()`
- [ ] Timer instances canceled via `ref.onDispose(() => _timer?.cancel())`
- [ ] `ref.read(provider)` returns State; use `.notifier` for ViewModel
- [ ] No Pluto/GetIt/Injectable in new code
- [ ] `flutter analyze` passes with 0 issues

## Running Verification

```bash
# Static analysis
flutter analyze

# Tests
flutter test

# Generate freezed / build_runner code
dart run build_runner build --delete-conflicting-outputs
```
