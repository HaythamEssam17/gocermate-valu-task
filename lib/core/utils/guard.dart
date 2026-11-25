import 'dart:async';

import 'package:grocermate/core/error/map_error.dart';

import '../network/result.dart';

Future<Result<T>> guard<T>(Future<T> Function() body) async {
  try {
    return Success(await body());
  } catch (e) {
    return Failed(mapError(e));
  }
}
