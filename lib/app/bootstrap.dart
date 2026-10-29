import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:i_care/core/config/env.dart';
import 'package:i_care/core/error/retry_policy.dart';
import 'package:i_care/core/utils/app_logger.dart';

/// Sets up error reporting, initializes local storage and runs the app
/// inside a [ProviderScope].
Future<void> bootstrap(Widget Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    AppLogger.error('Flutter error', details.exception, details.stack);
  };
  PlatformDispatcher.instance.onError = (error, stackTrace) {
    AppLogger.error('Uncaught error', error, stackTrace);
    return true;
  };

  await _initStorage();

  AppLogger.info('Starting app (${Env.environment.name})');
  runApp(ProviderScope(retry: retryPolicy, child: builder()));
}

/// Initializes Hive. A failure is logged and the app still starts; boxes
/// then fall back to memory when they are opened.
Future<void> _initStorage() async {
  try {
    await Hive.initFlutter();
    // Hive reports storage problems as HiveError, an Error subclass, and
    // platform storage as exceptions; none of them may stop the app.
    // ignore: avoid_catches_without_on_clauses
  } catch (error, stackTrace) {
    AppLogger.error('Local storage unavailable', error, stackTrace);
  }
}
