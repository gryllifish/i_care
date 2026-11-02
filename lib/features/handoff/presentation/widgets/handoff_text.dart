import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/utils/formatters.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/caregiver.dart';
import 'package:i_care/features/care/domain/entities/dose_slot.dart';
import 'package:i_care/features/care/domain/entities/medication.dart';
import 'package:i_care/features/care/domain/entities/stock_level.dart';
import 'package:i_care/features/care/domain/entities/task_slot.dart';
import 'package:i_care/features/handoff/controllers/handoff.dart';
import 'package:i_care/shared/l10n/care_labels.dart';
import 'package:i_care/shared/l10n/date_texts.dart';

/// The handoff as plain text, sections separated by blank lines, ready to
/// paste in a family chat. Plain on purpose: no emoji or markup that a
/// chat app might mangle.
String handoffText(
  Handoff handoff,
  AppLocalizations l10n, {
  required String recipientName,
  required Map<String, Caregiver> caregivers,
  required String locale,
}) {
  final at = handoff.at;
  final today = DateTime(at.year, at.month, at.day);
  String time(DateTime value) => Formatters.time(value, locale);
  String nameOf(String id) => caregivers[id]?.name ?? l10n.unknownCaregiver;
  String medicationName(Medication medication) => [
    medication.details.name,
    if (medication.details.strength.isNotEmpty) medication.details.strength,
  ].join(' ');
  String slotTime(DoseSlot slot) => slot.slotAt.isBefore(today)
      ? '${l10n.yesterday.toLowerCase()} ${time(slot.slotAt)}'
      : time(slot.slotAt);
  String stockText(StockLevel stock) => switch (stock) {
    StockLevel(:final units) when units <= 0 => l10n.stockOut,
    StockLevel(daysLeft: final int days) => l10n.stockDays(days),
    _ => l10n.stockOut,
  };

  String givenLine(Medication medication, DoseGiven dose) {
    final who = nameOf(dose.meta.caregiverId);
    return '- ${medicationName(medication)}, ${time(dose.givenAt)} ($who)';
  }

  String skippedLine(DoseSlot slot) {
    final reason = slot.skipped.first.reason.label(l10n);
    return '- ${medicationName(slot.medication)}, ${time(slot.slotAt)}: '
        '$reason';
  }

  String taskWhen(TaskSlot slot) =>
      slot.isAnyTime ? l10n.duringTheDay.toLowerCase() : time(slot.slotAt);

  String taskDoneLine(TaskSlot slot) {
    final record = slot.done.first;
    return '- ${slot.task.details.name}, ${time(record.meta.occurredAt)} '
        '(${nameOf(record.meta.caregiverId)})';
  }

  String taskSkippedLine(TaskSlot slot) =>
      '- ${slot.task.details.name}: ${slot.skipped.first.reason.label(l10n)}';

  final next = handoff.nextAppointment;
  final note = handoff.latestNote;

  final sections = [
    [
      l10n.handoffHeader(
        recipientName,
        Formatters.weekdayAndDate(at, locale),
        time(at),
      ),
    ],
    if (handoff.given.isNotEmpty)
      [
        l10n.handoffGiven,
        for (final (:medication, :dose) in handoff.given)
          givenLine(medication, dose),
      ],
    if (handoff.skipped.isNotEmpty)
      [
        l10n.handoffSkipped,
        for (final slot in handoff.skipped) skippedLine(slot),
      ],
    if (handoff.pending.isEmpty)
      [l10n.handoffNothingPending]
    else
      [
        l10n.handoffPending,
        for (final slot in handoff.pending)
          '- ${medicationName(slot.medication)}, ${slotTime(slot)}',
      ],
    if (handoff.conflicts > 0) [l10n.handoffConflicts(handoff.conflicts)],
    if (handoff.tasksDone.isNotEmpty)
      [
        l10n.handoffTasksDone,
        for (final slot in handoff.tasksDone) taskDoneLine(slot),
      ],
    if (handoff.tasksSkipped.isNotEmpty)
      [
        l10n.handoffTasksSkipped,
        for (final slot in handoff.tasksSkipped) taskSkippedLine(slot),
      ],
    if (handoff.tasksPending.isNotEmpty)
      [
        l10n.handoffTasksPending,
        for (final slot in handoff.tasksPending)
          '- ${slot.task.details.name}, ${taskWhen(slot)}',
      ],
    if (handoff.lowStock.isNotEmpty)
      [
        l10n.handoffLowStock,
        for (final (:medication, :stock) in handoff.lowStock)
          '- ${medication.details.name} · ${stockText(stock)}',
      ],
    if (next != null)
      [
        l10n.handoffNextAppointment,
        [
          next.details.title,
          appointmentWhen(l10n, next.startsAt, now: at, locale: locale),
          if (next.details.doctor.isNotEmpty) next.details.doctor,
        ].join(', '),
        if (next.documents.isNotEmpty) ...[
          l10n.handoffDocuments,
          for (final document in next.documents)
            '- ${document.title}: ${document.url}',
        ],
      ],
    if (note != null)
      [
        l10n.handoffLastNote(
          note.appointment.details.title,
          nameOf(note.note.meta.caregiverId),
        ),
        note.note.text,
      ],
  ];
  return [for (final section in sections) section.join('\n')].join('\n\n');
}
