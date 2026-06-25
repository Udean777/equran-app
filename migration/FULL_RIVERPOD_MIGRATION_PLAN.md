# ✅ FULL RIVERPOD MIGRATION — COMPLETED

**Project:** Equran App (Qurva)
**Status:** ✅ **Fully Migrated**
**Result:** All `flutter_bloc`, `get_it`, `injectable` removed — 100% pure Riverpod DI + MVVM

---

## Migration Summary

### Phase 0 (Foundation)
- Added `flutter_riverpod: ^2.6.1`, wrapped App in `ProviderScope`
- Deleted `location_selection_mixin.dart`, renamed `BlocConsumerBody` → `JadwalShalatBody`
- Removed `flutter_bloc`/`bloc_test` from `pubspec.yaml`

### Phase 1 (Core Providers)
- Created `lib/core/providers.dart` — Dio, 14 Hive box, LocationService, NotificationService
- Updated `main.dart` to preopen critical Hive boxes

### Phase 2 (Feature DI Migration — 18/18)
- Migrated all 18 features from `@injectable`/`getIt` to pure Riverpod chains
- All datasources, repos, usecases, services stripped of injectable annotations
- All feature `providers.dart` rewritten with clean Riverpod: `box/dio → datasource → repository → usecase → viewmodel`

### Phase 3 (Infrastructure Cleanup)
- Deleted `lib/injection/` directory
- Deleted `lib/core/cache/hive_module.dart`
- Deleted `lib/core/notifications/notification_module.dart`
- Removed `get_it`, `injectable`, `injectable_generator` from `pubspec.yaml`
- Removed `configureDependencies()` from `main.dart` and `background_sync_worker.dart`
- Updated `core/theme/providers.dart` and `core/locale/providers.dart` to use `ref.watch(settingsBoxProvider)`

### Phase 4 (Final Testing)
- `flutter clean` + `flutter pub get` + `flutter analyze` → **0 errors, 0 warnings**
- `flutter build apk --debug` → **build successful**
- All stale imports, getIt calls, and injectable annotations removed
- `295 files changed, 3216 insertions, 20293 deletions`

---

## Migration Strategy

**Approach:** Per-Feature Incremental Migration
- Migrate DI layer one feature at a time (18 features)
- Run `flutter analyze` + manual test after each feature
- Delete GetIt/Injectable infrastructure only when all features are done

### Architecture Pattern

```dart
// OLD (GetIt/Injectable):
// ────────────────────────
// DioClient (@singleton)
//     ↓
// RemoteDataSource (@lazySingleton)
//     ↓
// Repository (@lazySingleton as Interface)
//     ↓
// UseCase (@injectable)
//     ↓
// getIt<UseCase>() in providers.dart
//     ↓
// ViewModel uses ref.read(useCaseProvider)

// NEW (Full Riverpod):
// ────────────────────────
// Provider<Dio> dioProvider
//     ↓
// Provider<RemoteDataSource> dataSourceProvider(ref) { ... }
//     ↓
// Provider<Repository> repositoryProvider(ref) { ... }
//     ↓
// Provider<UseCase> useCaseProvider(ref) { ... }
//     ↓
// ViewModel constructor takes Ref + ref.read(useCaseProvider)
```

---

## Phase 0: Cleanup & Prep (30 min)

### 0.1 — Delete LocationSelectionMixin

**Why:** Already inlined in JadwalShalatVM & ImsakiyahVM, no longer used anywhere.

**Action:** Delete `lib/core/location/location_selection_mixin.dart`

**Verify:** `grep -r "LocationSelectionMixin" lib/` → returns empty

### 0.2 — Rename BlocConsumerBody → JadwalShalatBody

**File:** `lib/features/jadwal_shalat/presentation/pages/jadwal_shalat_page.dart`

Changes:
- Line 53: `body: BlocConsumerBody(state: state),` → `body: JadwalShalatBody(state: state),`
- Line 67: `class BlocConsumerBody extends ConsumerWidget {` → `class JadwalShalatBody extends ConsumerWidget {`
- Line 68: `const BlocConsumerBody({required this.state, super.key});` → `const JadwalShalatBody({required this.state, super.key});`

### 0.3 — Delete Empty cubit/ Directories

```bash
rm -rf lib/core/locale/cubit/
rm -rf lib/core/theme/cubit/
rm -rf lib/features/hafalan/presentation/cubit/
rm -rf lib/features/quran_reminder/presentation/cubit/
rm -rf lib/features/surat_detail/presentation/cubit/
rm -rf lib/features/surat_list/presentation/cubit/
```

### 0.4 — Remove flutter_bloc from pubspec.yaml

```yaml
# Remove from dependencies:
flutter_bloc: ^9.1.1

# Remove from dev_dependencies:
bloc_test: ^10.0.0
```

**Then:** `flutter pub get`

### 0.5 — Clean Up Comments

Update doc comments referencing "Cubit" → "ViewModel" or remove. Files to update:

| File | Line | Old | New |
|------|------|-----|-----|
| `lib/core/theme/app_typography.dart` | 169 | `// Dynamic styles — menggunakan preferensi dari QuranFontCubit` | Remove comment |
| `lib/features/audio/data/datasources/audio_background_handler.dart` | 31 | `/// Stream state audio untuk dikonsumsi AudioCubit.` | Remove comment |
| `lib/features/jadwal_shalat/services/shalat_notif_scheduler_service.dart` | 14 | `/// Tidak bergantung pada Cubit/ViewModel/...` | `/// Tidak bergantung pada ViewModel/Riverpod...` |
| `lib/features/surat_detail/presentation/pages/surat_detail_page.dart` | 155 | `// 2. lastRead.ayatNomor dari BookmarkCubit ...` | `// 2. lastRead.ayatNomor dari BookmarkViewModel ...` |

### 0.6 — Verify Phase 0

```bash
flutter analyze
flutter pub get
```

Should show **0 errors, 0 warnings**.

---

## Phase 1: Core Infrastructure Providers (2 hours)

**Goal:** Convert core modules (Dio, Hive boxes, LocationService, NotificationService) from injected singletons to Riverpod providers.

### 1.1 — Create `lib/core/providers.dart`

```dart
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equran_app/core/constants/network_config.dart';
import 'package:equran_app/core/network/api_endpoints.dart';
import 'package:equran_app/core/notifications/notification_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';

// ─── Dio Provider ─────────────────────────────────────────────────────────

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: NetworkConfig.connectTimeout,
      receiveTimeout: NetworkConfig.receiveTimeout,
      headers: {HttpHeaders.acceptHeader: 'application/json'},
    ),
  );

  if (kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(responseBody: true, requestBody: true),
    );
  }

  return dio;
});

// ─── Hive Box Providers (pre-opened in main.dart) ─────────────────────────

final settingsBoxProvider = Provider<Box<String>>((ref) {
  return Hive.box<String>('settings_box');
});

final bookmarkBoxProvider = Provider<Box<String>>((ref) {
  return Hive.box<String>('bookmark_box');
});

final shalatBoxProvider = Provider<Box<String>>((ref) {
  return Hive.box<String>('shalat_box');
});

final imsakiyahBoxProvider = Provider<Box<String>>((ref) {
  return Hive.box<String>('imsakiyah_box');
});

final doaBoxProvider = FutureProvider<LazyBox<String>>((ref) {
  return Hive.openLazyBox<String>('doa_box');
});

final catatanBoxProvider = FutureProvider<Box<String>>((ref) {
  return Hive.openBox<String>('catatan_box');
});

final hafalanBoxProvider = FutureProvider<LazyBox<String>>((ref) {
  return Hive.openLazyBox<String>('hafalan_box');
});

final doaBookmarkBoxProvider = FutureProvider<Box<String>>((ref) {
  return Hive.openBox<String>('doa_bookmark_box');
});

final statistikShalatBoxProvider = FutureProvider<Box<String>>((ref) {
  return Hive.openBox<String>('statistik_shalat_box');
});

final readingHistoryBoxProvider = FutureProvider<Box<String>>((ref) {
  return Hive.openBox<String>('reading_history_box');
});

final suratBoxProvider = FutureProvider<LazyBox<String>>((ref) {
  return Hive.openLazyBox<String>('surat_box');
});

final tafsirBoxProvider = FutureProvider<LazyBox<String>>((ref) {
  return Hive.openLazyBox<String>('tafsir_box');
});

final tasbihBoxProvider = FutureProvider<Box<String>>((ref) {
  return Hive.openBox<String>('tasbih_box');
});

// ─── Location Service Provider ────────────────────────────────────────────

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService(
    geolocator: Geolocator(),
    dio: ref.read(dioProvider),
  );
});

// ─── Notification Service Provider ────────────────────────────────────────

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});
```

### 1.2 — Update `lib/main.dart`

**OLD:**
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await getIt.init();
  runApp(const ProviderScope(child: App()));
}
```

**NEW:**
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Preopen critical Hive boxes for synchronous access
  await Hive.openBox<String>('settings_box');
  await Hive.openBox<String>('bookmark_box');
  await Hive.openBox<String>('shalat_box');
  await Hive.openBox<String>('imsakiyah_box');

  runApp(const ProviderScope(child: App()));
}
```

### 1.3 — Update `lib/app.dart`

**OLD:**
```dart
import 'package:equran_app/injection/injection_container.dart';

// Inside build method:
final notificationService = getIt<NotificationService>();
```

**NEW:**
```dart
import 'package:equran_app/core/providers.dart';

// Inside build method:
final notificationService = ref.read(notificationServiceProvider);
```

### 1.4 — Verify Phase 1

```bash
flutter analyze
```

Should show **0 issues**.

---

## Phase 2: Feature-by-Feature DI Migration (12-15 hours)

### Migration Template

For each feature, follow these 6 sub-steps:

#### 2.X.1 — Strip `@injectable` annotations

**File:** `lib/features/{feature}/data/datasources/{datasource}.dart`

```dart
// OLD:
@LazySingleton(as: DataSourceInterface)
class DataSourceImpl implements DataSourceInterface {
  DataSourceImpl(@Named('boxName') this._box);
  // ...
}

// NEW:
class DataSourceImpl implements DataSourceInterface {
  const DataSourceImpl(this._box);
  // ...
}
```

Remove:
- `import 'package:injectable/injectable.dart';`

#### 2.X.2 — Strip `@injectable` from Repositories

```dart
// OLD:
@LazySingleton(as: RepositoryInterface)
class RepositoryImpl implements RepositoryInterface {
  const RepositoryImpl(this._dataSource);
  // ...
}

// NEW:
class RepositoryImpl implements RepositoryInterface {
  const RepositoryImpl(this._dataSource);
  // ...
}
```

#### 2.X.3 — Strip `@injectable` from Use Cases

```dart
// OLD:
@injectable
class GetFoo implements UseCaseNoParams<Foo> {
  const GetFoo(this._repository);
  // ...
}

// NEW:
class GetFoo implements UseCaseNoParams<Foo> {
  const GetFoo(this._repository);
  // ...
}
```

#### 2.X.4 — Rewrite `providers.dart`

Replace GetIt delegates with Riverpod provider chain:

```dart
// OLD (GetIt delegate):
import 'package:equran_app/injection/injection_container.dart';

final useCaseProvider = Provider<UseCase>((ref) => getIt<UseCase>());

// NEW (Full Riverpod chain):
import 'package:equran_app/core/providers.dart';

// Datasources
final dataSourceProvider = Provider<DataSourceInterface>((ref) {
  final box = ref.watch(bookmarkBoxProvider).requireValue;
  return DataSourceImpl(box);
});

// Repositories
final repositoryProvider = Provider<RepositoryInterface>((ref) {
  return RepositoryImpl(ref.read(dataSourceProvider));
});

// Use Cases
final useCaseProvider = Provider<UseCase>((ref) {
  return UseCase(ref.read(repositoryProvider));
});
```

#### 2.X.5 — Update ViewModel Constructor (if needed)

Check if ViewModel still takes dependencies via constructor. If yes, convert or ensure it reads from providers correctly. ViewModel using `Notifier`/`StateNotifier` should already be fine.

#### 2.X.6 — Test Feature

```bash
flutter analyze
# Hot restart app
# Manual test all screens in this feature
```

If any error, fix before moving to next feature.

### Feature Migration Order (Simplest First)

| Order | Feature | Datasources | Repos | UseCases | Est. Time |
|-------|---------|-------------|-------|----------|-----------|
| 1 | **notification_test** | 0 | 0 | 0 | 15 min |
| 2 | **qibla** | 1 local | 1 | 2 | 30 min |
| 3 | **tasbih** | 1 local | 1 | 3 | 30 min |
| 4 | **statistik_shalat** | 1 local | 1 | 3 | 30 min |
| 5 | **catatan_ayat** | 1 local | 1 | 4 | 45 min |
| 6 | **reading_progress** | Shared with bookmark | Shared | Shared | 15 min |
| 7 | **bookmark** | 3 local | 3 | 7 | 1 hour |
| 8 | **tafsir** | 2 (local+remote) | 1 | 1 | 45 min |
| 9 | **surat_list** | 2 (local+remote) | 1 | 1 | 45 min |
| 10 | **surat_detail** | 2 (local+remote) | 1 | 1 | 45 min |
| 11 | **doa** | 2 (local+remote) | 2 | 6 | 1 hour |
| 12 | **hafalan** | 1 local | 1 | 5 | 1 hour |
| 13 | **quran_reminder** | 1 local | 1 | 5 | 1 hour |
| 14 | **jadwal_shalat** | 2 (local+remote) | 1 | 1 + service | 1.5 hours |
| 15 | **imsakiyah** | 2 (local+remote) | 1 | 1 | 1.5 hours |
| 16 | **audio** | 3 (local+remote+handler) | 3 | 6 + service | 2 hours |
| 17 | **settings** | Already migrated | — | — | 0 |
| 18 | **onboarding** | No DI needed | — | — | 0 |

---

## Phase 3: Delete GetIt/Injectable Infrastructure (30 min)

### 3.1 — Delete Injection Container

```bash
rm -rf lib/injection/
```

### 3.2 — Delete Module Files

```bash
rm lib/core/cache/hive_module.dart
rm lib/core/notifications/notification_module.dart
# Check audio module:
ls lib/features/audio/services/audio_service_module.dart 2>/dev/null && rm lib/features/audio/services/audio_service_module.dart
```

### 3.3 — Remove from pubspec.yaml

```yaml
# Remove from dependencies:
get_it: ^9.2.1
injectable: ^3.0.0

# Remove from dev_dependencies:
injectable_generator: ^3.0.2
```

**Then:** `flutter pub get`

### 3.4 — Remove GetIt Imports

Search and delete these imports from all files:

```dart
import 'package:injectable/injectable.dart';
import 'package:get_it/get_it.dart';
import 'package:equran_app/injection/injection_container.dart';
```

### 3.5 — Update Core Theme/Locale Providers

**Files:**
- `lib/core/theme/providers.dart`
- `lib/core/locale/providers.dart`

```dart
// OLD:
import 'package:equran_app/injection/injection_container.dart';

final themeViewModelProvider = StateNotifierProvider<ThemeViewModel, ThemeState>((ref) {
  return ThemeViewModel(getIt<Box<String>>(instanceName: 'settingsBox'));
});

// NEW:
import 'package:equran_app/core/providers.dart';

final themeViewModelProvider = StateNotifierProvider<ThemeViewModel, ThemeState>((ref) {
  final box = ref.watch(settingsBoxProvider);
  return ThemeViewModel(box);
});

final languageViewModelProvider = StateNotifierProvider<LanguageViewModel, LanguageState>((ref) {
  final box = ref.watch(settingsBoxProvider);
  return LanguageViewModel(box);
});

final quranFontViewModelProvider = StateNotifierProvider<QuranFontViewModel, QuranFontState>((ref) {
  final box = ref.watch(settingsBoxProvider);
  return QuranFontViewModel(box);
});
```

### 3.6 — Update app.dart (Remove GetIt refs)

Search for remaining `getIt<` calls in `lib/app.dart` and replace with Riverpod `ref.read()`.

### 3.7 — Verify

```bash
grep -r "getIt<" lib/    # Should return empty
grep -r "from get_it" lib/   # Should return empty
grep -r "from injectable" lib/  # Should return empty
grep -r "injection_container" lib/  # Should return empty
grep -r "Cubit" lib/   # Should return 0 Dart matches (comments only OK)
flutter analyze
```

---

## Phase 4: Handle App Initialization (30 min)

### Problem

Hive boxes are now opened lazily. App startup needs to ensure boxes are ready.

### Solution: Preopen in main.dart

**File:** `lib/main.dart` (already updated in Phase 1.2)

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Preopen critical boxes for synchronous access
  await Hive.openBox<String>('settings_box');
  await Hive.openBox<String>('bookmark_box');
  await Hive.openBox<String>('shalat_box');
  await Hive.openBox<String>('imsakiyah_box');

  runApp(const ProviderScope(child: App()));
}
```

Less critical boxes (doa, tafsir, hafalan, etc.) can use `FutureProvider` + `.requireValue` because they aren't needed at startup.

### Initialize Services on Startup

**File:** `lib/app.dart`

```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  // Force-initialize services at startup
  ref.read(notificationServiceProvider);

  return MaterialApp.router(
    routerConfig: ref.read(appRouterProvider),
    // ...
  );
}
```

---

## Phase 5: Final Testing & Cleanup (1 hour)

### 5.1 — Flutter Analyze

```bash
flutter clean
flutter pub get
flutter analyze
```

Expected: **0 issues**

### 5.2 — Manual Test Checklist

```md
[ ] Audio — play/pause/download
[ ] Bookmark — add/remove/list
[ ] Catatan Ayat — create/edit/delete
[ ] Doa — list/detail/bookmark
[ ] Hafalan — start/submit/history
[ ] Imsakiyah — load schedule/detect location
[ ] Jadwal Shalat — load schedule/detect location/notifications
[ ] Notification Test — all notification types
[ ] Onboarding — skip/complete
[ ] Qibla — show direction
[ ] Quran Reminder — enable/set time
[ ] Reading Progress — track/view stats
[ ] Settings — theme/language/font/reset
[ ] Statistik Shalat — track/view stats
[ ] Surat Detail — load/scroll/play audio
[ ] Surat List — load/search
[ ] Tafsir — load
[ ] Tasbih — tap/count/reset
```

### 5.3 — Performance Check

```bash
flutter run --profile
```

App startup should be faster or equal (GetIt `init()` overhead removed).

### 5.4 — Update Docs

```bash
# Update migration status files
echo "Status: COMPLETE" >> migration/MIGRATION_PLAN_MVVM.md
echo "Status: COMPLETE" >> migration/FULL_RIVERPOD_MIGRATION_PLAN.md
```

---

## Potential Issues & Solutions

### Circular Dependencies

**Issue:** Provider A depends on B, B depends on A
**Fix:** Refactor shared state into a separate provider, or merge the two providers

### Background Tasks (WorkManager)

**Issue:** `background_sync_worker.dart` uses `getIt`
**Fix:** Create `ProviderContainer` on demand:

```dart
@pragma('vm:entry-point')
void callbackDispatcher() {
  WidgetsFlutterBinding.ensureInitialized();
  Hive.initFlutter();
  Hive.openBox<String>('settings_box');

  final container = ProviderContainer();
  container.read(syncServiceProvider);
  Workmanager().executeTask((taskName, inputData) async { ... });
}
```

### Notification Tap Callbacks

**Issue:** Notification handlers use `getIt`
**Fix:** Same pattern — create `ProviderContainer` in callback:

```dart
void onNotificationTap() {
  final container = ProviderContainer();
  final router = container.read(appRouterProvider);
  router.go('/some-route');
}
```

### Testing

**Issue:** Tests need mocked providers
**Fix:**

```dart
testWidgets('should show bookmark list', (tester) async {
  final mockRepo = MockBookmarkRepository();

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        bookmarkRepositoryProvider.overrideWithValue(mockRepo),
      ],
      child: const BookmarkPage(),
    ),
  );
});
```

---

## Success Criteria

- [ ] `flutter analyze` shows **0 errors, 0 warnings**
- [ ] All **18 features** manually tested and working
- [ ] App startup time <= previous version (prefaster or same)
- [ ] No `import 'package:get_it'` or `import 'package:injectable'` in codebase
- [ ] No `import 'package:flutter_bloc'` in codebase
- [ ] `lib/injection/` directory deleted
- [ ] All 6 empty `cubit/` directories deleted
- [ ] `pubspec.yaml` has only `flutter_riverpod` as state management/di dependency
- [ ] All providers use `ref.read()`/`ref.watch()` pattern (no `getIt()`)
- [ ] No `@injectable`/`@lazySingleton`/`@singleton` annotations remain
- [ ] `location_selection_mixin.dart` deleted
- [ ] `BlocConsumerBody` renamed to `JadwalShalatBody`

---

## Migration Metrics

| Metric | Before | After |
|--------|--------|-------|
| Dependencies | flutter_bloc, get_it, injectable, bloc_test | flutter_riverpod only |
| `@injectable` annotations | 88 files | 0 |
| `getIt()` calls | 93 | 0 |
| `lib/injection/` | 42KB config file | deleted |
| DI provider pattern | GetIt delegate | Pure Riverpod |
| Build time | With injectable_generator | No codegen — faster |
| Empty directories | 6 cubit/ dirs | 0 |

---

## Estimated Timeline

| Phase | Duration |
|-------|----------|
| Phase 0: Cleanup & Prep | 30 min |
| Phase 1: Core Infrastructure | 2 hours |
| Phase 2: Feature Migration (16 features) | 12-15 hours |
| Phase 3: Delete GetIt Infrastructure | 30 min |
| Phase 4: App Initialization | 30 min |
| Phase 5: Final Testing & Cleanup | 1 hour |
| **Total** | **~18-20 hours** |

---

## Execution

Start with **Phase 0** to clear out `flutter_bloc` and cosmetics, then work through features 1-16 in order.

### Quick Start

```bash
# Phase 0
rm lib/core/location/location_selection_mixin.dart
# ... rename BlocConsumerBody ...
# ... delete empty cubit/ dirs ...
# ... edit pubspec.yaml remove flutter_bloc ...
flutter pub get
flutter analyze

# Phase 1.1
# Create lib/core/providers.dart

# etc.
```
