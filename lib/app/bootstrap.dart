import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:i_care/app/app.dart';
import 'package:i_care/app/demo_shell.dart';
import 'package:i_care/app/simulated_device.dart';
import 'package:i_care/core/config/demo_layout.dart';
import 'package:i_care/core/config/env.dart';
import 'package:i_care/core/error/app_exception.dart';
import 'package:i_care/core/error/retry_policy.dart';
import 'package:i_care/core/utils/app_logger.dart';
import 'package:i_care/features/care/controllers/care_controllers.dart';
import 'package:i_care/features/care/data/care_providers.dart';
import 'package:i_care/features/care/data/datasources/event_store.dart';
import 'package:i_care/features/care/data/datasources/rejected_store.dart';
import 'package:i_care/features/care/data/datasources/storage_key.dart';
import 'package:i_care/features/care/data/datasources/sync_state_store.dart';
import 'package:i_care/features/care/data/mappers/care_event_codec.dart';
import 'package:i_care/features/care/data/repositories/push_repository_impl.dart';
import 'package:i_care/features/care/data/sample/sample_circle.dart';
import 'package:i_care/features/care/data/sync/push_token_gateway.dart';
import 'package:i_care/features/care/data/sync/secure_session_storage.dart';
import 'package:i_care/features/care/data/sync/simulated_server.dart';
import 'package:i_care/features/care/data/sync/supabase_connection.dart';
import 'package:i_care/features/care/domain/entities/member.dart';
import 'package:i_care/features/care/domain/repositories/push_repository.dart';
import 'package:i_care/features/settings/controllers/settings_controllers.dart';
import 'package:i_care/shared/providers/device_prefs.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    show FlutterAuthClientOptions, Supabase;

/// Sets up error reporting and storage, then starts the demo or, in a
/// build for the beta ([SyncBackend.supabase]), this phone alone.
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
  AppLogger.info(
    'Starting app (${Env.environment.name}, ${Env.syncBackend.name})',
  );
  switch (Env.syncBackend) {
    case SyncBackend.simulated:
      await _runDemo();
    case SyncBackend.supabase:
      await _runBeta();
  }
}

/// This phone alone, syncing with the Supabase project the build names
/// (`docs/backend.md`): no sample data, no demo actions. It starts
/// offline too; the device signs in on its first request. Its stores and
/// session hold real health data, so they are encrypted and kept in
/// secure storage (`docs/privacy.md`).
Future<void> _runBeta() async {
  const secure = FlutterSecureStorage();
  HiveCipher? cipher;
  try {
    cipher = await const StorageKey(secure).cipher();
  } on StorageException catch (error, stackTrace) {
    // Never health data on disk unencrypted: this run keeps it in memory,
    // and what is not sent before closing is lost.
    AppLogger.error('Storage key unavailable', error, stackTrace);
  }
  final phone = await _openStores(
    _betaDeviceId,
    cipher: cipher,
    inMemory: cipher == null,
  );
  await Supabase.initialize(
    url: Env.supabaseUrl,
    publishableKey: Env.supabasePublishableKey,
    authOptions: const FlutterAuthClientOptions(
      localStorage: SecureSessionStorage(secure),
    ),
  );
  final connection = SupabaseConnection(Supabase.instance.client);
  final push = await _push(connection);
  final container = ProviderContainer(
    retry: retryPolicy,
    overrides: [
      deviceIdProvider.overrideWithValue(_betaDeviceId),
      eventBoxProvider.overrideWithValue(phone.events),
      rejectedBoxProvider.overrideWithValue(phone.rejected),
      syncStateBoxProvider.overrideWithValue(phone.syncState),
      devicePrefsProvider.overrideWithValue(HiveDevicePrefs(phone.prefs)),
      syncGatewayProvider.overrideWithValue(connection),
      membershipGatewayProvider.overrideWithValue(connection),
      isDemoProvider.overrideWithValue(false),
      pushRepositoryProvider.overrideWithValue(push),
    ],
  );
  runApp(UncontrolledProviderScope(container: container, child: const App()));
}

/// Push notifications through Firebase, for builds that name a Firebase
/// project, on Android and the web; null elsewhere (iOS needs APNs and an
/// Apple Developer account) or when Firebase cannot start.
Future<PushRepository?> _push(PushTokenGateway gateway) async {
  final platform = switch (defaultTargetPlatform) {
    _ when kIsWeb => 'web',
    TargetPlatform.android => 'android',
    _ => null,
  };
  if (platform == null || !Env.hasFirebase) return null;
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: Env.firebaseApiKey,
        appId: kIsWeb ? Env.firebaseWebAppId : Env.firebaseAndroidAppId,
        messagingSenderId: Env.firebaseSenderId,
        projectId: Env.firebaseProjectId,
      ),
    );
  } on FirebaseException catch (error, stackTrace) {
    AppLogger.error('Firebase unavailable', error, stackTrace);
    return null;
  }
  return PushRepositoryImpl(
    messaging: FirebaseMessaging.instance,
    gateway: gateway,
    platform: platform,
    vapidKey: kIsWeb ? Env.firebaseVapidKey : null,
  );
}

/// Names this phone's stores. The server knows the phone by its signed-in
/// user instead, which it may not have yet.
const _betaDeviceId = 'device';

/// Seeds the simulated server with sample data on first run and starts
/// one container per simulated phone: two, or one with `?single` in the
/// address ([DemoLayout]).
Future<void> _runDemo() async {
  final layout = DemoLayout.fromUri(Uri.base);
  // Both demos share the browser's storage: the one-phone demo keeps a
  // server of its own, so neither changes the other's circle.
  final serverPrefix = switch (layout) {
    DemoLayout.twoPhones => '',
    DemoLayout.onePhone => 'single_',
  };
  final server = SimulatedServer(
    await _openBox('$serverPrefix${SimulatedServer.boxName}'),
    await _openBox('$serverPrefix${SimulatedServer.devicesBoxName}'),
    await _openBox('$serverPrefix${SimulatedServer.codesBoxName}'),
    await _openBox('$serverPrefix${SimulatedServer.settingsBoxName}'),
    clock: DateTime.now,
  );
  final owners = switch (layout) {
    // An admin who coordinates and a helper with today's care: the two
    // ends of what roles change (`docs/roles.md`).
    DemoLayout.twoPhones => [SampleCircle.ana, SampleCircle.rosa],
    // A daily caregiver: the app as most of the circle uses it.
    DemoLayout.onePhone => [SampleCircle.martin],
  };
  final phones = [for (final owner in owners) await _openPhone(owner)];
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
            demoLayoutProvider.overrideWithValue(layout),
          ],
        ),
      ),
  ];
  for (final (index, device) in devices.indexed) {
    phones[index].container = device.container;
  }

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
  final stores = await _openStores(owner.id);
  return _Phone(
    owner,
    stores.events,
    stores.rejected,
    stores.syncState,
    stores.prefs,
  );
}

/// One phone's boxes, named after [deviceId]; encrypted with [cipher],
/// or kept in memory only.
Future<
  ({
    Box<String> events,
    Box<String> rejected,
    Box<String> syncState,
    Box<String> prefs,
  })
>
_openStores(
  String deviceId, {
  HiveCipher? cipher,
  bool inMemory = false,
}) async {
  Future<Box<String>> open(String name) =>
      inMemory ? _openMemoryBox(name) : _openBox(name, cipher: cipher);
  final (events, rejected, syncState, prefs) = await (
    open(EventStore.boxName(deviceId)),
    open(RejectedStore.boxName(deviceId)),
    open(SyncStateStore.boxName(deviceId)),
    open(HiveDevicePrefs.boxName(deviceId)),
  ).wait;
  return (
    events: events,
    rejected: rejected,
    syncState: syncState,
    prefs: prefs,
  );
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
Future<Box<String>> _openBox(String name, {HiveCipher? cipher}) async {
  try {
    return await Hive.openBox<String>(
      name,
      encryptionCipher: cipher,
    ).timeout(_storageTimeout);
    // See _initStorage.
    // ignore: avoid_catches_without_on_clauses
  } catch (error, stackTrace) {
    AppLogger.error('Storage for $name unavailable', error, stackTrace);
    return await _openMemoryBox(name);
  }
}

/// A box that lives until the app closes.
Future<Box<String>> _openMemoryBox(String name) =>
    // A distinct name: Hive would hand back a still-pending open instead.
    Hive.openBox<String>('${name}_memory', bytes: Uint8List(0));

const _storageTimeout = Duration(seconds: 4);

Stream<LicenseEntry> _fontLicense() async* {
  final license = await rootBundle.loadString(
    'assets/fonts/OFL-AtkinsonHyperlegibleNext.txt',
  );
  yield LicenseEntryWithLineBreaks(['Atkinson Hyperlegible Next'], license);
}
