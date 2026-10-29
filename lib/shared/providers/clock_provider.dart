import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'clock_provider.g.dart';

/// Reads the current time. A function rather than a value, so every call
/// is fresh; tests override it with a fake clock.
@Riverpod(keepAlive: true)
DateTime Function() clock(Ref ref) => DateTime.now;
