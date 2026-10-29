import 'package:i_care/features/care/domain/entities/appointment.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/conflict.dart';
import 'package:i_care/features/care/domain/entities/dose_schedule.dart';
import 'package:i_care/features/care/domain/entities/dose_slot.dart';
import 'package:i_care/features/care/domain/entities/medication.dart';
import 'package:i_care/features/care/domain/entities/recipient_profile.dart';
import 'package:i_care/features/care/domain/entities/stock_level.dart';

/// Current state of the care circle, projected from its event log.
///
/// Built once per change of the log; queries that depend on the time take
/// `now` so the projection itself never reads a clock.
class CareLog {
  /// Projects [events] in any order; they are sorted with [compareEvents],
  /// so every device holding the same events gets the same state.
  factory CareLog(Iterable<CareEvent> events) {
    final sorted = [...events]..sort(compareEvents);
    return _Projector(sorted).project();
  }

  CareLog._({
    required this.events,
    required this._medications,
    required this._appointments,
    required this.profile,
    required this.profileVersion,
    required this._doses,
    required this._stock,
    required this.conflicts,
  });

  /// The whole log in projection order.
  final List<CareEvent> events;

  /// Conflicts nobody has reviewed yet, in log order.
  final List<Conflict> conflicts;

  final Map<String, Medication> _medications;
  final Map<String, Appointment> _appointments;

  /// The emergency card's profile; null until someone fills it in.
  final RecipientProfile? profile;

  /// Number of profile changes applied, for edits' `baseVersion`.
  final int profileVersion;

  /// The entity id under which profile edits are tracked and conflict.
  static const profileId = 'recipient-profile';

  /// [DoseGiven] and [DoseSkipped] events per medication, undone ones
  /// left out.
  final Map<String, List<CareEvent>> _doses;
  final Map<String, double> _stock;

  /// Medications that are not archived, by name.
  List<Medication> get medications =>
      _medications.values.where((medication) => !medication.isArchived).toList()
        ..sort((a, b) => a.details.name.compareTo(b.details.name));

  Medication? medication(String id) => _medications[id];

  /// Appointments not cancelled, soonest first.
  List<Appointment> get appointments =>
      _appointments.values
          .where((appointment) => !appointment.isCancelled)
          .toList()
        ..sort((a, b) => a.startsAt.compareTo(b.startsAt));

  Appointment? appointment(String id) => _appointments[id];

  /// Scheduled doses on [day] for active medications, by time and name.
  List<DoseSlot> slotsOn(DateTime day, {required DateTime now}) {
    final slots = [
      for (final medication in medications)
        for (final slotAt in medication.slotsOn(day))
          _slot(medication, slotAt, now),
    ];
    return slots..sort(
      (a, b) => switch (a.slotAt.compareTo(b.slotAt)) {
        0 => a.medication.details.name.compareTo(b.medication.details.name),
        final order => order,
      },
    );
  }

  /// The day before [day]'s doses that still need attention on [day]:
  /// unresolved ones, so they are not lost at midnight, and ones resolved
  /// on [day], so whoever resolved them can still see the result.
  List<DoseSlot> fromYesterday(DateTime day, {required DateTime now}) {
    final previousDay = DateTime(day.year, day.month, day.day - 1);
    return [
      for (final slot in slotsOn(previousDay, now: now))
        if (slot.status == DoseStatus.overdue ||
            [
              ...slot.given,
              ...slot.skipped,
            ].any((record) => _isSameDay(record.meta.occurredAt, day)))
          slot,
    ];
  }

  /// The most recent dose given of a medication, by `givenAt`.
  DoseGiven? lastDose(String medicationId) {
    DoseGiven? last;
    for (final dose in _given(medicationId)) {
      if (last == null || dose.givenAt.isAfter(last.givenAt)) last = dose;
    }
    return last;
  }

  /// Every dose of a medication recorded as given, in log order.
  List<DoseGiven> dosesGiven(String medicationId) =>
      _given(medicationId).toList();

  /// Doses of a medication given on [day], by `givenAt`.
  List<DoseGiven> givenOn(String medicationId, DateTime day) => [
    for (final dose in _given(medicationId))
      if (_isSameDay(dose.givenAt, day)) dose,
  ];

  /// Doses of a medication recorded as given for the scheduled time
  /// [slotAt], whenever they happened.
  List<DoseGiven> givenFor(String medicationId, DateTime slotAt) => [
    for (final dose in _given(medicationId))
      if (dose.slotAt == slotAt) dose,
  ];

  /// Stock of a medication, or null when nobody has counted it yet.
  ///
  /// Follows log order, not `givenAt`: a dose given before a count but
  /// synced after it is subtracted anyway. The error only ever makes
  /// stock look lower, so low-stock alerts come early, never late.
  StockLevel? stockOf(String medicationId) {
    final units = _stock[medicationId];
    final medication = _medications[medicationId];
    if (units == null || medication == null) return null;

    final dosesPerDay = medication.schedule.dosesPerDay;
    final unitsPerDay = dosesPerDay == null
        ? null
        : dosesPerDay * medication.details.unitsPerDose;
    final daysLeft = unitsPerDay == null || unitsPerDay == 0
        ? null
        : (units / unitsPerDay).floor();
    return StockLevel(
      units: units,
      daysLeft: daysLeft,
      isLow:
          units <= 0 ||
          (daysLeft != null && daysLeft <= medication.details.lowStockDays),
    );
  }

  Iterable<DoseGiven> _given(String medicationId) =>
      (_doses[medicationId] ?? const []).whereType<DoseGiven>();

  DoseSlot _slot(Medication medication, DateTime slotAt, DateTime now) {
    final records = [
      for (final record in _doses[medication.id] ?? const <CareEvent>[])
        if (_slotOf(record) == slotAt) record,
    ];
    final given = records.whereType<DoseGiven>().toList();
    final skipped = records.whereType<DoseSkipped>().toList();

    return DoseSlot(
      medication: medication,
      slotAt: slotAt,
      status: switch ((given, skipped)) {
        ([_, ...], _) => DoseStatus.given,
        (_, [_, ...]) => DoseStatus.skipped,
        _ when now.isBefore(slotAt.subtract(DoseTiming.window)) =>
          DoseStatus.upcoming,
        _ when now.isAfter(slotAt.add(DoseTiming.window)) => DoseStatus.overdue,
        _ => DoseStatus.due,
      },
      given: given,
      skipped: skipped,
      hasConflict: conflicts.any(
        (conflict) =>
            conflict is DoseConflict &&
            conflict.medicationId == medication.id &&
            conflict.doses.any((dose) => dose.slotAt == slotAt),
      ),
    );
  }

  /// Key of the conflict for two doses at the same scheduled time.
  static String doseConflictKey(String medicationId, DateTime slotAt) =>
      'dose:$medicationId:${slotAt.toIso8601String()}';

  /// Key of the conflict for a dose given too soon after another.
  static String intervalConflictKey(String medicationId, String eventId) =>
      'interval:$medicationId:$eventId';

  /// Key of the conflict raised by a concurrent change.
  static String editConflictKey(String eventId) => 'edit:$eventId';
}

DateTime? _slotOf(CareEvent record) => switch (record) {
  DoseGiven(:final slotAt) => slotAt,
  DoseSkipped(:final slotAt) => slotAt,
  _ => null,
};

bool _isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// Builds a [CareLog] in one pass over sorted events.
class _Projector {
  _Projector(this._events)
    : _undone = {
        for (final event in _events)
          if (event case DoseUndone(:final targetEventId)) targetEventId,
      };

  final List<CareEvent> _events;
  final Set<String> _undone;

  final _medications = <String, Medication>{};
  final _appointments = <String, Appointment>{};
  RecipientProfile? _profile;
  var _profileVersion = 0;

  /// Changes applied to each medication or appointment; the one at index
  /// `i` produced version `i + 1`.
  final _changes = <String, List<CareEvent>>{};
  final _doses = <String, List<CareEvent>>{};
  final _stock = <String, double>{};
  final _conflicts = <Conflict>[];
  final _acknowledged = <String>{};

  CareLog project() {
    _events.forEach(_apply);
    _findDoseConflicts();
    return CareLog._(
      events: List.unmodifiable(_events),
      medications: _medications,
      appointments: _appointments,
      profile: _profile,
      profileVersion: _profileVersion,
      doses: _doses,
      stock: _stock,
      conflicts: List.unmodifiable(
        _conflicts.where((conflict) => !_acknowledged.contains(conflict.key)),
      ),
    );
  }

  void _apply(CareEvent event) {
    switch (event) {
      case MedicationCreated(:final medicationId)
          when !_medications.containsKey(medicationId):
        _medications[medicationId] = Medication(
          id: medicationId,
          details: event.details,
          schedules: [
            ScheduleVersion(
              schedule: event.schedule,
              effectiveFrom: event.effectiveFrom,
            ),
          ],
        );
        _changes[medicationId] = [];
      case MedicationCreated():
        // A repeated id: the first creation stands.
        break;
      case MedicationUpdated(:final medicationId, :final baseVersion):
        _changeMedication(event, medicationId, baseVersion, (medication) {
          return medication.copyWith(details: event.details);
        });
      case ScheduleChanged(:final medicationId, :final baseVersion):
        _changeMedication(event, medicationId, baseVersion, (medication) {
          final version = ScheduleVersion(
            schedule: event.schedule,
            effectiveFrom: event.effectiveFrom,
          );
          final schedules = [
            for (final existing in medication.schedules)
              if (existing.effectiveFrom != event.effectiveFrom) existing,
            version,
          ]..sort((a, b) => a.effectiveFrom.compareTo(b.effectiveFrom));
          return medication.copyWith(schedules: schedules);
        });
      case MedicationArchived(:final medicationId, :final baseVersion):
        _changeMedication(event, medicationId, baseVersion, (medication) {
          return medication.copyWith(isArchived: true);
        });
      case AppointmentCreated(:final appointmentId)
          when !_appointments.containsKey(appointmentId):
        _appointments[appointmentId] = Appointment(
          id: appointmentId,
          details: event.details,
        );
        _changes[appointmentId] = [];
      case AppointmentCreated():
        // A repeated id: the first creation stands.
        break;
      case AppointmentUpdated(:final appointmentId, :final baseVersion):
        _changeAppointment(event, appointmentId, baseVersion, (appointment) {
          return appointment.copyWith(details: event.details);
        });
      case AppointmentCancelled(:final appointmentId, :final baseVersion):
        _changeAppointment(event, appointmentId, baseVersion, (appointment) {
          return appointment.copyWith(isCancelled: true);
        });
      case VisitNoteAdded(:final appointmentId):
        if (_appointments[appointmentId] case final appointment?) {
          _appointments[appointmentId] = appointment.copyWith(
            notes: [...appointment.notes, event],
          );
        }
      case DoseGiven(:final medicationId, :final units)
          when !_undone.contains(event.meta.id):
        (_doses[medicationId] ??= []).add(event);
        if (_stock[medicationId] case final double stock) {
          _stock[medicationId] = stock - units;
        }
      case DoseSkipped(:final medicationId)
          when !_undone.contains(event.meta.id):
        (_doses[medicationId] ??= []).add(event);
      case StockCounted(:final medicationId, :final units):
        _stock[medicationId] = units;
      case StockRefilled(:final medicationId, :final units):
        _stock.update(
          medicationId,
          (stock) => stock + units,
          ifAbsent: () => units,
        );
      case RecipientProfileUpdated(:final baseVersion, :final profile):
        _recordChange(event, CareLog.profileId, baseVersion);
        _profile = profile;
        _profileVersion++;
      case ConflictAcknowledged(:final conflictKey):
        _acknowledged.add(conflictKey);
      case DoseGiven() || DoseSkipped() || DoseUndone():
        // Undone records, and the undo events themselves, change nothing.
        break;
    }
  }

  void _changeMedication(
    CareEvent event,
    String medicationId,
    int baseVersion,
    Medication Function(Medication) update,
  ) {
    final medication = _medications[medicationId];
    if (medication == null) return;
    _recordChange(event, medicationId, baseVersion);
    _medications[medicationId] = update(
      medication,
    ).copyWith(version: medication.version + 1);
  }

  void _changeAppointment(
    CareEvent event,
    String appointmentId,
    int baseVersion,
    Appointment Function(Appointment) update,
  ) {
    final appointment = _appointments[appointmentId];
    if (appointment == null) return;
    _recordChange(event, appointmentId, baseVersion);
    _appointments[appointmentId] = update(
      appointment,
    ).copyWith(version: appointment.version + 1);
  }

  /// Records a change to an existing entity. The change wins in log
  /// order, but if it was made on an older version and overlaps a change
  /// applied since, it is flagged with every change it raced against.
  void _recordChange(CareEvent event, String entityId, int baseVersion) {
    final changes = _changes[entityId] ??= [];
    final raced = [
      for (final change in changes.skip(baseVersion.clamp(0, changes.length)))
        if (_overlap(change, event)) change,
    ];
    if (raced.isNotEmpty) {
      _conflicts.add(
        Conflict.edit(
          key: CareLog.editConflictKey(event.meta.id),
          entityId: entityId,
          changes: [...raced, event],
        ),
      );
    }
    changes.add(event);
  }

  /// Whether two concurrent changes touch the same part of an entity.
  /// A medication's details and schedule are independent; archiving or
  /// cancelling overlaps everything.
  static bool _overlap(CareEvent a, CareEvent b) => switch ((a, b)) {
    (MedicationArchived() || AppointmentCancelled(), _) ||
    (_, MedicationArchived() || AppointmentCancelled()) => true,
    (MedicationUpdated(), MedicationUpdated()) => true,
    (ScheduleChanged(), ScheduleChanged()) => true,
    (AppointmentUpdated(), AppointmentUpdated()) => true,
    (RecipientProfileUpdated(), RecipientProfileUpdated()) => true,
    _ => false,
  };

  void _findDoseConflicts() {
    for (final MapEntry(key: medicationId, value: records) in _doses.entries) {
      final given = records.whereType<DoseGiven>().toList();
      _findSlotConflicts(medicationId, given);
      _findIntervalConflicts(medicationId, given);
    }
  }

  /// Two doses for one scheduled time, unless each later one was given
  /// knowing about every earlier one.
  void _findSlotConflicts(String medicationId, List<DoseGiven> given) {
    final bySlot = <DateTime, List<DoseGiven>>{};
    for (final dose in given) {
      if (dose.slotAt case final DateTime slotAt) {
        (bySlot[slotAt] ??= []).add(dose);
      }
    }
    for (final MapEntry(key: slotAt, value: doses) in bySlot.entries) {
      final unseen = [
        for (final (index, dose) in doses.indexed)
          for (final earlier in doses.take(index))
            if (!_knew(dose, earlier)) dose,
      ];
      if (unseen.isNotEmpty) {
        _conflicts.add(
          Conflict.dose(
            key: CareLog.doseConflictKey(medicationId, slotAt),
            medicationId: medicationId,
            doses: doses,
          ),
        );
      }
    }
  }

  /// Consecutive doses closer than the schedule's minimum interval, by
  /// `givenAt`: what caregivers state, which is what matters for the
  /// patient.
  void _findIntervalConflicts(String medicationId, List<DoseGiven> given) {
    final medication = _medications[medicationId];
    if (medication == null) return;

    final byTime = [...given]..sort((a, b) => a.givenAt.compareTo(b.givenAt));
    for (final (previous, dose) in _pairs(byTime)) {
      final minInterval = _minIntervalOf(medication.scheduleAt(dose.givenAt));
      final sameSlot = dose.slotAt != null && dose.slotAt == previous.slotAt;
      final known = _knew(dose, previous) || _knew(previous, dose);
      if (minInterval == null || sameSlot || known) continue;

      final gap = dose.givenAt.difference(previous.givenAt);
      if (gap < minInterval) {
        _conflicts.add(
          Conflict.dose(
            key: CareLog.intervalConflictKey(medicationId, dose.meta.id),
            medicationId: medicationId,
            doses: [previous, dose],
          ),
        );
      }
    }
  }
}

bool _knew(DoseGiven dose, DoseGiven other) =>
    dose.knownDoseIds.contains(other.meta.id);

Duration? _minIntervalOf(DoseSchedule? schedule) => switch (schedule) {
  FixedSchedule(:final minInterval) => minInterval,
  AsNeededSchedule(:final minInterval) => minInterval,
  null => null,
};

Iterable<(T, T)> _pairs<T>(List<T> items) sync* {
  for (var index = 1; index < items.length; index++) {
    yield (items[index - 1], items[index]);
  }
}
