import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:i_care/app/demo_shell.dart';
import 'package:i_care/app/simulated_device.dart';
import 'package:i_care/features/care/controllers/care_controllers.dart';
import 'package:i_care/features/care/data/care_providers.dart';
import 'package:i_care/features/care/data/sample/sample_circle.dart';
import 'package:i_care/features/care/data/sync/simulated_connection.dart';
import 'package:i_care/features/care/data/sync/simulated_server.dart';
import 'package:i_care/features/care/domain/entities/sync_status.dart';
import 'package:i_care/features/today/presentation/screens/today_screen.dart';
import 'package:i_care/shared/providers/clock_provider.dart';

import '../helpers/pump_app.dart';

void main() {
  late SimulatedServer server;
  late List<SimulatedDevice> devices;
  final connections = <String, SimulatedConnection>{};
  final now = DateTime(2026, 11, 2, 9);

  setUp(() async {
    server = SimulatedServer(
      await Hive.openBox<String>('demo_shell_test', bytes: Uint8List(0)),
      clock: () => now,
    );
    devices = [
      for (final owner in [SampleCircle.ana, SampleCircle.martin])
        SimulatedDevice(
          owner: owner,
          container: ProviderContainer(
            overrides: [
              careRepositoryProvider.overrideWithValue(
                FakeCareRepository()..status = SyncStatus(lastSyncedAt: now),
              ),
              simulatedConnectionProvider.overrideWithValue(
                connections[owner.id] = SimulatedConnection(server),
              ),
              deviceOwnerIdProvider.overrideWithValue(owner.id),
              clockProvider.overrideWithValue(() => now),
            ],
          ),
        ),
    ];
  });

  tearDown(Hive.close);

  /// The shell does not own the containers, so the test disposes them
  /// before Flutter checks that no timers are left.
  Future<void> disposeDevices(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    for (final device in devices) {
      device.container.dispose();
    }
  }

  Future<void> pumpShell(WidgetTester tester, Size size) async {
    tester.view
      ..physicalSize = size
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(DemoShell(devices: devices));
    await tester.pumpAndSettle();
  }

  testWidgets('wide screens show both phones with a network switch', (
    tester,
  ) async {
    await pumpShell(tester, const Size(1200, 1100));

    expect(find.byType(TodayScreen), findsNWidgets(2));
    expect(find.text("Ana's phone"), findsOneWidget);
    expect(find.text("Martín's phone"), findsOneWidget);

    await tester.tap(find.byType(Switch).last);
    await tester.pumpAndSettle();

    expect(connections['martin']?.isOnline, isFalse);
    expect(connections['ana']?.isOnline, isTrue);
    expect(find.text('Offline'), findsOneWidget);
    await disposeDevices(tester);
  });

  testWidgets('phones show only the first phone', (tester) async {
    await pumpShell(tester, phoneSize);

    expect(find.byType(TodayScreen), findsOneWidget);
    expect(find.byType(Switch), findsNothing);
    await disposeDevices(tester);
  });
}
