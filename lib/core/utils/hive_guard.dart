import 'package:hive_ce/hive.dart';
import 'package:i_care/core/error/app_exception.dart';

/// Runs [action] and turns Hive's storage errors into a
/// [StorageException] describing [what].
///
/// Hive reports I/O and closed-box problems as `HiveError`, an `Error`
/// subclass, so it has to be caught to stay a typed failure.
T hiveGuard<T>(String what, T Function() action) {
  try {
    return action();
    // See above.
    // ignore: avoid_catching_errors
  } on HiveError catch (error) {
    throw StorageException('$what unavailable', cause: error);
  }
}

/// Like [hiveGuard], for writes, which fail asynchronously.
Future<void> hiveGuardAsync(String what, Future<void> Function() action) async {
  try {
    await action();
    // See hiveGuard.
    // ignore: avoid_catching_errors
  } on HiveError catch (error) {
    throw StorageException('$what unavailable', cause: error);
  }
}
