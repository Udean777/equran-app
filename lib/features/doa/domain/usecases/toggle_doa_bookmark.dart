import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/doa/data/datasources/doa_bookmark_data_source.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class ToggleDoaBookmark {
  const ToggleDoaBookmark(this._dataSource);

  final DoaBookmarkDataSource _dataSource;

  /// Toggle bookmark doa. Return `true` jika sekarang di-bookmark, `false` jika dihapus.
  Future<Either<Failure, bool>> call(int id) async {
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
