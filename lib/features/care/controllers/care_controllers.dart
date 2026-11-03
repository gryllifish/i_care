import 'dart:async';

import 'package:i_care/core/error/result.dart';
import 'package:i_care/features/care/data/care_providers.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/member.dart';
import 'package:i_care/features/care/domain/entities/rejected_event.dart';
import 'package:i_care/features/care/domain/entities/sync_status.dart';
import 'package:i_care/features/care/domain/permissions.dart';
import 'package:i_care/features/care/domain/projections/care_log.dart';
import 'package:i_care/shared/providers/device_prefs.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'care_controllers.g.dart';

/// The care circle's state on this device, re-projected on every change.
@Riverpod(keepAlive: true)
Stream<CareLog> careLog(Ref ref) =>
    ref.watch(careRepositoryProvider).watchEvents().map(CareLog.new);

@Riverpod(keepAlive: true)
Stream<SyncStatus> syncStatus(Ref ref) =>
    ref.watch(careRepositoryProvider).watchSyncStatus();

/// Events recorded here that the server refused (`docs/roles.md`).
@Riverpod(keepAlive: true)
Stream<List<RejectedEvent>> rejectedEvents(Ref ref) =>
    ref.watch(careRepositoryProvider).watchRejected();

/// What someone can do about refused events: read and dismiss them.
@Riverpod(keepAlive: true)
class RejectedActions extends _$RejectedActions {
  @override
  void build() {}

  Future<Result<void>> dismiss(RejectedEvent rejected) =>
      ref.read(careRepositoryProvider).dismissRejected(rejected.event.meta.id);
}

/// Syncing on request, besides the sync that runs on its own.
@Riverpod(keepAlive: true)
class SyncActions extends _$SyncActions {
  @override
  void build() {}

  Future<Result<void>> syncNow() => ref.read(careRepositoryProvider).syncNow();
}

/// Members of the circle not removed, admins first.
@Riverpod(keepAlive: true)
List<Member> members(Ref ref) =>
    ref.watch(careLogProvider).value?.members ?? const [];

/// Every member who ever belonged, to name who recorded what.
@Riverpod(keepAlive: true)
Map<String, Member> membersById(Ref ref) =>
    ref.watch(careLogProvider).value?.membersById ?? const {};

/// How the app names the person cared for, as the circle was created;
/// null until the log has it.
@Riverpod(keepAlive: true)
String? recipientName(Ref ref) =>
    ref.watch(careLogProvider).value?.circle?.recipientName;

/// Whether this is the demo's sample circle, labeled as such.
@Riverpod(keepAlive: true)
bool isSampleCircle(Ref ref) =>
    ref.watch(careLogProvider).value?.circle?.isSample ?? false;

/// The circle's own skip reasons by id, to say why a dose or task was
/// skipped.
@Riverpod(keepAlive: true)
Map<String, String> customReasons(Ref ref) =>
    ref.watch(careLogProvider).value?.customReasonLabels ?? const {};

/// The reasons offered when a dose is not given, or with [forTask] a
/// task not done, by id (`CareLog.reasonChoices`).
@riverpod
List<String> reasonChoices(Ref ref, {required bool forTask}) =>
    ref.watch(careLogProvider).value?.reasonChoices(forTask: forTask) ??
    [SkipReason.other.id];

/// The member this device joined the circle as; null until it joins
/// with a code, and again after it leaves (`docs/roles.md`). Remembered
/// on the device.
@Riverpod(keepAlive: true)
class DeviceMembership extends _$DeviceMembership {
  @override
  String? build() => ref.watch(devicePrefsProvider).read(PrefKeys.memberId);

  Future<void> joined(String memberId) async {
    state = memberId;
    await ref.read(devicePrefsProvider).write(PrefKeys.memberId, memberId);
  }

  /// Forgets the member, and the welcome with it: whoever joins next
  /// sees it again.
  Future<void> cleared() async {
    state = null;
    final prefs = ref.read(devicePrefsProvider);
    await prefs.write(PrefKeys.memberId, null);
    await prefs.write(PrefKeys.welcomeSeen, null);
  }
}

/// The member using this device; null before it joins, or until the log
/// has them.
@Riverpod(keepAlive: true)
Member? currentMember(Ref ref) => switch (ref.watch(deviceMembershipProvider)) {
  final String id => ref.watch(membersByIdProvider)[id],
  null => null,
};

/// Whether this simulated phone has network. Demo control only.
@Riverpod(keepAlive: true)
class NetworkEnabled extends _$NetworkEnabled {
  @override
  bool build() => ref.watch(simulatedConnectionProvider).isOnline;

  void toggle() {
    final enabled = !state;
    ref.read(simulatedConnectionProvider).isOnline = enabled;
    state = enabled;
  }
}

/// Whether this phone's member may do [action] (`docs/roles.md`); false
/// before the log has them. The UI offers only what this allows; the
/// server checks every event anyway.
@riverpod
bool canDo(Ref ref, CareAction action) =>
    switch (ref.watch(currentMemberProvider)) {
      final Member member => can(member.role, action),
      null => false,
    };

/// Starts this phone's copy of the log over when a role change changes
/// what it may read (`docs/roles.md`, "Data by role"): becoming a helper
/// drops the team's events, leaving it brings them. The app keeps it
/// alive.
@Riverpod(keepAlive: true)
void audienceSync(Ref ref) {
  ref.listen(currentMemberProvider, (previous, next) {
    if (previous == null || next == null) return;
    if (audiencesFor(previous.role) == audiencesFor(next.role)) return;
    unawaited(ref.read(careRepositoryImplProvider).restart());
  });
}
