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
  /// Ambil progress semua surat — key: suratNomor, value: maxScrollPercent
  Either<Failure, Map<int, double>> getAllSuratProgress();
  /// Simpan progress satu surat (hanya update jika lebih tinggi)
  Future<Either<Failure, Unit>> saveSuratProgress(
    int suratNomor,
    double maxProgress,
  );
}
