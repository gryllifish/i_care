import 'package:i_care/features/care/domain/entities/appointment.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/care_task.dart';
import 'package:i_care/features/care/domain/entities/dose_schedule.dart';
import 'package:i_care/features/care/domain/entities/medication.dart';
import 'package:i_care/features/care/domain/entities/member.dart';
import 'package:i_care/features/care/domain/entities/recipient_profile.dart';

/// The demo's care circle: Elena, her two children and a hired carer.
///
/// Sample data, labeled as such in the app. Medications are common ones
/// with everyday doses; they illustrate the app, not a treatment plan.
abstract final class SampleCircle {
  static const recipientName = 'Elena';

  static const ana = Member(
    id: 'ana',
    name: 'Ana',
    colorIndex: 0,
    role: MemberRole.admin,
  );
  static const martin = Member(
    id: 'martin',
    name: 'Martín',
    colorIndex: 1,
    role: MemberRole.caregiver,
  );
  static const rosa = Member(
    id: 'rosa',
    name: 'Rosa',
    colorIndex: 2,
    role: MemberRole.helper,
  );

  static const List<Member> members = [ana, martin, rosa];

  /// Events of the last few days, as if caregivers had recorded them in
  /// [language] (the device's, on first run). Doses and tasks of today
  /// before [now] are recorded too, except one dose from yesterday
  /// evening, left unresolved on purpose, and today's tasks with no set
  /// time, still to do.
  static List<CareEvent> events(DateTime now, {required String language}) =>
      _SampleHistory(now, language).build();

  /// The circle's members as of [at]: Ana created it (the server invites
  /// whoever creates a circle), invited the others, and everyone joined.
  /// Ids sort before the rest of the sample's, so members come first.
  static List<CareEvent> memberEvents(DateTime at) => [
    for (final member in members) ...[
      CareEvent.memberInvited(
        meta: EventMeta(
          id: 'member-${member.id}-1-invited',
          caregiverId: member == ana ? systemAuthor : ana.id,
          occurredAt: at,
        ),
        memberId: member.id,
        name: member.name,
        role: member.role,
        colorIndex: member.colorIndex,
      ),
      CareEvent.memberJoined(
        meta: EventMeta(
          id: 'member-${member.id}-2-joined',
          caregiverId: systemAuthor,
          occurredAt: at,
        ),
        memberId: member.id,
      ),
    ],
  ];
}

class _SampleHistory {
  _SampleHistory(this.now, this.language)
    : today = DateTime(now.year, now.month, now.day),
      start = DateTime(now.year, now.month, now.day - _days),
      _medications = _medicationsIn(language);

  static const _days = 3;

  final DateTime now;
  final String language;
  final DateTime today;
  final List<_SampleMedication> _medications;
  final DateTime start;
  final _events = <CareEvent>[];

  List<CareEvent> build() {
    _events.addAll(SampleCircle.memberEvents(start));
    for (final medication in _medications) {
      _add(
        (meta) => CareEvent.medicationCreated(
          meta: meta,
          medicationId: medication.id,
          details: medication.details,
          schedule: medication.schedule,
          effectiveFrom: start,
        ),
        at: start,
        by: SampleCircle.ana.id,
      );
      _add(
        (meta) => CareEvent.stockCounted(
          meta: meta,
          medicationId: medication.id,
          units: medication.stock,
        ),
        at: start,
        by: SampleCircle.ana.id,
      );
    }
    _addScheduledDoses();
    _addAsNeededDose();
    _addTasks();
    _addAppointments();
    _addProfile();
    return _events;
  }

  /// The emergency card. Phone numbers use the 555 range reserved for
  /// fiction, so none of them reaches a real person.
  void _addProfile() {
    final spanish = language == 'es';
    _add(
      (meta) => CareEvent.recipientProfileUpdated(
        meta: meta,
        baseVersion: 0,
        profile: RecipientProfile(
          name: 'Elena Rossi',
          birthDate: DateTime(1942, 3, 14),
          allergies: spanish ? 'Penicilina' : 'Penicillin',
          conditions: spanish
              ? 'Hipertensión\nHipotiroidismo\nDiabetes tipo 2'
              : 'High blood pressure\nHypothyroidism\nType 2 diabetes',
          doctors: [
            CareContact(
              name: 'Dra. Pérez',
              role: spanish ? 'Cardiología' : 'Cardiology',
              phone: '+54 11 5555-0101',
            ),
            CareContact(
              name: 'Dr. Gómez',
              role: spanish ? 'Clínica médica' : 'General practice',
              phone: '+54 11 5555-0102',
            ),
          ],
          contacts: [
            CareContact(
              name: 'Ana',
              role: spanish ? 'Hija' : 'Daughter',
              phone: '+54 11 5555-0201',
            ),
            CareContact(
              name: 'Martín',
              role: spanish ? 'Hijo' : 'Son',
              phone: '+54 11 5555-0202',
            ),
          ],
          notes: spanish
              ? 'Usa audífono en el oído derecho.'
              : 'Wears a hearing aid in the right ear.',
        ),
      ),
      at: start,
      by: SampleCircle.ana.id,
    );
  }

  /// A blood test with a note, a check-up yesterday nobody wrote notes
  /// for yet, and a cardiology visit in two days with questions.
  /// Care that is not medication: two tasks at set times, two during the
  /// day. Past ones are done, except a walk Elena was too unwell for.
  void _addTasks() {
    final spanish = language == 'es';
    final tasks = [
      (
        id: 'task-bath',
        details: TaskDetails(
          name: spanish ? 'Baño' : 'Bath',
          note: spanish ? 'Usar la silla de ducha' : 'Use the shower chair',
        ),
        schedule: const TaskSchedule(
          minutesOfDay: [10 * 60],
          weekdays: {DateTime.monday, DateTime.thursday},
        ),
      ),
      (
        id: 'task-walk',
        details: TaskDetails(name: spanish ? 'Caminata corta' : 'Short walk'),
        schedule: const TaskSchedule(minutesOfDay: [17 * 60]),
      ),
      (
        id: 'task-skin',
        details: TaskDetails(
          name: spanish ? 'Revisar la piel' : 'Check the skin',
          note: spanish
              ? 'Talones, caderas y espalda: avisar si hay zonas rojas'
              : 'Heels, hips and back: tell the others about red areas',
        ),
        schedule: const TaskSchedule(),
      ),
      (
        id: 'task-bedding',
        details: TaskDetails(
          name: spanish ? 'Cambiar la ropa de cama' : 'Change the bedding',
        ),
        schedule: const TaskSchedule(
          weekdays: {DateTime.wednesday, DateTime.saturday},
        ),
      ),
    ];
    for (final task in tasks) {
      _add(
        (meta) => CareEvent.taskCreated(
          meta: meta,
          taskId: task.id,
          details: task.details,
          schedule: task.schedule,
        ),
        at: start,
        by: SampleCircle.ana.id,
      );
    }

    final yesterday = DateTime(today.year, today.month, today.day - 1);
    for (var offset = _days; offset >= 0; offset--) {
      final day = DateTime(today.year, today.month, today.day - offset);
      for (final task in tasks) {
        for (final slotAt in task.schedule.slotsOn(day)) {
          // Untimed tasks are done in the evening, so today's still wait.
          final doneAt = task.schedule.isAnyTime
              ? DateTime(day.year, day.month, day.day, 19)
              : slotAt.add(const Duration(minutes: 10));
          if (!doneAt.isBefore(now)) continue;

          final caregiver = _caregiverAt(doneAt);
          if (day == yesterday && task.id == 'task-walk') {
            _add(
              (meta) => CareEvent.taskSkipped(
                meta: meta,
                taskId: task.id,
                slotAt: slotAt,
                reason: SkipReason.unwell,
              ),
              at: doneAt,
              by: caregiver,
            );
            continue;
          }
          _add(
            (meta) => CareEvent.taskDone(
              meta: meta,
              taskId: task.id,
              slotAt: slotAt,
            ),
            at: doneAt,
            by: caregiver,
          );
        }
      }
    }
  }

  void _addAppointments() {
    final spanish = language == 'es';
    DateTime dayAt(int offset, int hour, [int minute = 0]) =>
        DateTime(today.year, today.month, today.day + offset, hour, minute);

    final appointments = [
      (
        id: 'appointment-lab',
        details: AppointmentDetails(
          title: spanish ? 'Análisis de sangre' : 'Blood test',
          startsAt: dayAt(-_days, 9),
          location: spanish ? 'Laboratorio Central' : 'Central Lab',
        ),
        note: spanish ? 'Resultados en 5 días.' : 'Results in 5 days.',
      ),
      (
        id: 'appointment-checkup',
        details: AppointmentDetails(
          title: spanish ? 'Clínica médica' : 'General practice',
          startsAt: dayAt(-1, 11),
          doctor: 'Dr. Gómez',
          location: spanish ? 'Centro de salud' : 'Health center',
        ),
        note: null,
      ),
      (
        id: 'appointment-cardiology',
        details: AppointmentDetails(
          title: spanish ? 'Cardiología' : 'Cardiology',
          startsAt: dayAt(2, 10, 30),
          doctor: 'Dra. Pérez',
          location: spanish ? 'Hospital Italiano' : 'City Hospital',
          questions: spanish
              ? '¿Hay que cambiar algo del enalapril?\n'
                    '¿Puede seguir caminando todos los días?'
              : 'Should anything change with the enalapril?\n'
                    'Can she keep walking every day?',
        ),
        note: null,
      ),
    ];
    for (final appointment in appointments) {
      _add(
        (meta) => CareEvent.appointmentCreated(
          meta: meta,
          appointmentId: appointment.id,
          details: appointment.details,
        ),
        at: start,
        by: SampleCircle.ana.id,
      );
      if (appointment.note case final String note) {
        _add(
          (meta) => CareEvent.visitNoteAdded(
            meta: meta,
            appointmentId: appointment.id,
            text: note,
          ),
          at: appointment.details.startsAt.add(const Duration(hours: 2)),
          by: SampleCircle.ana.id,
        );
      }
    }

    // Links for the cardiologist, on example.com: reserved for examples,
    // so none of them leads anywhere real.
    final documents = [
      (
        title: spanish ? 'Resultados del análisis' : 'Blood test results',
        url: 'https://lab.example.com/results/elena-rossi',
        at: dayAt(1 - _days, 18),
        by: SampleCircle.martin.id,
      ),
      (
        title: spanish ? 'Electrocardiograma anterior' : 'Previous ECG',
        url: 'https://drive.example.com/elena/ecg-2026.pdf',
        at: dayAt(-1, 21),
        by: SampleCircle.ana.id,
      ),
    ];
    for (final document in documents) {
      _add(
        (meta) => CareEvent.documentLinked(
          meta: meta,
          appointmentId: 'appointment-cardiology',
          title: document.title,
          url: document.url,
        ),
        at: document.at,
        by: document.by,
      );
    }
  }

  void _addScheduledDoses() {
    final yesterday = DateTime(today.year, today.month, today.day - 1);
    for (var offset = _days; offset >= 0; offset--) {
      final day = DateTime(today.year, today.month, today.day - offset);
      for (final medication in _medications) {
        for (final slotAt in medication.schedule.slotsOn(day)) {
          final givenAt = slotAt.add(const Duration(minutes: 4));
          final unresolved =
              day == yesterday &&
              medication.id == _metforminId &&
              slotAt.hour >= 20;
          if (unresolved || !givenAt.isBefore(now)) continue;

          final caregiver = _caregiverAt(slotAt);
          if (day == yesterday && slotAt.hour == 7) {
            _add(
              (meta) => CareEvent.doseSkipped(
                meta: meta,
                medicationId: medication.id,
                slotAt: slotAt,
                reason: SkipReason.asleep,
              ),
              at: givenAt,
              by: caregiver,
            );
            continue;
          }
          _add(
            (meta) => CareEvent.doseGiven(
              meta: meta,
              medicationId: medication.id,
              slotAt: slotAt,
              givenAt: givenAt,
              units: medication.details.unitsPerDose,
            ),
            at: givenAt,
            by: caregiver,
          );
        }
      }
    }
  }

  void _addAsNeededDose() {
    final givenAt = DateTime(today.year, today.month, today.day - 1, 22, 10);
    _add(
      (meta) => CareEvent.doseGiven(
        meta: meta,
        medicationId: _paracetamolId,
        slotAt: null,
        givenAt: givenAt,
        units: 1,
        note: language == 'es' ? 'Dolor de rodilla' : 'Knee pain',
      ),
      at: givenAt,
      by: SampleCircle.martin.id,
    );
  }

  /// Rosa covers weekday daytime; Ana and Martín take turns otherwise.
  String _caregiverAt(DateTime time) {
    final isWeekday = time.weekday <= DateTime.friday;
    if (isWeekday && time.hour >= 9 && time.hour < 18) {
      return SampleCircle.rosa.id;
    }
    return time.day.isEven ? SampleCircle.ana.id : SampleCircle.martin.id;
  }

  void _add(
    CareEvent Function(EventMeta meta) build, {
    required DateTime at,
    required String by,
  }) {
    // Sequential ids keep the seeded log in this order on every device:
    // the server stamps the whole batch with one receivedAt.
    final id = 'sample-${_events.length.toString().padLeft(4, '0')}';
    _events.add(build(EventMeta(id: id, caregiverId: by, occurredAt: at)));
  }
}

typedef _SampleMedication = ({
  String id,
  MedicationDetails details,
  DoseSchedule schedule,
  double stock,
});

/// The sample medications, written as a caregiver would in [language]
/// (`es`, or English for anything else).
List<_SampleMedication> _medicationsIn(String language) {
  final spanish = language == 'es';
  return [
    (
      id: 'enalapril',
      details: const MedicationDetails(
        name: 'Enalapril',
        strength: '10 mg',
        form: MedicationForm.tablet,
      ),
      schedule: const DoseSchedule.fixed(minutesOfDay: [8 * 60, 20 * 60]),
      stock: 40,
    ),
    (
      id: _levothyroxineId,
      details: MedicationDetails(
        name: spanish ? 'Levotiroxina' : 'Levothyroxine',
        strength: '50 mcg',
        form: MedicationForm.tablet,
        instructions: spanish
            ? 'En ayunas, 30 minutos antes del desayuno'
            : 'On an empty stomach, 30 minutes before breakfast',
      ),
      schedule: const DoseSchedule.fixed(minutesOfDay: [7 * 60]),
      stock: 9,
    ),
    (
      id: _metforminId,
      details: MedicationDetails(
        name: spanish ? 'Metformina' : 'Metformin',
        strength: '500 mg',
        form: MedicationForm.tablet,
        instructions: spanish ? 'Con las comidas' : 'With meals',
      ),
      schedule: const DoseSchedule.fixed(minutesOfDay: [13 * 60, 21 * 60]),
      stock: 60,
    ),
    (
      id: _paracetamolId,
      details: MedicationDetails(
        name: 'Paracetamol',
        strength: '500 mg',
        form: MedicationForm.tablet,
        instructions: spanish ? 'Si tiene dolor' : 'If in pain',
      ),
      schedule: const DoseSchedule.asNeeded(
        minInterval: Duration(hours: 6),
        maxPerDay: 4,
      ),
      stock: 20,
    ),
  ];
}

const _levothyroxineId = 'levothyroxine';
const _metforminId = 'metformin';
const _paracetamolId = 'paracetamol';
