import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/doa/data/datasources/doa_bookmark_data_source.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetDoaBookmarks {
  const GetDoaBookmarks(this._dataSource);

  final DoaBookmarkDataSource _dataSource;

  Future<Either<Failure, Set<int>>> call() async {
    try {
      final ids = await _dataSource.getBookmarkedIds();
      return right(ids);
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }
}
