import 'package:equran_app/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class DoaBookmarkRepository {
  Future<Either<Failure, Set<int>>> getBookmarkedIds();
  Future<Either<Failure, bool>> toggleBookmark(int id);
}
