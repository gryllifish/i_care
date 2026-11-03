// Renders the README screenshots from the real app on the sample circle.
// Run through scripts/screenshots.sh; it is not part of the test suite.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:i_care/app/demo_shell.dart';
import 'package:i_care/app/simulated_device.dart';
import 'package:i_care/features/care/data/care_providers.dart';
import 'package:i_care/features/care/data/sample/sample_circle.dart';
import 'package:i_care/features/care/data/sync/simulated_connection.dart';
import 'package:i_care/features/care/data/sync/simulated_server.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/member.dart';
import 'package:i_care/features/care/domain/entities/sync_status.dart';
import 'package:i_care/shared/providers/clock_provider.dart';
import 'package:i_care/shared/providers/device_prefs.dart';

import '../../test/features/care/helpers/care_events.dart';
import '../../test/helpers/pump_app.dart';

/// Wednesday morning: the morning doses given, notes from last night and
/// this morning, and the cardiology visit a day away.
final _now = DateTime(2026, 11, 4, 10, 30);

/// Screenshots are taken at 2x, as on most phones' README images.
const _pixelRatio = 2.0;

/// The sample circle, with the 08:00 Enalapril given on two phones.
List<CareEvent> _circle() {
  final eight = DateTime(_now.year, _now.month, _now.day, 8);
  return [
    ...SampleCircle.events(_now, language: 'en'),
    EventFactory().given(
      'enalapril',
      at: eight.add(const Duration(minutes: 15)),
      slotAt: eight,
      by: SampleCircle.martin.id,
      id: 'screenshot-second-dose',
    ),
  ];
}

MemoryDevicePrefs _phoneOf(Member member) => MemoryDevicePrefs({
  PrefKeys.welcomeSeen: 'true',
  PrefKeys.memberId: member.id,
});

String _shot(String name) => '../../docs/screenshots/$name.png';

/// Loads the bundled font and the Material icons, which tests otherwise
/// draw as boxes.
Future<void> _loadFonts() async {
  Future<void> load(String family, Iterable<String> paths) async {
    final loader = FontLoader(family);
    for (final path in paths) {
      loader.addFont(
        Future.value(ByteData.sublistView(File(path).readAsBytesSync())),
      );
    }
    await loader.load();
  }

  final flutterRoot = Platform.environment['FLUTTER_ROOT'] ?? '';
  const icons = 'bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf';
  await load('AtkinsonHyperlegibleNext', [
    for (final file in Directory('assets/fonts').listSync())
      if (file.path.endsWith('.ttf')) file.path,
  ]);
  await load('MaterialIcons', ['$flutterRoot/$icons']);
}

/// Martín's phone, a caregiver's, on the sample circle.
Future<void> _pumpPhone(WidgetTester tester) async {
  await pumpApp(
    tester,
    repository: FakeCareRepository(_circle())
      ..status = SyncStatus(lastSyncedAt: _now),
    now: _now,
    prefs: _phoneOf(SampleCircle.martin),
  );
  tester.view
    ..physicalSize = phoneSize * _pixelRatio
    ..devicePixelRatio = _pixelRatio;
  await tester.pumpAndSettle();
}

Future<void> _capture(String name) =>
    expectLater(find.byType(MaterialApp).first, matchesGoldenFile(_shot(name)));

Future<void> _tapAndSettle(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> _openTab(WidgetTester tester, String label) => _tapAndSettle(
  tester,
  find.descendant(of: find.byType(NavigationBar), matching: find.text(label)),
);

/// A screenshot test. Tests draw Material shadows as solid outlines unless
/// told otherwise, and the setting must be back before the test ends.
void _screenshot(String description, WidgetTesterCallback body) =>
    testWidgets(description, (tester) async {
      debugDisableShadows = false;
      try {
        await body(tester);
      } finally {
        debugDisableShadows = true;
      }
    });

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await _loadFonts();
  });

  _screenshot('today', (tester) async {
    await _pumpPhone(tester);
    await _capture('today');
  });

  _screenshot('given twice', (tester) async {
    await _pumpPhone(tester);
    await _tapAndSettle(tester, find.text('Review'));
    await _capture('double_dose');
  });

  _screenshot('notes for the circle', (tester) async {
    await _pumpPhone(tester);
    await _tapAndSettle(tester, find.text('LEFT FOR YOU'));
    await _capture('notes');
  });

  _screenshot('medications', (tester) async {
    await _pumpPhone(tester);
    await _openTab(tester, 'Meds');
    await _capture('medications');
  });

  _screenshot('appointment', (tester) async {
    await _pumpPhone(tester);
    await _openTab(tester, 'Visits');
    await _tapAndSettle(tester, find.text('Cardiology'));
    await _capture('appointments');
  });

  _screenshot('emergency card', (tester) async {
    await _pumpPhone(tester);
    await _tapAndSettle(tester, find.byTooltip('Emergency card'));
    await _capture('emergency');
  });

  _screenshot('two phones', (tester) async {
    final server = SimulatedServer(
      await Hive.openBox<String>('screens', bytes: Uint8List(0)),
      await Hive.openBox<String>('screens_devices', bytes: Uint8List(0)),
      await Hive.openBox<String>('screens_codes', bytes: Uint8List(0)),
      await Hive.openBox<String>('screens_settings', bytes: Uint8List(0)),
      clock: () => _now,
    );
    final devices = [
      for (final owner in [SampleCircle.ana, SampleCircle.rosa])
        SimulatedDevice(
          owner: owner,
          container: ProviderContainer(
            overrides: [
              careRepositoryProvider.overrideWithValue(
                FakeCareRepository(_circle())
                  ..status = SyncStatus(lastSyncedAt: _now),
              ),
              simulatedConnectionProvider.overrideWithValue(
                SimulatedConnection(server, deviceId: 'phone-${owner.id}'),
              ),
              devicePrefsProvider.overrideWithValue(_phoneOf(owner)),
              clockProvider.overrideWithValue(() => _now),
            ],
          ),
        ),
    ];
    tester.view
      ..physicalSize = const Size(1000, 1140) * _pixelRatio
      ..devicePixelRatio = _pixelRatio;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(DemoShell(devices: devices));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(DemoShell),
      matchesGoldenFile(_shot('two_phones')),
    );

    // The shell does not own the containers.
    await tester.pumpWidget(const SizedBox());
    for (final device in devices) {
      device.container.dispose();
    }
    await Hive.close();
  });
}
