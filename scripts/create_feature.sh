#!/bin/bash
# Scaffold a new feature following Clean Architecture + Riverpod conventions.
# Usage: ./scripts/create_feature.sh <feature_name>
# Example: ./scripts/create_feature.sh catatan_ayat

set -euo pipefail

FEATURE=$1

if [ -z "$FEATURE" ]; then
  echo "Usage: $0 <feature_name>"
  exit 1
fi

BASE="lib/features/$FEATURE"

# Capitalize first letter
CAP=$(echo "${FEATURE:0:1}" | tr '[:lower:]' '[:upper:]')"${FEATURE:1}"

echo "Creating feature: $FEATURE ($CAP)"

DIRS=(
  "$BASE/data/constants"
  "$BASE/data/datasources"
  "$BASE/data/models"
  "$BASE/data/repositories"
  "$BASE/data/services"
  "$BASE/domain/constants"
  "$BASE/domain/entities"
  "$BASE/domain/repositories"
  "$BASE/domain/services"
  "$BASE/domain/usecases"
  "$BASE/presentation/constants"
  "$BASE/presentation/pages"
  "$BASE/presentation/utils"
  "$BASE/presentation/viewmodels"
  "$BASE/presentation/widgets"
)

for dir in "${DIRS[@]}"; do
  mkdir -p "$dir"
done

echo "Directories created under $BASE"

# ── Entity ────────────────────────────────────────────────────
ENTITY_FILE="$BASE/domain/entities/${FEATURE}.dart"
if [ ! -f "$ENTITY_FILE" ]; then
  cat > "$ENTITY_FILE" <<EOF
class ${CAP}Entity {
  const ${CAP}Entity();

  ${CAP}Entity copyWith() {
    return ${CAP}Entity();
  }
}
EOF
  echo "  -> $ENTITY_FILE"
fi

# ── Repository Interface ──────────────────────────────────────
REPO_FILE="$BASE/domain/repositories/${FEATURE}_repository.dart"
if [ ! -f "$REPO_FILE" ]; then
  cat > "$REPO_FILE" <<EOF
import 'package:equran_app/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class ${CAP}Repository {
  Future<Either<Failure, void>> fetch();
}
EOF
  echo "  -> $REPO_FILE"
fi

# ── Use Case ──────────────────────────────────────────────────
UC_FILE="$BASE/domain/usecases/get_${FEATURE}.dart"
if [ ! -f "$UC_FILE" ]; then
  cat > "$UC_FILE" <<EOF
import 'package:equran_app/core/usecase/usecase.dart';
import 'package:equran_app/features/$FEATURE/domain/repositories/${FEATURE}_repository.dart';
import 'package:fpdart/fpdart.dart';

class Get${CAP} {
  final ${CAP}Repository _repository;

  Get${CAP}(this._repository);

  Future<Either<Failure, void>> call() => _repository.fetch();
}
EOF
  echo "  -> $UC_FILE"
fi

# ── State ─────────────────────────────────────────────────────
STATE_FILE="$BASE/presentation/viewmodels/${FEATURE}_state.dart"
if [ ! -f "$STATE_FILE" ]; then
  cat > "$STATE_FILE" <<EOF
import 'package:freezed_annotation/freezed_annotation.dart';

part '${FEATURE}_state.freezed.dart';

@freezed
sealed class ${CAP}State with _\$${CAP}State {
  const factory ${CAP}State.initial() = ${CAP}Initial;
  const factory ${CAP}State.loading() = ${CAP}Loading;
  const factory ${CAP}State.success() = ${CAP}Success;
  const factory ${CAP}State.failure(String message) = ${CAP}Failure;
}
EOF
  echo "  -> $STATE_FILE"
fi

# ── ViewModel ─────────────────────────────────────────────────
VM_FILE="$BASE/presentation/viewmodels/${FEATURE}_viewmodel.dart"
if [ ! -f "$VM_FILE" ]; then
  cat > "$VM_FILE" <<EOF
import 'dart:async';
import 'package:equran_app/features/$FEATURE/domain/usecases/get_${FEATURE}.dart';
import 'package:equran_app/features/$FEATURE/presentation/providers.dart';
import 'package:equran_app/features/$FEATURE/presentation/viewmodels/${FEATURE}_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ${CAP}ViewModel extends AutoDisposeNotifier<${CAP}State> {
  @override
  ${CAP}State build() {
    unawaited(load());
    return const ${CAP}State.initial();
  }

  Get${CAP} get _get${CAP} => ref.read(get${CAP}Provider);

  Future<void> load() async {
    state = const ${CAP}State.loading();
    final result = await _get${CAP}();
    result.fold(
      (failure) => state = ${CAP}State.failure(failure.toString()),
      (_) => state = const ${CAP}State.success(),
    );
  }

  void retry() => load();
}
EOF
  echo "  -> $VM_FILE"
fi

# ── Repository Impl ───────────────────────────────────────────
REPO_IMPL_FILE="$BASE/data/repositories/${FEATURE}_repository_impl.dart"
if [ ! -f "$REPO_IMPL_FILE" ]; then
  cat > "$REPO_IMPL_FILE" <<EOF
import 'package:equran_app/core/usecase/usecase.dart';
import 'package:equran_app/features/$FEATURE/domain/repositories/${FEATURE}_repository.dart';
import 'package:fpdart/fpdart.dart';

class ${CAP}RepositoryImpl implements ${CAP}Repository {
  ${CAP}RepositoryImpl();

  @override
  Future<Either<Failure, void>> fetch() async {
    // TODO: implement
    throw UnimplementedError();
  }
}
EOF
  echo "  -> $REPO_IMPL_FILE"
fi

# ── Providers ─────────────────────────────────────────────────
PROV_FILE="$BASE/presentation/providers.dart"
if [ ! -f "$PROV_FILE" ]; then
  cat > "$PROV_FILE" <<EOF
import 'package:equran_app/features/$FEATURE/domain/usecases/get_${FEATURE}.dart';
import 'package:equran_app/features/$FEATURE/presentation/viewmodels/${FEATURE}_state.dart';
import 'package:equran_app/features/$FEATURE/presentation/viewmodels/${FEATURE}_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

export 'viewmodels/${FEATURE}_state.dart';
export 'viewmodels/${FEATURE}_viewmodel.dart';

// ─── Use Cases ──────────────────────────────────────────────

final get${CAP}Provider = Provider<Get${CAP}>((ref) {
  // TODO: inject repository
  throw UnimplementedError('Inject ${CAP}Repository here');
});

// ─── ViewModels ─────────────────────────────────────────────

final ${FEATURE}ViewModelProvider =
    NotifierProvider.autoDispose<${CAP}ViewModel, ${CAP}State>(
      ${CAP}ViewModel.new,
    );
EOF
  echo "  -> $PROV_FILE"
fi

echo ""
echo "Feature '$FEATURE' scaffolded!"
echo ""
echo "Next steps:"
echo "  1. Implement the repository interface & data source"
echo "  2. Wire up providers in $FEATURE/presentation/providers.dart"
echo "  3. Create pages in $FEATURE/presentation/pages/"
echo "  4. Run: dart run build_runner build --delete-conflicting-outputs"
