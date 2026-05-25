import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/bookmark/domain/entities/bookmark.dart';
import 'package:equran_app/features/bookmark/domain/entities/last_read.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class BookmarkRepository {
  Future<Either<Failure, List<Bookmark>>> getBookmarks();
  Future<Either<Failure, Unit>> addBookmark(Bookmark bookmark);
  Future<Either<Failure, Unit>> removeBookmark({
    required int suratNomor,
    required int ayatNomor,
  });
  Future<Either<Failure, bool>> isBookmarked({
    required int suratNomor,
    required int ayatNomor,
  });
  Future<Either<Failure, LastRead?>> getLastRead();
  Future<Either<Failure, Unit>> saveLastRead(LastRead lastRead);
}
