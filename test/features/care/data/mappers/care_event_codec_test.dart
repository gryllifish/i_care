import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/core/error/app_exception.dart';
import 'package:i_care/features/care/data/mappers/care_event_codec.dart';
import 'package:i_care/features/care/domain/entities/appointment.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/care_task.dart';
import 'package:i_care/features/care/domain/entities/dose_schedule.dart';
import 'package:i_care/features/care/domain/entities/medication.dart';
import 'package:i_care/features/care/domain/entities/member.dart';
import 'package:i_care/features/care/domain/entities/recipient_profile.dart';

void main() {
  final at = DateTime(2026, 11, 2, 8, 5);
  final meta = EventMeta(
    id: 'e1',
    caregiverId: 'ana',
    occurredAt: at,
    receivedAt: at.add(const Duration(seconds: 2)),
  );
  const details = MedicationDetails(
    name: 'Enalapril',
    strength: '10 mg',
    form: MedicationForm.tablet,
    instructions: 'With food',
    unitsPerDose: 0.5,
    lowStockDays: 5,
  );

  final everyKind = <CareEvent>[
    CareEvent.medicationCreated(
      meta: meta,
      medicationId: 'm1',
      details: details,
      schedule: const DoseSchedule.fixed(
        minutesOfDay: [480, 1200],
        weekdays: {DateTime.friday, DateTime.monday},
        minInterval: Duration(hours: 8),
      ),
      effectiveFrom: at,
    ),
    CareEvent.medicationUpdated(
      meta: meta,
      medicationId: 'm1',
      baseVersion: 2,
      details: details,
    ),
    CareEvent.scheduleChanged(
      meta: meta.copyWith(receivedAt: null),
      medicationId: 'm1',
      baseVersion: 1,
      schedule: const DoseSchedule.asNeeded(
        minInterval: Duration(hours: 6),
        maxPerDay: 3,
      ),
      effectiveFrom: at,
    ),
    CareEvent.medicationArchived(
      meta: meta,
      medicationId: 'm1',
      baseVersion: 4,
    ),
    CareEvent.doseGiven(
      meta: meta,
      medicationId: 'm1',
      slotAt: DateTime(2026, 11, 2, 8),
      givenAt: at,
      units: 1,
      knownDoseIds: const ['e0'],
      note: 'Took it with tea',
    ),
    CareEvent.doseGiven(
      meta: meta,
      medicationId: 'm1',
      slotAt: null,
      givenAt: at,
      units: 2,
    ),
    CareEvent.doseSkipped(
      meta: meta,
      medicationId: 'm1',
      slotAt: DateTime(2026, 11, 2, 8),
      reasonId: SkipReason.doctorAdvice.id,
    ),
    CareEvent.doseUndone(meta: meta, targetEventId: 'e0'),
    CareEvent.stockCounted(meta: meta, medicationId: 'm1', units: 28),
    CareEvent.stockRefilled(meta: meta, medicationId: 'm1', units: 30),
    CareEvent.appointmentCreated(
      meta: meta,
      appointmentId: 'a1',
      details: AppointmentDetails(
        title: 'Cardiology',
        startsAt: at,
        doctor: 'Dr. Pérez',
        location: 'Hospital',
        questions: 'Blood pressure?\nDiet?',
      ),
    ),
    CareEvent.appointmentUpdated(
      meta: meta,
      appointmentId: 'a1',
      baseVersion: 1,
      details: AppointmentDetails(title: 'Cardiology', startsAt: at),
    ),
    CareEvent.appointmentCancelled(
      meta: meta,
      appointmentId: 'a1',
      baseVersion: 2,
    ),
    CareEvent.visitNoteAdded(meta: meta, appointmentId: 'a1', text: 'OK'),
    CareEvent.documentLinked(
      meta: meta,
      appointmentId: 'a1',
      title: 'Blood test results',
      url: 'https://lab.example.com/results',
    ),
    CareEvent.documentRemoved(
      meta: meta,
      appointmentId: 'a1',
      documentId: 'e0',
    ),
    CareEvent.recipientProfileUpdated(
      meta: meta,
      baseVersion: 3,
      profile: RecipientProfile(
        name: 'Elena',
        birthDate: DateTime(1942, 3, 14),
        allergies: 'Penicillin',
        doctors: const [
          CareContact(name: 'Dr. Pérez', role: 'Cardiology', phone: '+1'),
        ],
        contacts: const [CareContact(name: 'Ana')],
      ),
    ),
    CareEvent.taskCreated(
      meta: meta,
      taskId: 't1',
      details: const TaskDetails(name: 'Bath', note: 'Shower chair'),
      schedule: const TaskSchedule(
        minutesOfDay: [10 * 60],
        weekdays: {DateTime.monday, DateTime.thursday},
      ),
    ),
    CareEvent.taskUpdated(
      meta: meta,
      taskId: 't1',
      baseVersion: 1,
      details: const TaskDetails(name: 'Check her skin'),
      schedule: const TaskSchedule(),
    ),
    CareEvent.taskArchived(meta: meta, taskId: 't1', baseVersion: 2),
    CareEvent.taskDone(meta: meta, taskId: 't1', slotAt: at),
    CareEvent.taskSkipped(
      meta: meta,
      taskId: 't1',
      slotAt: at,
      reasonId: SkipReason.refused.id,
    ),
    CareEvent.doseUndone(
      meta: meta,
      targetEventId: 'e0',
      conflictKey: 'dose:m1:x',
    ),
    CareEvent.memberInvited(
      meta: meta.copyWith(caregiverId: systemAuthor),
      memberId: 'rosa',
      name: 'Rosa',
      role: MemberRole.helper,
      colorIndex: 2,
    ),
    CareEvent.invitationRevoked(meta: meta, memberId: 'rosa'),
    CareEvent.memberJoined(meta: meta, memberId: 'rosa'),
    CareEvent.roleChanged(
      meta: meta,
      memberId: 'rosa',
      baseVersion: 1,
      role: MemberRole.viewer,
    ),
    CareEvent.memberRemoved(meta: meta, memberId: 'rosa', baseVersion: 2),
    CareEvent.memberLeft(meta: meta, memberId: 'rosa'),
    CareEvent.doseGiven(
      meta: meta.copyWith(fromFormerMember: true),
      medicationId: 'm1',
      slotAt: at,
      givenAt: at,
      units: 1,
    ),
    CareEvent.taskSkipped(
      meta: meta,
      taskId: 't1',
      slotAt: at,
      reasonId: 'custom-1',
      note: 'At the day center',
    ),
    CareEvent.skipReasonAdded(
      meta: meta,
      reasonId: 'custom-1',
      label: 'At the day center',
    ),
    CareEvent.skipReasonHidden(meta: meta, reasonId: 'asleep'),
    CareEvent.skipReasonShown(meta: meta, reasonId: 'asleep'),
    CareEvent.conflictAcknowledged(meta: meta, conflictKey: 'dose:m1:x'),
  ];

  for (final event in everyKind) {
    test('${event.runtimeType} survives a round trip', () {
      expect(
        CareEventCodec.decodeString(CareEventCodec.encodeString(event)),
        event,
      );
    });
  }

  test('the stored format stays stable', () {
    // Data already on devices and on the server is written in this shape;
    // changing it requires a new format version and a migration.
    final event = CareEvent.doseGiven(
      meta: meta.copyWith(receivedAt: null),
      medicationId: 'm1',
      slotAt: DateTime(2026, 11, 2, 8),
      givenAt: at,
      units: 1,
    );

    expect(CareEventCodec.encode(event), {
      'v': 1,
      'id': 'e1',
      'caregiver_id': 'ana',
      'occurred_at': '2026-11-02T08:05:00.000',
      'received_at': null,
      'type': 'dose_given',
      'medication_id': 'm1',
      'slot_at': '2026-11-02T08:00:00.000',
      'given_at': '2026-11-02T08:05:00.000',
      'units': 1.0,
      'known_dose_ids': <String>[],
      'note': null,
    });
  });

  group('rejects with a ParsingException', () {
    Map<String, Object?> valid() => CareEventCodec.encode(everyKind.last);

    for (final (description, json) in [
      ('another format version', {...valid(), 'v': 2}),
      ('an unknown type', {...valid(), 'type': 'dose_teleported'}),
      ('a missing field', {...valid()}..remove('conflict_key')),
      ('a mistyped field', {...valid(), 'caregiver_id': 7}),
      ('a malformed date', {...valid(), 'occurred_at': 'yesterday'}),
    ]) {
      test(description, () {
        expect(
          () => CareEventCodec.decode(json),
          throwsA(isA<ParsingException>()),
        );
      });
    }

    test('text that is not a JSON object', () {
      expect(
        () => CareEventCodec.decodeString('[1, 2]'),
        throwsA(isA<ParsingException>()),
      );
      expect(
        () => CareEventCodec.decodeString('{'),
        throwsA(isA<ParsingException>()),
      );
    });
  });
}
