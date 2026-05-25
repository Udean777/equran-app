import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/bookmark/domain/entities/last_read.dart';
import 'package:equran_app/features/bookmark/domain/repositories/bookmark_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class SaveLastRead implements UseCase<Unit, LastRead> {
  const SaveLastRead(this._repository);

  final BookmarkRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(LastRead params) =>
      _repository.saveLastRead(params);
}
