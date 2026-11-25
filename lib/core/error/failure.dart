import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  const Failure(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

final class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message =
        'Cannot reach the server. Check your connection and try again.',
  ]);
}

final class OfflineFailure extends Failure {
  const OfflineFailure([
    super.message = 'You are offline and nothing is saved for this screen yet.',
  ]);
}

final class ServerFailure extends Failure {
  const ServerFailure([
    super.message = 'Something went wrong on our side. Please try again.',
  ]);
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure([
    super.message = 'We could not find what you were looking for.',
  ]);
}

final class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Unexpected error. Please try again.']);
}
