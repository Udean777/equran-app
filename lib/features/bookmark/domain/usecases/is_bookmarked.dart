import 'package:equatable/equatable.dart';
import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/bookmark/domain/repositories/bookmark_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

class IsBookmarkedParams extends Equatable {
  const IsBookmarkedParams({
    required this.suratNomor,
    required this.ayatNomor,
  });

  final int suratNomor;
  final int ayatNomor;

  @override
  List<Object> get props => [suratNomor, ayatNomor];
}

@injectable
class IsBookmarked implements UseCase<bool, IsBookmarkedParams> {
  const IsBookmarked(this._repository);

  final BookmarkRepository _repository;

  @override
  Future<Either<Failure, bool>> call(IsBookmarkedParams params) =>
      _repository.isBookmarked(
        suratNomor: params.suratNomor,
        ayatNomor: params.ayatNomor,
      );
}
