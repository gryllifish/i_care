import 'package:i_care/core/error/result.dart';
import 'package:i_care/features/care/data/care_providers.dart';
import 'package:i_care/features/care/data/sample/sample_circle.dart';
import 'package:i_care/features/care/domain/entities/member.dart';
import 'package:i_care/features/care/domain/entities/rejected_event.dart';
import 'package:i_care/features/care/domain/entities/sync_status.dart';
import 'package:i_care/features/care/domain/projections/care_log.dart';
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

/// Members of the circle not removed, admins first.
@Riverpod(keepAlive: true)
List<Member> members(Ref ref) =>
    ref.watch(careLogProvider).value?.members ?? const [];

/// Every member who ever belonged, to name who recorded what.
@Riverpod(keepAlive: true)
Map<String, Member> membersById(Ref ref) =>
    ref.watch(careLogProvider).value?.membersById ?? const {};

/// The member this device belongs to. Each simulated phone overrides it;
/// joining with an invitation code sets it (`docs/roles.md`).
@Riverpod(keepAlive: true)
String deviceOwnerId(Ref ref) => SampleCircle.ana.id;

/// The member using this device; null until the log has them.
@Riverpod(keepAlive: true)
Member? currentMember(Ref ref) =>
    ref.watch(membersByIdProvider)[ref.watch(deviceOwnerIdProvider)];

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
