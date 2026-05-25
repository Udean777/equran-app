import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/bookmark/domain/entities/bookmark.dart';
import 'package:equran_app/features/bookmark/domain/repositories/bookmark_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddBookmark implements UseCase<Unit, Bookmark> {
  const AddBookmark(this._repository);

  final BookmarkRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(Bookmark params) =>
      _repository.addBookmark(params);
}
