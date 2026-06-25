import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/doa/data/datasources/doa_bookmark_data_source.dart';
import 'package:equran_app/features/doa/domain/repositories/doa_bookmark_repository.dart';
import 'package:fpdart/fpdart.dart';

class DoaBookmarkRepositoryImpl implements DoaBookmarkRepository {
  const DoaBookmarkRepositoryImpl(this._dataSource);

  final DoaBookmarkDataSource _dataSource;

  @override
  Future<Either<Failure, Set<int>>> getBookmarkedIds() async {
    try {
      return right(await _dataSource.getBookmarkedIds());
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> toggleBookmark(int id) async {
    try {
      final isBookmarked = await _dataSource.isBookmarked(id);
      if (isBookmarked) {
        await _dataSource.removeBookmark(id);
        return right(false);
      } else {
        await _dataSource.addBookmark(id);
        return right(true);
      }
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }
}
