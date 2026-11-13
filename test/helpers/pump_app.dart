import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/app/app.dart';
import 'package:i_care/core/error/failure.dart';
import 'package:i_care/core/error/result.dart';
import 'package:i_care/features/care/data/care_providers.dart';
import 'package:i_care/features/care/data/sample/sample_circle.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/invite_code.dart';
import 'package:i_care/features/care/domain/entities/rejected_event.dart';
import 'package:i_care/features/care/domain/entities/sync_status.dart';
import 'package:i_care/features/care/domain/repositories/access_repository.dart';
import 'package:i_care/features/care/domain/repositories/care_repository.dart';
import 'package:i_care/features/care/domain/repositories/membership_repository.dart';
import 'package:i_care/shared/providers/clock_provider.dart';
import 'package:i_care/shared/providers/device_prefs.dart';
import 'package:i_care/shared/providers/id_provider.dart';

/// An in-memory log; recorded events stay pending, as on a phone that
/// has not synced them yet.
class FakeCareRepository implements CareRepository {
  /// Holds [events], after the sample circle's members unless [events]
  /// brings members of its own: screens name people from the log.
  FakeCareRepository([List<CareEvent> events = const []])
    : events = [
        if (!events.any((event) => event is MemberInvited))
          ...SampleCircle.circleEvents(DateTime(2025)),
        ...events,
      ];

  final List<CareEvent> events;
  final _changes = StreamController<void>.broadcast();

  /// When set, recording fails with it.
  Failure? failure;

  SyncStatus status = SyncStatus(lastSyncedAt: DateTime(2026));

  /// Events recorded through the app, in order.
  final recorded = <CareEvent>[];

  /// Events the server refused, as the repository reports them.
  final rejected = <RejectedEvent>[];

  @override
  Stream<List<CareEvent>> watchEvents() async* {
    yield List.of(events);
    await for (final _ in _changes.stream) {
      yield List.of(events);
    }
  }

  @override
  Future<Result<void>> record(CareEvent event) async {
    if (failure case final Failure failure) return Err(failure);
    events.add(event);
    recorded.add(event);
    _changes.add(null);
    return const Ok<void>(null);
  }

  /// Adds [event] as if it had arrived from another phone.
  void receive(CareEvent event) {
    events.add(event);
    _changes.add(null);
  }

  @override
  Stream<SyncStatus> watchSyncStatus() => Stream.value(status);

  @override
  Stream<List<RejectedEvent>> watchRejected() => Stream.value(rejected);

  /// How many times someone asked to sync now.
  int syncRequests = 0;

  @override
  Future<Result<void>> syncNow() async {
    syncRequests++;
    return const Ok(null);
  }

  @override
  Future<Result<void>> dismissRejected(String eventId) async {
    rejected.removeWhere((item) => item.event.meta.id == eventId);
    return const Ok(null);
  }
}

/// Answers membership requests without a server: [validCode] joins as
/// [joinsAs]; anything else is an unknown code.
class FakeMembershipRepository implements MembershipRepository {
  static const validCode = 'K7P-4QM';
  String joinsAs = 'martin';

  /// When set, every request fails with it.
  Failure? failure;

  final issuedFor = <String>[];
  int left = 0;
  int forgotten = 0;

  @override
  Future<Result<InviteCode>> issueCode(String memberId) async {
    if (failure case final Failure failure) return Err(failure);
    issuedFor.add(memberId);
    return Ok(InviteCode(code: validCode, expiresAt: DateTime(2026, 11, 4, 9)));
  }

  /// What [createCircle] was asked for.
  final created = <({String creatorName, String recipientName})>[];

  @override
  Future<Result<String>> createCircle({
    required String creatorName,
    required String recipientName,
  }) async {
    if (failure case final Failure failure) return Err(failure);
    created.add((creatorName: creatorName, recipientName: recipientName));
    return Ok(joinsAs);
  }

  @override
  Future<Result<String>> join(String code) async {
    if (failure case final Failure failure) return Err(failure);
    return code.toUpperCase() == validCode
        ? Ok(joinsAs)
        : const Err(InvalidCodeFailure(CodeProblem.unknown));
  }

  @override
  Future<Result<void>> leave(String memberId) async {
    if (failure case final Failure failure) return Err(failure);
    left++;
    return const Ok(null);
  }

  @override
  Future<Result<void>> forget() async {
    forgotten++;
    return const Ok(null);
  }

  int deleted = 0;

  @override
  Future<Result<void>> deleteCircle() async {
    if (failure case final Failure failure) return Err(failure);
    deleted++;
    return const Ok(null);
  }
}

/// Google's picker and the server in one: [account] is the account the
/// person picks (null: they close the picker), and [recoversAs] the
/// member whose access it protects (null: nobody's).
class FakeAccessRepository implements AccessRepository {
  String? account = 'ana@example.com';
  String? recoversAs;
  String? protectedBy;

  /// When set, protecting and recovering fail with it.
  Failure? failure;

  @override
  Future<Result<String?>> protectedWith() async => Ok(protectedBy);

  @override
  Future<Result<String?>> protect() async {
    if (failure case final Failure failure) return Err(failure);
    if (account != null) protectedBy = account;
    return Ok(account);
  }

  @override
  Future<Result<String?>> recover() async {
    if (failure case final Failure failure) return Err(failure);
    if (account == null) return const Ok(null);
    if (recoversAs == null) return const Err(NoAccessFailure());
    protectedBy = account;
    return Ok(recoversAs);
  }
}

/// Logical size of a typical phone.
const phoneSize = Size(393, 852);

/// Pumps one phone's app (real router and screens) on [repository], at
/// [now], with predictable event ids.
Future<void> pumpApp(
  WidgetTester tester, {
  required FakeCareRepository repository,
  required DateTime now,
  Size size = phoneSize,
  List<Override> overrides = const [],

  /// This phone's preferences; by default, Ana's phone past the welcome.
  DevicePrefs? prefs,
  MembershipRepository? membership,

  /// Protecting access with Google; not offered when null, as in the
  /// demo.
  AccessRepository? access,
}) async {
  tester.view
    ..physicalSize = size * 3
    ..devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  var nextId = 0;
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        careRepositoryProvider.overrideWithValue(repository),
        membershipRepositoryProvider.overrideWithValue(
          membership ?? FakeMembershipRepository(),
        ),
        clockProvider.overrideWithValue(() => now),
        newIdProvider.overrideWithValue(() => 'new-${nextId++}'),
        devicePrefsProvider.overrideWithValue(
          prefs ??
              MemoryDevicePrefs({
                PrefKeys.welcomeSeen: 'true',
                PrefKeys.memberId: 'ana',
              }),
        ),
        if (access != null) accessRepositoryProvider.overrideWithValue(access),
        ...overrides,
      ],
      // Riverpod retries failed providers by default; tests want the raw
      // error on screen.
      retry: (_, _) => null,
      child: const App(),
    ),
  );
  await tester.pumpAndSettle();
}
