import 'package:i_care/core/error/result.dart';
import 'package:i_care/features/care/controllers/care_controllers.dart';
import 'package:i_care/features/care/controllers/care_recorder.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/conflict.dart';
import 'package:i_care/features/care/domain/entities/dose_slot.dart';
import 'package:i_care/features/care/domain/entities/medication.dart';
import 'package:i_care/features/care/domain/projections/care_log.dart';
import 'package:i_care/features/care/domain/projections/dose_warnings.dart';
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
/// doses), kept current while the sheet is open. Warnings are for
/// recording it as given at [givenAt], or now when null.
@riverpod
AsyncValue<DoseDetail?> doseDetail(
  Ref ref,
  String medicationId,
  DateTime? slotAt, {
  DateTime? givenAt,
}) {
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
        givenAt: givenAt,
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

/// The latest moment at [hour]:[minute] not after [now]: today, or
/// yesterday when that time has not come yet today (a dose from last
/// night recorded in the morning).
DateTime latestAt(int hour, int minute, DateTime now) {
  final today = DateTime(now.year, now.month, now.day, hour, minute);
  return today.isAfter(now)
      ? DateTime(now.year, now.month, now.day - 1, hour, minute)
      : today;
}

/// Records what the current caregiver does with a dose. Each action
/// appends one event; nothing is edited in place. Kept alive so an undo
/// offered after the sheet closes still has a live notifier.
@Riverpod(keepAlive: true)
class DoseActions extends _$DoseActions {
  @override
  void build() {}

  /// Records [medication] as given at [givenAt], or now when null.
  /// [knownDoseIds] are the doses the caregiver was warned about and
  /// confirmed anyway.
  Future<Result<DoseGiven>> give(
    Medication medication, {
    required DateTime? slotAt,
    DateTime? givenAt,
    List<String> knownDoseIds = const [],
  }) {
    final meta = _meta();
    return _record(
      CareEvent.doseGiven(
        meta: meta,
        medicationId: medication.id,
        slotAt: slotAt,
        givenAt: givenAt ?? meta.occurredAt,
        units: medication.details.unitsPerDose,
        knownDoseIds: knownDoseIds,
      ) as DoseGiven,
    );
  }

  /// Records the dose at [slotAt] as not given, for the reason
  /// [reasonId], with what the caregiver wrote in [note].
  Future<Result<DoseSkipped>> skip(
    Medication medication, {
    required DateTime slotAt,
    required String reasonId,
    String? note,
  }) => _record(
    CareEvent.doseSkipped(
      meta: _meta(),
      medicationId: medication.id,
      slotAt: slotAt,
      reasonId: reasonId,
      note: note,
    ) as DoseSkipped,
  );

  /// Cancels a dose recorded by mistake, or, with [conflictKey], one
  /// found repeated while reviewing that conflict.
  Future<Result<DoseUndone>> undo(CareEvent dose, {String? conflictKey}) =>
      _record(
        CareEvent.doseUndone(
          meta: _meta(),
          targetEventId: dose.meta.id,
          conflictKey: conflictKey,
        ) as DoseUndone,
      );

  Future<Result<ConflictAcknowledged>> acknowledge(String conflictKey) =>
      _record(
        CareEvent.conflictAcknowledged(meta: _meta(), conflictKey: conflictKey)
            as ConflictAcknowledged,
      );

  EventMeta _meta() => ref.read(careRecorderProvider).meta();

  Future<Result<T>> _record<T extends CareEvent>(T event) =>
      ref.read(careRecorderProvider).record(event);
}
