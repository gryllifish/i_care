import 'package:i_care/features/care/data/care_providers.dart';
import 'package:i_care/features/care/data/sample/sample_circle.dart';
import 'package:i_care/features/care/domain/entities/caregiver.dart';
import 'package:i_care/features/care/domain/entities/sync_status.dart';
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

/// Members of the circle. Fixed sample members until stage 2 adds
/// accounts and invitations.
@Riverpod(keepAlive: true)
List<Caregiver> caregivers(Ref ref) => SampleCircle.caregivers;

/// Members by id, to name who recorded what.
@Riverpod(keepAlive: true)
Map<String, Caregiver> caregiversById(Ref ref) => {
  for (final caregiver in ref.watch(caregiversProvider))
    caregiver.id: caregiver,
};

/// Who uses this device at first. Each simulated phone overrides it.
@Riverpod(keepAlive: true)
String deviceOwnerId(Ref ref) => SampleCircle.ana.id;

/// Who is recording on this device; "Who are you?" switches it, and the
/// choice is remembered on this device.
@Riverpod(keepAlive: true)
class CurrentCaregiver extends _$CurrentCaregiver {
  @override
  Caregiver build() {
    final chosenId =
        ref.watch(devicePrefsProvider).read(PrefKeys.caregiverId) ??
        ref.watch(deviceOwnerIdProvider);
    final members = ref.watch(caregiversProvider);
    return members.firstWhere(
      (caregiver) => caregiver.id == chosenId,
      orElse: () => members.first,
    );
  }

  Future<void> select(Caregiver caregiver) async {
    state = caregiver;
    await ref
        .read(devicePrefsProvider)
        .write(PrefKeys.caregiverId, caregiver.id);
  }
}

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
