import 'package:i_care/core/error/result.dart';
import 'package:i_care/features/care/controllers/care_recorder.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/conflict.dart';
import 'package:i_care/features/care/domain/entities/dose_schedule.dart';
import 'package:i_care/features/care/domain/entities/medication.dart';
import 'package:i_care/features/care/domain/entities/medication_validation.dart';
import 'package:i_care/shared/providers/id_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'medication_actions.g.dart';

/// Changes to medications. Each one appends events carrying the version
/// it was made on, so concurrent edits are flagged instead of lost.
/// Callers validate first (`validateDetails`, `validateSchedule`).
@Riverpod(keepAlive: true)
class MedicationActions extends _$MedicationActions {
  @override
  void build() {}

  CareRecorder get _recorder => ref.read(careRecorderProvider);

  /// Adds a medication whose [schedule] starts now, with [initialStock]
  /// counted when given. Returns the new medication's id.
  Future<Result<String>> create({
    required MedicationDetails details,
    required DoseSchedule schedule,
    double? initialStock,
  }) async {
    final id = ref.read(newIdProvider)();
    final created = _recorder.meta();
    final result = await _recorder.recordAll([
      CareEvent.medicationCreated(
        meta: created,
        medicationId: id,
        details: details,
        schedule: normalizeSchedule(schedule),
        effectiveFrom: created.occurredAt,
      ),
      if (initialStock != null)
        CareEvent.stockCounted(
          meta: _recorder.meta(),
          medicationId: id,
          units: initialStock,
        ),
    ]);
    return switch (result) {
      Ok() => Ok(id),
      Err(:final failure) => Err(failure),
    };
  }

  Future<Result<void>> updateDetails(
    Medication medication,
    MedicationDetails details,
  ) => _recorder.record(
    CareEvent.medicationUpdated(
      meta: _recorder.meta(),
      medicationId: medication.id,
      baseVersion: medication.version,
      details: details,
    ),
  );

  /// Replaces the schedule from [effectiveFrom] on; earlier doses keep
  /// the schedule they had.
  Future<Result<void>> changeSchedule(
    Medication medication,
    DoseSchedule schedule, {
    required DateTime effectiveFrom,
  }) => _recorder.record(
    CareEvent.scheduleChanged(
      meta: _recorder.meta(),
      medicationId: medication.id,
      baseVersion: medication.version,
      schedule: normalizeSchedule(schedule),
      effectiveFrom: effectiveFrom,
    ),
  );

  /// Removes it from Today and the list; its history stays.
  Future<Result<void>> archive(Medication medication) => _recorder.record(
    CareEvent.medicationArchived(
      meta: _recorder.meta(),
      medicationId: medication.id,
      baseVersion: medication.version,
    ),
  );

  /// Sets the stock to a counted amount.
  Future<Result<void>> count(Medication medication, double units) =>
      _recorder.record(
        CareEvent.stockCounted(
          meta: _recorder.meta(),
          medicationId: medication.id,
          units: units,
        ),
      );

  /// Adds bought units to the stock.
  Future<Result<void>> refill(Medication medication, double units) =>
      _recorder.record(
        CareEvent.stockRefilled(
          meta: _recorder.meta(),
          medicationId: medication.id,
          units: units,
        ),
      );

  /// Settles [conflict] by applying [chosen] again on top of the current
  /// version, or by keeping what is there when [chosen] is the change that
  /// won. Either way the conflict is marked as reviewed.
  Future<Result<void>> resolve(
    EditConflict conflict,
    Medication medication, {
    required CareEvent chosen,
  }) {
    final reapply = chosen == conflict.changes.last
        ? null
        : switch (chosen) {
            MedicationUpdated(:final details) => CareEvent.medicationUpdated(
              meta: _recorder.meta(),
              medicationId: medication.id,
              baseVersion: medication.version,
              details: details,
            ),
            ScheduleChanged(:final schedule, :final effectiveFrom) =>
              CareEvent.scheduleChanged(
                meta: _recorder.meta(),
                medicationId: medication.id,
                baseVersion: medication.version,
                schedule: schedule,
                effectiveFrom: effectiveFrom,
              ),
            MedicationArchived() => CareEvent.medicationArchived(
              meta: _recorder.meta(),
              medicationId: medication.id,
              baseVersion: medication.version,
            ),
            _ => null,
          };
    return _recorder.recordAll([
      ?reapply,
      CareEvent.conflictAcknowledged(
        meta: _recorder.meta(),
        conflictKey: conflict.key,
      ),
    ]);
  }
}
