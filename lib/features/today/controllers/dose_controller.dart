import 'package:i_care/core/error/result.dart';
import 'package:i_care/features/care/controllers/care_controllers.dart';
import 'package:i_care/features/care/data/care_providers.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/conflict.dart';
import 'package:i_care/features/care/domain/entities/dose_slot.dart';
import 'package:i_care/features/care/domain/entities/medication.dart';
import 'package:i_care/features/care/domain/projections/care_log.dart';
import 'package:i_care/features/care/domain/projections/dose_warnings.dart';
import 'package:i_care/shared/providers/clock_provider.dart';
import 'package:i_care/shared/providers/id_provider.dart';
import 'package:i_care/shared/providers/now_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dose_controller.g.dart';

/// What the dose sheet shows: the medication, its scheduled dose (null
/// when as needed) and what to check before giving it.
typedef DoseDetail = ({
  Medication medication,
  DoseSlot? slot,
  List<DoseGiven> history,
  List<DoseWarning> warnings,

  /// Unreviewed conflicts involving these doses.
  List<DoseConflict> conflicts,
});

/// The dose of [medicationId] scheduled at [slotAt] (null for as-needed
/// doses), kept current while the sheet is open.
@riverpod
AsyncValue<DoseDetail?> doseDetail(
  Ref ref,
  String medicationId,
  DateTime? slotAt,
) {
  final now = ref.watch(nowProvider);
  final status = ref.watch(syncStatusProvider).value;
  return ref.watch(careLogProvider).whenData((log) {
    final medication = log.medication(medicationId);
    if (medication == null) return null;

    final slot = slotAt == null ? null : _slotAt(log, medication, slotAt, now);
    final history = slotAt == null
        ? log.givenOn(medicationId, now)
        : log.givenFor(medicationId, slotAt);
    return (
      medication: medication,
      slot: slot,
      history: history,
      warnings: doseWarnings(
        log,
        medication: medication,
        slotAt: slotAt,
        now: now,
        lastSyncedAt: status?.lastSyncedAt,
        isConnected: status?.isConnected ?? true,
      ),
      conflicts: [
        for (final conflict in log.conflicts.whereType<DoseConflict>())
          if (conflict.doses.any(history.contains)) conflict,
      ],
    );
  });
}

DoseSlot? _slotAt(
  CareLog log,
  Medication medication,
  DateTime slotAt,
  DateTime now,
) => log
    .slotsOn(slotAt, now: now)
    .where(
      (slot) => slot.medication.id == medication.id && slot.slotAt == slotAt,
    )
    .firstOrNull;

/// Records what the current caregiver does with a dose. Each action
/// appends one event; nothing is edited in place. Kept alive so an undo
/// offered after the sheet closes still has a live notifier.
@Riverpod(keepAlive: true)
class DoseActions extends _$DoseActions {
  @override
  void build() {}

  /// Records [medication] as given now. [knownDoseIds] are the doses the
  /// caregiver was warned about and confirmed anyway.
  Future<Result<DoseGiven>> give(
    Medication medication, {
    required DateTime? slotAt,
    List<String> knownDoseIds = const [],
  }) {
    final meta = _meta();
    return _record(
      CareEvent.doseGiven(
            meta: meta,
            medicationId: medication.id,
            slotAt: slotAt,
            givenAt: meta.occurredAt,
            units: medication.details.unitsPerDose,
            knownDoseIds: knownDoseIds,
          )
          as DoseGiven,
    );
  }

  Future<Result<DoseSkipped>> skip(
    Medication medication, {
    required DateTime slotAt,
    required SkipReason reason,
  }) => _record(
    CareEvent.doseSkipped(
          meta: _meta(),
          medicationId: medication.id,
          slotAt: slotAt,
          reason: reason,
        )
        as DoseSkipped,
  );

  /// Cancels a dose recorded by mistake.
  Future<Result<DoseUndone>> undo(CareEvent dose) => _record(
    CareEvent.doseUndone(meta: _meta(), targetEventId: dose.meta.id)
        as DoseUndone,
  );

  Future<Result<ConflictAcknowledged>> acknowledge(String conflictKey) =>
      _record(
        CareEvent.conflictAcknowledged(meta: _meta(), conflictKey: conflictKey)
            as ConflictAcknowledged,
      );

  EventMeta _meta() => EventMeta(
    id: ref.read(newIdProvider)(),
    caregiverId: ref.read(currentCaregiverProvider).id,
    occurredAt: ref.read(clockProvider)(),
  );

  Future<Result<T>> _record<T extends CareEvent>(T event) async =>
      switch (await ref.read(careRepositoryProvider).record(event)) {
        Ok() => Ok(event),
        Err(:final failure) => Err(failure),
      };
}
