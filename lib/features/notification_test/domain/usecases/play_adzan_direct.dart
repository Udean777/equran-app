import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/notification_test/domain/repositories/notification_test_repository.dart';
import 'package:fpdart/fpdart.dart';

class PlayAdzanDirectParams {
  const PlayAdzanDirectParams({
    required this.isSubuh,
    required this.waktuNama,
  });

  final bool isSubuh;
  final String waktuNama;
}

class PlayAdzanDirect implements UseCase<Unit, PlayAdzanDirectParams> {
  const PlayAdzanDirect(this._repository);

  final NotificationTestRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(PlayAdzanDirectParams params) =>
      _repository.playAdzanDirect(
        isSubuh: params.isSubuh,
        waktuNama: params.waktuNama,
      );
}
