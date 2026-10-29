import 'dart:convert';

import 'package:i_care/core/error/app_exception.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/dose_schedule.dart';
import 'package:i_care/features/care/domain/entities/medication.dart';

/// Wire and storage format of [CareEvent]s.
///
/// Written by hand rather than generated: the format is a contract between
/// devices, the server and data already stored, so renaming a Dart class
/// or field must never change it. Type tags and keys are explicit
/// snake_case strings.
///
/// Dates are wall-clock ISO 8601 without an offset: the whole circle runs
/// in the care recipient's time zone (see `.claude/steering/product.md`).
abstract final class CareEventCodec {
  /// Bumped on incompatible changes; readers reject other versions.
  static const formatVersion = 1;

  /// Throws [ParsingException].
  static CareEvent decodeString(String source) {
    final Object? json;
    try {
      json = jsonDecode(source);
    } on FormatException catch (error) {
      throw ParsingException('Event is not JSON', cause: error);
    }
    return switch (json) {
      final Map<String, Object?> map => decode(map),
      _ => throw const ParsingException('Event is not a JSON object'),
    };
  }

  static String encodeString(CareEvent event) => jsonEncode(encode(event));

  static Map<String, Object?> encode(CareEvent event) => {
    'v': formatVersion,
    'id': event.meta.id,
    'caregiver_id': event.meta.caregiverId,
    'occurred_at': _date(event.meta.occurredAt),
    'received_at': event.meta.receivedAt.let(_date),
    ...switch (event) {
      MedicationCreated() => {
        'type': 'medication_created',
        'medication_id': event.medicationId,
        'details': _encodeDetails(event.details),
        'schedule': _encodeSchedule(event.schedule),
        'effective_from': _date(event.effectiveFrom),
      },
      MedicationUpdated() => {
        'type': 'medication_updated',
        'medication_id': event.medicationId,
        'base_version': event.baseVersion,
        'details': _encodeDetails(event.details),
      },
      ScheduleChanged() => {
        'type': 'schedule_changed',
        'medication_id': event.medicationId,
        'base_version': event.baseVersion,
        'schedule': _encodeSchedule(event.schedule),
        'effective_from': _date(event.effectiveFrom),
      },
      MedicationArchived() => {
        'type': 'medication_archived',
        'medication_id': event.medicationId,
        'base_version': event.baseVersion,
      },
      DoseGiven() => {
        'type': 'dose_given',
        'medication_id': event.medicationId,
        'slot_at': event.slotAt.let(_date),
        'given_at': _date(event.givenAt),
        'units': event.units,
        'known_dose_ids': event.knownDoseIds,
        'note': event.note,
      },
      DoseSkipped() => {
        'type': 'dose_skipped',
        'medication_id': event.medicationId,
        'slot_at': _date(event.slotAt),
        'reason': _skipReasons.inverse[event.reason],
        'note': event.note,
      },
      DoseUndone() => {
        'type': 'dose_undone',
        'target_event_id': event.targetEventId,
      },
      StockCounted() => {
        'type': 'stock_counted',
        'medication_id': event.medicationId,
        'units': event.units,
      },
      StockRefilled() => {
        'type': 'stock_refilled',
        'medication_id': event.medicationId,
        'units': event.units,
      },
      ConflictAcknowledged() => {
        'type': 'conflict_acknowledged',
        'conflict_key': event.conflictKey,
      },
    },
  };

  /// Throws [ParsingException].
  static CareEvent decode(Map<String, Object?> json) {
    try {
      return _decode(_Reader(json));
    } on FormatException catch (error) {
      throw ParsingException('Malformed event: ${error.message}', cause: error);
    }
  }

  static CareEvent _decode(_Reader json) {
    final version = json.integer('v');
    if (version != formatVersion) {
      throw FormatException('unsupported format version $version');
    }
    final meta = EventMeta(
      id: json.string('id'),
      caregiverId: json.string('caregiver_id'),
      occurredAt: json.date('occurred_at'),
      receivedAt: json.optionalDate('received_at'),
    );

    return switch (json.string('type')) {
      'medication_created' => CareEvent.medicationCreated(
        meta: meta,
        medicationId: json.string('medication_id'),
        details: _decodeDetails(json.object('details')),
        schedule: _decodeSchedule(json.object('schedule')),
        effectiveFrom: json.date('effective_from'),
      ),
      'medication_updated' => CareEvent.medicationUpdated(
        meta: meta,
        medicationId: json.string('medication_id'),
        baseVersion: json.integer('base_version'),
        details: _decodeDetails(json.object('details')),
      ),
      'schedule_changed' => CareEvent.scheduleChanged(
        meta: meta,
        medicationId: json.string('medication_id'),
        baseVersion: json.integer('base_version'),
        schedule: _decodeSchedule(json.object('schedule')),
        effectiveFrom: json.date('effective_from'),
      ),
      'medication_archived' => CareEvent.medicationArchived(
        meta: meta,
        medicationId: json.string('medication_id'),
        baseVersion: json.integer('base_version'),
      ),
      'dose_given' => CareEvent.doseGiven(
        meta: meta,
        medicationId: json.string('medication_id'),
        slotAt: json.optionalDate('slot_at'),
        givenAt: json.date('given_at'),
        units: json.number('units'),
        knownDoseIds: json.strings('known_dose_ids'),
        note: json.optionalString('note'),
      ),
      'dose_skipped' => CareEvent.doseSkipped(
        meta: meta,
        medicationId: json.string('medication_id'),
        slotAt: json.date('slot_at'),
        reason: json.oneOf('reason', _skipReasons),
        note: json.optionalString('note'),
      ),
      'dose_undone' => CareEvent.doseUndone(
        meta: meta,
        targetEventId: json.string('target_event_id'),
      ),
      'stock_counted' => CareEvent.stockCounted(
        meta: meta,
        medicationId: json.string('medication_id'),
        units: json.number('units'),
      ),
      'stock_refilled' => CareEvent.stockRefilled(
        meta: meta,
        medicationId: json.string('medication_id'),
        units: json.number('units'),
      ),
      'conflict_acknowledged' => CareEvent.conflictAcknowledged(
        meta: meta,
        conflictKey: json.string('conflict_key'),
      ),
      final type => throw FormatException('unknown event type "$type"'),
    };
  }

  static Map<String, Object?> _encodeDetails(MedicationDetails details) => {
    'name': details.name,
    'strength': details.strength,
    'form': _forms.inverse[details.form],
    'instructions': details.instructions,
    'units_per_dose': details.unitsPerDose,
    'low_stock_days': details.lowStockDays,
  };

  static MedicationDetails _decodeDetails(_Reader json) => MedicationDetails(
    name: json.string('name'),
    strength: json.string('strength'),
    form: json.oneOf('form', _forms),
    instructions: json.string('instructions'),
    unitsPerDose: json.number('units_per_dose'),
    lowStockDays: json.integer('low_stock_days'),
  );

  static Map<String, Object?> _encodeSchedule(DoseSchedule schedule) =>
      switch (schedule) {
        FixedSchedule() => {
          'kind': 'fixed',
          'minutes_of_day': schedule.minutesOfDay,
          'weekdays': schedule.weekdays.toList()..sort(),
          'min_interval_minutes': schedule.minInterval?.inMinutes,
        },
        AsNeededSchedule() => {
          'kind': 'as_needed',
          'min_interval_minutes': schedule.minInterval.inMinutes,
          'max_per_day': schedule.maxPerDay,
        },
      };

  static DoseSchedule _decodeSchedule(_Reader json) =>
      switch (json.string('kind')) {
        'fixed' => DoseSchedule.fixed(
          minutesOfDay: json.integers('minutes_of_day'),
          weekdays: json.integers('weekdays').toSet(),
          minInterval: json
              .optionalInteger('min_interval_minutes')
              .let((minutes) => Duration(minutes: minutes)),
        ),
        'as_needed' => DoseSchedule.asNeeded(
          minInterval: Duration(minutes: json.integer('min_interval_minutes')),
          maxPerDay: json.optionalInteger('max_per_day'),
        ),
        final kind => throw FormatException('unknown schedule kind "$kind"'),
      };

  static String _date(DateTime date) => date.toIso8601String();

  static const Map<String, MedicationForm> _forms = {
    'tablet': MedicationForm.tablet,
    'capsule': MedicationForm.capsule,
    'liquid': MedicationForm.liquid,
    'drops': MedicationForm.drops,
    'injection': MedicationForm.injection,
    'patch': MedicationForm.patch,
    'inhaler': MedicationForm.inhaler,
    'other': MedicationForm.other,
  };

  static const Map<String, SkipReason> _skipReasons = {
    'refused': SkipReason.refused,
    'asleep': SkipReason.asleep,
    'unwell': SkipReason.unwell,
    'doctor_advice': SkipReason.doctorAdvice,
    'other': SkipReason.other,
  };
}

/// Typed access to a JSON object; throws [FormatException] on a missing
/// or mistyped field.
extension type const _Reader(Map<String, Object?> _json) {
  T _field<T>(String key) => switch (_json[key]) {
    final T value => value,
    final other => throw FormatException(
      'field "$key" should be $T, got ${other.runtimeType}',
    ),
  };

  String string(String key) => _field<String>(key);

  String? optionalString(String key) => _field<String?>(key);

  int integer(String key) => _field<int>(key);

  int? optionalInteger(String key) => _field<int?>(key);

  double number(String key) => _field<num>(key).toDouble();

  DateTime date(String key) => _parseDate(key, string(key));

  DateTime? optionalDate(String key) =>
      optionalString(key).let((value) => _parseDate(key, value));

  _Reader object(String key) => _Reader(_field<Map<String, Object?>>(key));

  List<String> strings(String key) => _list<String>(key);

  List<int> integers(String key) => _list<int>(key);

  List<T> _list<T>(String key) {
    final items = _field<List<Object?>>(key);
    if (items.any((item) => item is! T)) {
      throw FormatException('field "$key" should hold only $T');
    }
    return items.cast<T>();
  }

  T oneOf<T>(String key, Map<String, T> values) =>
      values[string(key)] ??
      (throw FormatException('field "$key" has an unknown value'));

  DateTime _parseDate(String key, String value) =>
      DateTime.tryParse(value) ??
      (throw FormatException('field "$key" is not a date'));
}

extension _Inverse<K, V> on Map<K, V> {
  /// Keys by value; the codec's value maps are one-to-one.
  Map<V, K> get inverse => {
    for (final MapEntry(:key, :value) in entries) value: key,
  };
}

extension _Let<T extends Object> on T? {
  /// [transform] applied to this value, or null when it is null.
  R? let<R>(R Function(T value) transform) => switch (this) {
    final T value => transform(value),
    null => null,
  };
}
