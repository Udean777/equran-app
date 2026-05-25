import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/bookmark/data/datasources/bookmark_local_data_source.dart';
import 'package:equran_app/features/bookmark/data/mappers/bookmark_mapper.dart';
import 'package:equran_app/features/bookmark/domain/entities/bookmark.dart';
import 'package:equran_app/features/bookmark/domain/entities/last_read.dart';
import 'package:equran_app/features/bookmark/domain/repositories/bookmark_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: BookmarkRepository)
class BookmarkRepositoryImpl implements BookmarkRepository {
  const BookmarkRepositoryImpl(this._local);

  final BookmarkLocalDataSource _local;

  @override
  Future<Either<Failure, List<Bookmark>>> getBookmarks() async {
    try {
      final dtos = await _local.getBookmarks();
      return right(dtos.map((e) => e.toEntity()).toList());
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> addBookmark(Bookmark bookmark) async {
    try {
      await _local.addBookmark(bookmark.toDto());
      return right(unit);
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> removeBookmark({
    required int suratNomor,
    required int ayatNomor,
  }) async {
    try {
      await _local.removeBookmark(
        suratNomor: suratNomor,
        ayatNomor: ayatNomor,
      );
      return right(unit);
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isBookmarked({
    required int suratNomor,
    required int ayatNomor,
  }) async {
    try {
      final result = await _local.isBookmarked(
        suratNomor: suratNomor,
        ayatNomor: ayatNomor,
      );
      return right(result);
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, LastRead?>> getLastRead() async {
    try {
      final dto = await _local.getLastRead();
      return right(dto?.toEntity());
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveLastRead(LastRead lastRead) async {
    try {
      await _local.saveLastRead(lastRead.toDto());
      return right(unit);
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }
}
