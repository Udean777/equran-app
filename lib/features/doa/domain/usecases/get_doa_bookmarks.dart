import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/doa/domain/repositories/doa_bookmark_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetDoaBookmarks implements UseCaseNoParams<Set<int>> {
  const GetDoaBookmarks(this._repository);

  final DoaBookmarkRepository _repository;

  @override
  Future<Either<Failure, Set<int>>> call() => _repository.getBookmarkedIds();
}
