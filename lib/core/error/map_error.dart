import 'dart:async';

import 'exceptions.dart';
import 'failure.dart';

Failure mapError(Object e) {
  if (e is Failure) return e;
  if (e is NetworkException) return NetworkFailure(e.message);
  if (e is TimeoutException) return const NetworkFailure();
  if (e is ApiException) {
    return e.statusCode == 404
        ? NotFoundFailure(e.message)
        : ServerFailure(e.message);
  }
  if (e is FormatException || e is TypeError) {
    return const UnknownFailure('Received unexpected data from the server.');
  }
  return UnknownFailure(e.toString());
}
