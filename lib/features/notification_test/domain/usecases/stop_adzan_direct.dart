import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/notification_test/domain/repositories/notification_test_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class StopAdzanDirect implements UseCaseNoParams<Unit> {
  const StopAdzanDirect(this._repository);

  final NotificationTestRepository _repository;

  @override
  Future<Either<Failure, Unit>> call() => _repository.stopAdzanDirect();
}
