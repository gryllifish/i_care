import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/core/error/result.dart';
import 'package:i_care/features/care/controllers/care_controllers.dart';
import 'package:i_care/features/care/controllers/membership_actions.dart';
import 'package:i_care/features/care/data/care_providers.dart';
import 'package:i_care/features/care/data/datasources/event_store.dart';
import 'package:i_care/features/care/data/datasources/rejected_store.dart';
import 'package:i_care/features/care/data/datasources/sync_state_store.dart';
import 'package:i_care/features/care/data/mappers/care_event_codec.dart';
import 'package:i_care/features/care/data/sample/sample_circle.dart';
import 'package:i_care/features/care/data/sync/simulated_connection.dart';
import 'package:i_care/features/care/data/sync/simulated_server.dart';
import 'package:i_care/features/care/domain/entities/invite_code.dart';
import 'package:i_care/shared/providers/clock_provider.dart';
import 'package:i_care/shared/providers/device_prefs.dart';

import '../features/care/helpers/hive_boxes.dart';

/// The real stack the demo runs (server, connections, repositories and
/// providers wired as in `bootstrap`), without widgets.
void main() {
  final openBox = useTemporaryHive();
  final now = DateTime(2026, 11, 2, 9);
  late SimulatedServer server;

  setUp(() async {
    server = SimulatedServer(
      await openBox(SimulatedServer.boxName),
      await openBox(SimulatedServer.devicesBoxName),
      await openBox(SimulatedServer.codesBoxName),
      clock: () => now,
    );
    await server.seed([
      for (final event in SampleCircle.memberEvents(DateTime(2025)))
        CareEventCodec.encodeString(event),
    ]);
  });

  /// [memberId]'s phone, joined, as `bootstrap` sets it up.
  Future<ProviderContainer> phone(String memberId) async {
    final deviceId = 'phone-$memberId';
    await server.bind(deviceId, memberId);
    final container = ProviderContainer.test(
      overrides: [
        deviceIdProvider.overrideWithValue(deviceId),
        eventBoxProvider.overrideWithValue(
          await openBox(EventStore.boxName(memberId)),
        ),
        rejectedBoxProvider.overrideWithValue(
          await openBox(RejectedStore.boxName(memberId)),
        ),
        syncStateBoxProvider.overrideWithValue(
          await openBox(SyncStateStore.boxName(memberId)),
        ),
        devicePrefsProvider.overrideWithValue(
          MemoryDevicePrefs({
            PrefKeys.welcomeSeen: 'true',
            PrefKeys.memberId: memberId,
          }),
        ),
        simulatedServerProvider.overrideWithValue(server),
        simulatedConnectionProvider.overrideWith(
          (ref) => SimulatedConnection(server, deviceId: deviceId),
        ),
        clockProvider.overrideWithValue(() => now),
      ],
    );
    // Starts syncing, as the app does on its first screen.
    return container..read(careRepositoryImplProvider);
  }

  test('a phone leaves, an admin makes a code, and it joins again', () async {
    final ana = await phone('ana');
    final martin = await phone('martin');

    expect(
      await martin.read(membershipActionsProvider.notifier).leave(),
      isA<Ok<void>>(),
    );
    expect(martin.read(deviceMembershipProvider), isNull);
    expect(server.isActive('phone-martin'), isFalse);

    final code = await ana
        .read(membershipActionsProvider.notifier)
        .newCode(SampleCircle.martin);
    final value = (code as Ok<InviteCode>).value.code;
    expect(value, matches(RegExp(r'^[A-Z2-9]{3}-[A-Z2-9]{3}$')));

    expect(
      await martin.read(membershipActionsProvider.notifier).join(value),
      isA<Ok<void>>(),
    );
    expect(martin.read(deviceMembershipProvider), 'martin');
    expect(server.isActive('phone-martin'), isTrue);
  });

  test('a removed phone learns it, after sending what it had', () async {
    final ana = await phone('ana');
    final rosa = await phone('rosa');

    final removed = await ana
        .read(membershipActionsProvider.notifier)
        .remove(SampleCircle.rosa);
    expect(removed, isA<Ok<void>>());

    final status = await rosa
        .read(careRepositoryProvider)
        .watchSyncStatus()
        .firstWhere((status) => !status.isMember)
        .timeout(const Duration(seconds: 5));
    expect(status.isMember, isFalse);
  });
}
