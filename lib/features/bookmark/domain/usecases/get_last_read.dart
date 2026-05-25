import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/bookmark/domain/entities/last_read.dart';
import 'package:equran_app/features/bookmark/domain/repositories/bookmark_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetLastRead implements UseCaseNoParams<LastRead?> {
  const GetLastRead(this._repository);

  final BookmarkRepository _repository;

  @override
  Future<Either<Failure, LastRead?>> call() => _repository.getLastRead();
}
