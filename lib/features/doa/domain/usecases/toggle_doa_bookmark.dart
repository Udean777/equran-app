import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/doa/domain/repositories/doa_bookmark_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class ToggleDoaBookmark implements UseCase<bool, int> {
  const ToggleDoaBookmark(this._repository);

  final DoaBookmarkRepository _repository;

  @override
  Future<Either<Failure, bool>> call(int params) =>
      _repository.toggleBookmark(params);
}
