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
import 'package:i_care/features/care/data/datasources/rejected_store.dart';
import 'package:i_care/features/care/data/datasources/sync_state_store.dart';
import 'package:i_care/features/care/data/mappers/care_event_codec.dart';
import 'package:i_care/features/care/data/sample/sample_circle.dart';
import 'package:i_care/features/care/data/sync/simulated_server.dart';
import 'package:i_care/features/care/domain/entities/member.dart';
import 'package:i_care/features/settings/controllers/settings_controllers.dart';
import 'package:i_care/shared/providers/device_prefs.dart';

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
    await _openBox(SimulatedServer.devicesBoxName),
    await _openBox(SimulatedServer.codesBoxName),
    await _openBox(SimulatedServer.settingsBoxName),
    clock: DateTime.now,
  );
  final phones = [
    // An admin who coordinates and a helper with today's care: the two
    // ends of what roles change (`docs/roles.md`).
    for (final owner in [SampleCircle.ana, SampleCircle.rosa])
      await _openPhone(owner),
  ];
  // The sample on the first start; again for a log saved before circles
  // recorded how they began. An empty server the user asked for stays
  // empty.
  final firstStart = server.isEmpty && !server.startedEmpty;
  if (firstStart || (!server.isEmpty && !server.hasCircle)) {
    await _clearAll(server, phones);
    await _seed(server, phones);
  }
  await _restoreMembers(server, phones);
  Future<void> resetDemo() => _reset(server, phones);
  Future<void> startEmpty() => _startEmpty(server, phones);
  final devices = [
    for (final phone in phones)
      SimulatedDevice(
        owner: phone.owner,
        container: ProviderContainer(
          retry: retryPolicy,
          overrides: [
            deviceIdProvider.overrideWithValue(phone.deviceId),
            eventBoxProvider.overrideWithValue(phone.events),
            rejectedBoxProvider.overrideWithValue(phone.rejected),
            syncStateBoxProvider.overrideWithValue(phone.syncState),
            devicePrefsProvider.overrideWithValue(HiveDevicePrefs(phone.prefs)),
            simulatedServerProvider.overrideWithValue(server),
            demoResetProvider.overrideWithValue(resetDemo),
            demoStartEmptyProvider.overrideWithValue(startEmpty),
          ],
        ),
      ),
  ];
  for (final (index, device) in devices.indexed) {
    phones[index].container = device.container;
  }

  AppLogger.info('Starting app (${Env.environment.name})');
  runApp(DemoShell(devices: devices));
}

/// One simulated phone's storage, and its container once created.
class _Phone {
  _Phone(this.owner, this.events, this.rejected, this.syncState, this.prefs);

  final Member owner;
  final Box<String> events;
  final Box<String> rejected;
  final Box<String> syncState;
  final Box<String> prefs;
  ProviderContainer? container;

  /// How the server knows this phone; joined as [owner] in the demo.
  String get deviceId => 'phone-${owner.id}';
}

Future<_Phone> _openPhone(Member owner) async {
  final (events, rejected, syncState, prefs) = await (
    _openBox(EventStore.boxName(owner.id)),
    _openBox(RejectedStore.boxName(owner.id)),
    _openBox(SyncStateStore.boxName(owner.id)),
    _openBox(HiveDevicePrefs.boxName(owner.id)),
  ).wait;
  return _Phone(owner, events, rejected, syncState, prefs);
}

/// Loads the sample circle into the server, in the device's language,
/// and binds each phone to its owner, as if they had joined with a code.
Future<void> _seed(SimulatedServer server, List<_Phone> phones) async {
  await server.seed([
    for (final event in SampleCircle.events(
      DateTime.now(),
      language: PlatformDispatcher.instance.locale.languageCode,
    ))
      CareEventCodec.encodeString(event),
  ]);
  for (final phone in phones) {
    await server.bind(phone.deviceId, phone.owner.id);
    await HiveDevicePrefs(phone.prefs).write(PrefKeys.memberId, phone.owner.id);
  }
}

/// Tells each phone whose it is when it does not know: phones saved
/// before they kept it themselves, and demo phones the server has never
/// seen (a newer demo's), which join as their owners. A phone that left
/// keeps asking for a code: the server knows it, with no current member.
Future<void> _restoreMembers(
  SimulatedServer server,
  List<_Phone> phones,
) async {
  for (final phone in phones) {
    final prefs = HiveDevicePrefs(phone.prefs);
    if (prefs.read(PrefKeys.memberId) != null) continue;
    if (!server.knowsDevice(phone.deviceId) &&
        server.hasMember(phone.owner.id)) {
      await server.bind(phone.deviceId, phone.owner.id);
    }
    if (server.activeMemberOf(phone.deviceId) case final String memberId) {
      await prefs.write(PrefKeys.memberId, memberId);
    }
  }
}

/// Empties the server and every phone's stores.
Future<void> _clearAll(SimulatedServer server, List<_Phone> phones) async {
  await server.clear();
  for (final phone in phones) {
    await EventStore(phone.events).clear();
    await RejectedStore(phone.rejected).clear();
    await SyncStateStore(phone.syncState).clear();
    await HiveDevicePrefs(phone.prefs).write(PrefKeys.memberId, null);
  }
}

/// Clears every phone and the server, then seeds again. Each phone stops
/// syncing first and restarts afterwards from an empty cursor, so none
/// keeps a position from the old log; a phone that had left the circle
/// is its owner's again.
Future<void> _reset(SimulatedServer server, List<_Phone> phones) async {
  final containers = [for (final phone in phones) ?phone.container];
  for (final container in containers) {
    await container.read(careRepositoryImplProvider).stop();
  }
  await _clearAll(server, phones);
  await _seed(server, phones);
  for (final (index, container) in containers.indexed) {
    await container
        .read(deviceMembershipProvider.notifier)
        .joined(phones[index].owner.id);
    await container.read(welcomeSeenProvider.notifier).markSeen();
    await container.read(careRepositoryImplProvider).restart();
  }
}

/// Clears every phone and the server, leaving them without a circle: the
/// phones then offer to create one or join one, as on a first install.
Future<void> _startEmpty(SimulatedServer server, List<_Phone> phones) async {
  final containers = [for (final phone in phones) ?phone.container];
  for (final container in containers) {
    await container.read(careRepositoryImplProvider).stop();
  }
  await _clearAll(server, phones);
  await server.startEmpty();
  for (final container in containers) {
    await container.read(deviceMembershipProvider.notifier).cleared();
    await container.read(careRepositoryImplProvider).restart();
  }
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
    return await Hive.openBox<String>('${name}_memory', bytes: Uint8List(0));
  }
}

const _storageTimeout = Duration(seconds: 4);

Stream<LicenseEntry> _fontLicense() async* {
  final license = await rootBundle.loadString(
    'assets/fonts/OFL-AtkinsonHyperlegibleNext.txt',
  );
  yield LicenseEntryWithLineBreaks(['Atkinson Hyperlegible Next'], license);
}
