import 'package:equatable/equatable.dart';
import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/notification_test/domain/repositories/notification_test_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

class PlayAdzanDirectParams extends Equatable {
  const PlayAdzanDirectParams({
    required this.isSubuh,
    required this.waktuNama,
  });

  final bool isSubuh;
  final String waktuNama;

  @override
  List<Object?> get props => [isSubuh, waktuNama];
}

@injectable
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
