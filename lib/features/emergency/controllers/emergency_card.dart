import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:i_care/core/error/result.dart';
import 'package:i_care/features/care/controllers/care_controllers.dart';
import 'package:i_care/features/care/controllers/care_recorder.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/conflict.dart';
import 'package:i_care/features/care/domain/entities/medication.dart';
import 'package:i_care/features/care/domain/entities/recipient_profile.dart';
import 'package:i_care/features/care/domain/projections/care_log.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'emergency_card.freezed.dart';
part 'emergency_card.g.dart';

/// Everything the emergency card shows.
@freezed
abstract class EmergencyCard with _$EmergencyCard {
  const factory EmergencyCard({
    /// Null until someone fills it in.
    RecipientProfile? profile,
    @Default(0) int profileVersion,

    /// Active medications, from the log, so the card never goes stale.
    @Default(<Medication>[]) List<Medication> medications,
    @Default(<EditConflict>[]) List<EditConflict> conflicts,
  }) = _EmergencyCard;
}

EmergencyCard buildEmergencyCard(CareLog log) => EmergencyCard(
  profile: log.profile,
  profileVersion: log.profileVersion,
  medications: log.medications,
  conflicts: [
    for (final conflict in log.conflicts.whereType<EditConflict>())
      if (conflict.entityId == CareLog.profileId) conflict,
  ],
);

@riverpod
AsyncValue<EmergencyCard> emergencyCard(Ref ref) =>
    ref.watch(careLogProvider).whenData(buildEmergencyCard);

/// Changes to the profile, carrying the version they were made on.
@Riverpod(keepAlive: true)
class ProfileActions extends _$ProfileActions {
  @override
  void build() {}

  CareRecorder get _recorder => ref.read(careRecorderProvider);

  Future<Result<void>> update(RecipientProfile profile, {required int base}) =>
      _recorder.record(
        CareEvent.recipientProfileUpdated(
          meta: _recorder.meta(),
          baseVersion: base,
          profile: profile,
        ),
      );

  /// Keeps the profile in use, or brings [chosen] back on top of it; the
  /// conflict is marked reviewed either way.
  Future<Result<void>> resolve(
    EditConflict conflict, {
    required CareEvent chosen,
    required int currentVersion,
  }) => _recorder.recordAll([
    if (chosen != conflict.changes.last)
      if (chosen case RecipientProfileUpdated(:final profile))
        CareEvent.recipientProfileUpdated(
          meta: _recorder.meta(),
          baseVersion: currentVersion,
          profile: profile,
        ),
    CareEvent.conflictAcknowledged(
      meta: _recorder.meta(),
      conflictKey: conflict.key,
    ),
  ]);
}
