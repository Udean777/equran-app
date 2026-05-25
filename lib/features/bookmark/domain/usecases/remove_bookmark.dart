import 'package:equatable/equatable.dart';
import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/bookmark/domain/repositories/bookmark_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

class RemoveBookmarkParams extends Equatable {
  const RemoveBookmarkParams({
    required this.suratNomor,
    required this.ayatNomor,
  });

  final int suratNomor;
  final int ayatNomor;

  @override
  List<Object> get props => [suratNomor, ayatNomor];
}

@injectable
class RemoveBookmark implements UseCase<Unit, RemoveBookmarkParams> {
  const RemoveBookmark(this._repository);

  final BookmarkRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(RemoveBookmarkParams params) =>
      _repository.removeBookmark(
        suratNomor: params.suratNomor,
        ayatNomor: params.ayatNomor,
      );
}
