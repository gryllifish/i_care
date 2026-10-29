import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/caregiver.dart';
import 'package:i_care/features/care/domain/entities/dose_schedule.dart';
import 'package:i_care/features/care/domain/entities/medication.dart';

/// The demo's care circle: Elena, her two children and a hired carer.
///
/// Sample data, labeled as such in the app. Medications are common ones
/// with everyday doses; they illustrate the app, not a treatment plan.
abstract final class SampleCircle {
  static const recipientName = 'Elena';

  static const ana = Caregiver(id: 'ana', name: 'Ana', colorIndex: 0);
  static const martin = Caregiver(id: 'martin', name: 'Martín', colorIndex: 1);
  static const rosa = Caregiver(id: 'rosa', name: 'Rosa', colorIndex: 2);

  static const List<Caregiver> caregivers = [ana, martin, rosa];

  /// Events of the last few days, as if caregivers had recorded them.
  /// Doses of today before [now] are recorded too, except one from
  /// yesterday evening, left unresolved on purpose.
  static List<CareEvent> events(DateTime now) => _SampleHistory(now).build();
}

class _SampleHistory {
  _SampleHistory(this.now)
    : today = DateTime(now.year, now.month, now.day),
      start = DateTime(now.year, now.month, now.day - _days);

  static const _days = 3;

  final DateTime now;
  final DateTime today;
  final DateTime start;
  final _events = <CareEvent>[];

  List<CareEvent> build() {
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
    return _events;
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
              medication.id == _metformin.id &&
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
        medicationId: _paracetamol.id,
        slotAt: null,
        givenAt: givenAt,
        units: 1,
        note: 'Dolor de rodilla',
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

const _SampleMedication _enalapril = (
  id: 'enalapril',
  details: MedicationDetails(
    name: 'Enalapril',
    strength: '10 mg',
    form: MedicationForm.tablet,
  ),
  schedule: DoseSchedule.fixed(minutesOfDay: [8 * 60, 20 * 60]),
  stock: 40,
);

const _SampleMedication _levothyroxine = (
  id: 'levothyroxine',
  details: MedicationDetails(
    name: 'Levotiroxina',
    strength: '50 mcg',
    form: MedicationForm.tablet,
    instructions: 'En ayunas, 30 minutos antes del desayuno',
  ),
  schedule: DoseSchedule.fixed(minutesOfDay: [7 * 60]),
  stock: 9,
);

const _SampleMedication _metformin = (
  id: 'metformin',
  details: MedicationDetails(
    name: 'Metformina',
    strength: '500 mg',
    form: MedicationForm.tablet,
    instructions: 'Con las comidas',
  ),
  schedule: DoseSchedule.fixed(minutesOfDay: [13 * 60, 21 * 60]),
  stock: 60,
);

const _SampleMedication _paracetamol = (
  id: 'paracetamol',
  details: MedicationDetails(
    name: 'Paracetamol',
    strength: '500 mg',
    form: MedicationForm.tablet,
    instructions: 'Si tiene dolor',
  ),
  schedule: DoseSchedule.asNeeded(
    minInterval: Duration(hours: 6),
    maxPerDay: 4,
  ),
  stock: 20,
);

const List<_SampleMedication> _medications = [
  _enalapril,
  _levothyroxine,
  _metformin,
  _paracetamol,
];
