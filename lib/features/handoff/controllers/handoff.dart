import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:i_care/features/care/controllers/care_controllers.dart';
import 'package:i_care/features/care/domain/entities/appointment.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/conflict.dart';
import 'package:i_care/features/care/domain/entities/dose_slot.dart';
import 'package:i_care/features/care/domain/entities/medication.dart';
import 'package:i_care/features/care/domain/entities/stock_level.dart';
import 'package:i_care/features/care/domain/entities/task_slot.dart';
import 'package:i_care/features/care/domain/projections/care_log.dart';
import 'package:i_care/shared/providers/now_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'handoff.freezed.dart';
part 'handoff.g.dart';

/// A dose given, with its medication's name.
typedef GivenDose = ({Medication medication, DoseGiven dose});

/// A medication running low.
typedef LowStock = ({Medication medication, StockLevel stock});

/// How far ahead the handoff mentions the next appointment, and how far
/// back it quotes a visit note.
const handoffHorizon = Duration(days: 7);

/// What the person taking over needs to know, at [at].
@freezed
abstract class Handoff with _$Handoff {
  const factory Handoff({
    required DateTime at,

    /// Doses given today, in the order they were given.
    @Default(<GivenDose>[]) List<GivenDose> given,
    @Default(<DoseSlot>[]) List<DoseSlot> skipped,

    /// Doses still to give: unresolved from yesterday, then today's.
    @Default(<DoseSlot>[]) List<DoseSlot> pending,
    @Default(0) int conflicts,

    /// Today's care tasks by what happened to them, in day order.
    @Default(<TaskSlot>[]) List<TaskSlot> tasksDone,
    @Default(<TaskSlot>[]) List<TaskSlot> tasksSkipped,
    @Default(<TaskSlot>[]) List<TaskSlot> tasksPending,
    @Default(<LowStock>[]) List<LowStock> lowStock,
    Appointment? nextAppointment,

    /// The latest visit note within [handoffHorizon], and its appointment.
    ({Appointment appointment, VisitNoteAdded note})? latestNote,
  }) = _Handoff;
}

Handoff buildHandoff(CareLog log, DateTime now) {
  final today = DateTime(now.year, now.month, now.day);
  final slots = log.slotsOn(today, now: now);
  final tasks = log.taskSlotsOn(today, now: now);
  List<TaskSlot> tasksWith(Set<TaskStatus> statuses) => [
    for (final slot in tasks)
      if (statuses.contains(slot.status)) slot,
  ];
  final given = [
    for (final medication in log.medications)
      for (final dose in log.givenOn(medication.id, today))
        (medication: medication, dose: dose),
  ]..sort((a, b) => a.dose.givenAt.compareTo(b.dose.givenAt));

  final notes = [
    for (final appointment in log.appointments)
      for (final note in appointment.notes)
        if (now.difference(note.meta.occurredAt) <= handoffHorizon)
          (appointment: appointment, note: note),
  ]..sort((a, b) => a.note.meta.occurredAt.compareTo(b.note.meta.occurredAt));

  bool isPending(DoseSlot slot) => switch (slot.status) {
    DoseStatus.upcoming || DoseStatus.due || DoseStatus.overdue => true,
    DoseStatus.given || DoseStatus.skipped => false,
  };

  return Handoff(
    at: now,
    given: given,
    skipped: [
      for (final slot in slots)
        if (slot.status == DoseStatus.skipped) slot,
    ],
    pending: [
      ...log.fromYesterday(today, now: now).where(isPending),
      ...slots.where(isPending),
    ],
    conflicts: log.conflicts.whereType<DoseConflict>().length,
    tasksDone: tasksWith({TaskStatus.done}),
    tasksSkipped: tasksWith({TaskStatus.skipped}),
    tasksPending: tasksWith({
      TaskStatus.upcoming,
      TaskStatus.due,
      TaskStatus.late,
    }),
    lowStock: [
      for (final medication in log.medications)
        if (log.stockOf(medication.id) case final StockLevel stock
            when stock.isLow)
          (medication: medication, stock: stock),
    ],
    nextAppointment: log.appointments
        .where(
          (appointment) =>
              appointment.startsAt.isAfter(now) &&
              appointment.startsAt.difference(now) <= handoffHorizon,
        )
        .firstOrNull,
    latestNote: notes.lastOrNull,
  );
}

@riverpod
AsyncValue<Handoff> handoff(Ref ref) {
  final now = ref.watch(nowProvider);
  return ref.watch(careLogProvider).whenData((log) => buildHandoff(log, now));
}
