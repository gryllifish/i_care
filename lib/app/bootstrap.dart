import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:i_care/app/demo_shell.dart';
import 'package:i_care/app/simulated_device.dart';
import 'package:i_care/core/config/env.dart';
import 'package:i_care/core/error/retry_policy.dart';
import 'package:i_care/core/utils/app_logger.dart';
import 'package:i_care/features/care/controllers/care_controllers.dart';
import 'package:i_care/features/care/data/care_providers.dart';
import 'package:i_care/features/care/data/datasources/event_store.dart';
import 'package:i_care/features/care/data/datasources/sync_state_store.dart';
import 'package:i_care/features/care/data/mappers/care_event_codec.dart';
import 'package:i_care/features/care/data/sample/sample_circle.dart';
import 'package:i_care/features/care/data/sync/simulated_server.dart';
import 'package:i_care/features/care/domain/entities/caregiver.dart';

/// Sets up error reporting and storage, seeds the simulated server with
/// sample data on first run, and starts one container per simulated
/// phone.
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    AppLogger.error('Flutter error', details.exception, details.stack);
  };
  PlatformDispatcher.instance.onError = (error, stackTrace) {
    AppLogger.error('Uncaught error', error, stackTrace);
    return true;
  };

  LicenseRegistry.addLicense(_fontLicense);

  await _initStorage();
  final server = SimulatedServer(
    await _openBox(SimulatedServer.boxName),
    clock: DateTime.now,
  );
  if (server.isEmpty) {
    await server.receive([
      for (final event in SampleCircle.events(
        DateTime.now(),
        language: PlatformDispatcher.instance.locale.languageCode,
      ))
        CareEventCodec.encodeString(event),
    ]);
  }

  final devices = [
    for (final owner in [SampleCircle.ana, SampleCircle.martin])
      await _device(owner, server),
  ];

  AppLogger.info('Starting app (${Env.environment.name})');
  runApp(DemoShell(devices: devices));
}

Future<SimulatedDevice> _device(
  Caregiver owner,
  SimulatedServer server,
) async {
  final (events, syncState) = await (
    _openBox(EventStore.boxName(owner.id)),
    _openBox(SyncStateStore.boxName(owner.id)),
  ).wait;
  return SimulatedDevice(
    owner: owner,
    container: ProviderContainer(
      retry: retryPolicy,
      overrides: [
        eventBoxProvider.overrideWithValue(events),
        syncStateBoxProvider.overrideWithValue(syncState),
        simulatedServerProvider.overrideWithValue(server),
        deviceOwnerIdProvider.overrideWithValue(owner.id),
      ],
    ),
  );
}

/// Initializes Hive; a failure is logged, and [_openBox] then falls back.
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

/// The box called [name], on disk (IndexedDB on the web).
///
/// When storage fails or never answers (some browsers leave IndexedDB
/// hanging, e.g. in private windows), falls back to an in-memory box after
/// [_storageTimeout]: the app still starts, and changes last until it
/// closes.
Future<Box<String>> _openBox(String name) async {
  try {
    return await Hive.openBox<String>(name).timeout(_storageTimeout);
    // See _initStorage.
    // ignore: avoid_catches_without_on_clauses
  } catch (error, stackTrace) {
    AppLogger.error('Storage for $name unavailable', error, stackTrace);
    // A distinct name: Hive would hand back the still-pending open instead.
    return Hive.openBox<String>('${name}_memory', bytes: Uint8List(0));
  }
}

const _storageTimeout = Duration(seconds: 4);

Stream<LicenseEntry> _fontLicense() async* {
  final license = await rootBundle.loadString(
    'assets/fonts/OFL-AtkinsonHyperlegibleNext.txt',
  );
  yield LicenseEntryWithLineBreaks(['Atkinson Hyperlegible Next'], license);
}
