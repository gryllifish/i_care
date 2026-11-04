import 'dart:convert';

import 'package:i_care/core/error/app_exception.dart';
import 'package:i_care/features/care/domain/entities/appointment.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/care_task.dart';
import 'package:i_care/features/care/domain/entities/dose_schedule.dart';
import 'package:i_care/features/care/domain/entities/medication.dart';
import 'package:i_care/features/care/domain/entities/member.dart';
import 'package:i_care/features/care/domain/entities/recipient_profile.dart';

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
  /// Bumped on incompatible changes. Readers keep events of a newer
  /// version unread (see [tryDecodeString]) and reject older ones.
  static const formatVersion = 1;

  /// Throws [ParsingException], also for an event from a newer app
  /// version.
  static CareEvent decodeString(String source) =>
      tryDecodeString(source) ?? (throw _newerVersion);

  /// [source] decoded, or null when it holds an event from a newer app
  /// version: a format or type this one does not know. Devices keep such
  /// events as received and leave them out of the log until an update
  /// can read them, so one updated device never stops sync for the
  /// others (`docs/backend.md`).
  ///
  /// Throws [ParsingException] when [source] is not a valid event.
  static CareEvent? tryDecodeString(String source) => switch (_json(source)) {
    final Map<String, Object?> map => tryDecode(map),
    _ => throw const ParsingException('Event is not a JSON object'),
  };

  /// The id of the event in [source], whether or not this version can
  /// read the rest.
  ///
  /// Throws [ParsingException].
  static String idOf(String source) => switch (_json(source)) {
    {'id': final String id} => id,
    _ => throw const ParsingException('Event has no id'),
  };

  static const _newerVersion = ParsingException(
    'Event from a newer app version',
  );

  /// Throws [ParsingException].
  static Object? _json(String source) {
    try {
      return jsonDecode(source);
    } on FormatException catch (error) {
      throw ParsingException('Event is not JSON', cause: error);
    }
  }

  static String encodeString(CareEvent event) => jsonEncode(encode(event));

  static Map<String, Object?> encode(CareEvent event) => {
    'v': formatVersion,
    'id': event.meta.id,
    'caregiver_id': event.meta.caregiverId,
    'occurred_at': _date(event.meta.occurredAt),
    'received_at': event.meta.receivedAt.let(_date),
    'server_seq': ?event.meta.serverSeq,
    if (event.meta.fromFormerMember) 'from_former_member': true,
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
        'reason': event.reasonId,
        'note': event.note,
      },
      DoseUndone() => {
        'type': 'dose_undone',
        'target_event_id': event.targetEventId,
        if (event.conflictKey case final String key) 'conflict_key': key,
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
      AppointmentCreated() => {
        'type': 'appointment_created',
        'appointment_id': event.appointmentId,
        'details': _encodeAppointment(event.details),
      },
      AppointmentUpdated() => {
        'type': 'appointment_updated',
        'appointment_id': event.appointmentId,
        'base_version': event.baseVersion,
        'details': _encodeAppointment(event.details),
      },
      AppointmentCancelled() => {
        'type': 'appointment_cancelled',
        'appointment_id': event.appointmentId,
        'base_version': event.baseVersion,
      },
      VisitNoteAdded() => {
        'type': 'visit_note_added',
        'appointment_id': event.appointmentId,
        'text': event.text,
      },
      CareNoteAdded() => {'type': 'care_note_added', 'text': event.text},
      DocumentLinked() => {
        'type': 'document_linked',
        'appointment_id': event.appointmentId,
        'title': event.title,
        'url': event.url,
      },
      DocumentRemoved() => {
        'type': 'document_removed',
        'appointment_id': event.appointmentId,
        'document_id': event.documentId,
      },
      RecipientProfileUpdated() => {
        'type': 'recipient_profile_updated',
        'base_version': event.baseVersion,
        'profile': _encodeProfile(event.profile),
      },
      TaskCreated() => {
        'type': 'task_created',
        'task_id': event.taskId,
        'details': _encodeTask(event.details),
        'schedule': _encodeTaskSchedule(event.schedule),
      },
      TaskUpdated() => {
        'type': 'task_updated',
        'task_id': event.taskId,
        'base_version': event.baseVersion,
        'details': _encodeTask(event.details),
        'schedule': _encodeTaskSchedule(event.schedule),
      },
      TaskArchived() => {
        'type': 'task_archived',
        'task_id': event.taskId,
        'base_version': event.baseVersion,
      },
      TaskDone() => {
        'type': 'task_done',
        'task_id': event.taskId,
        'slot_at': _date(event.slotAt),
      },
      TaskSkipped() => {
        'type': 'task_skipped',
        'task_id': event.taskId,
        'slot_at': _date(event.slotAt),
        'reason': event.reasonId,
        if (event.note case final String note) 'note': note,
      },
      CircleCreated() => {
        'type': 'circle_created',
        'recipient_name': event.recipientName,
        if (event.isSample) 'is_sample': true,
      },
      SkipReasonAdded() => {
        'type': 'skip_reason_added',
        'reason_id': event.reasonId,
        'label': event.label,
      },
      SkipReasonHidden() => {
        'type': 'skip_reason_hidden',
        'reason_id': event.reasonId,
      },
      SkipReasonShown() => {
        'type': 'skip_reason_shown',
        'reason_id': event.reasonId,
      },
      MemberInvited() => {
        'type': 'member_invited',
        'member_id': event.memberId,
        'name': event.name,
        'role': _roles.inverse[event.role],
        'color_index': event.colorIndex,
      },
      InvitationRevoked() => {
        'type': 'invitation_revoked',
        'member_id': event.memberId,
      },
      MemberJoined() => {'type': 'member_joined', 'member_id': event.memberId},
      AccessRecovered() => {
        'type': 'access_recovered',
        'member_id': event.memberId,
      },
      RoleChanged() => {
        'type': 'role_changed',
        'member_id': event.memberId,
        'base_version': event.baseVersion,
        'role': _roles.inverse[event.role],
      },
      MemberRemoved() => {
        'type': 'member_removed',
        'member_id': event.memberId,
        'base_version': event.baseVersion,
      },
      MemberLeft() => {'type': 'member_left', 'member_id': event.memberId},
      ConflictAcknowledged() => {
        'type': 'conflict_acknowledged',
        'conflict_key': event.conflictKey,
      },
    },
  };

  /// Throws [ParsingException], also for an event from a newer app
  /// version.
  static CareEvent decode(Map<String, Object?> json) =>
      tryDecode(json) ?? (throw _newerVersion);

  /// [json] decoded, or null when it comes from a newer app version (see
  /// [tryDecodeString]).
  ///
  /// Throws [ParsingException].
  static CareEvent? tryDecode(Map<String, Object?> json) {
    try {
      return _decode(_Reader(json));
    } on _NewerVersion {
      return null;
    } on FormatException catch (error) {
      throw ParsingException('Malformed event: ${error.message}', cause: error);
    }
  }

  static CareEvent _decode(_Reader json) {
    final version = json.integer('v');
    if (version > formatVersion) throw const _NewerVersion();
    if (version != formatVersion) {
      throw FormatException('unsupported format version $version');
    }
    final meta = EventMeta(
      id: json.string('id'),
      caregiverId: json.string('caregiver_id'),
      occurredAt: json.date('occurred_at'),
      receivedAt: json.optionalDate('received_at'),
      serverSeq: json.optionalInteger('server_seq'),
      // Absent before roles existed, and whenever it is false.
      fromFormerMember: json.optionalBool('from_former_member') ?? false,
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
        reasonId: json.string('reason'),
        note: json.optionalString('note'),
      ),
      'dose_undone' => CareEvent.doseUndone(
        meta: meta,
        targetEventId: json.string('target_event_id'),
        conflictKey: json.optionalString('conflict_key'),
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
      'appointment_created' => CareEvent.appointmentCreated(
        meta: meta,
        appointmentId: json.string('appointment_id'),
        details: _decodeAppointment(json.object('details')),
      ),
      'appointment_updated' => CareEvent.appointmentUpdated(
        meta: meta,
        appointmentId: json.string('appointment_id'),
        baseVersion: json.integer('base_version'),
        details: _decodeAppointment(json.object('details')),
      ),
      'appointment_cancelled' => CareEvent.appointmentCancelled(
        meta: meta,
        appointmentId: json.string('appointment_id'),
        baseVersion: json.integer('base_version'),
      ),
      'visit_note_added' => CareEvent.visitNoteAdded(
        meta: meta,
        appointmentId: json.string('appointment_id'),
        text: json.string('text'),
      ),
      'care_note_added' => CareEvent.careNoteAdded(
        meta: meta,
        text: json.string('text'),
      ),
      'document_linked' => CareEvent.documentLinked(
        meta: meta,
        appointmentId: json.string('appointment_id'),
        title: json.string('title'),
        url: json.string('url'),
      ),
      'document_removed' => CareEvent.documentRemoved(
        meta: meta,
        appointmentId: json.string('appointment_id'),
        documentId: json.string('document_id'),
      ),
      'recipient_profile_updated' => CareEvent.recipientProfileUpdated(
        meta: meta,
        baseVersion: json.integer('base_version'),
        profile: _decodeProfile(json.object('profile')),
      ),
      'task_created' => CareEvent.taskCreated(
        meta: meta,
        taskId: json.string('task_id'),
        details: _decodeTask(json.object('details')),
        schedule: _decodeTaskSchedule(json.object('schedule')),
      ),
      'task_updated' => CareEvent.taskUpdated(
        meta: meta,
        taskId: json.string('task_id'),
        baseVersion: json.integer('base_version'),
        details: _decodeTask(json.object('details')),
        schedule: _decodeTaskSchedule(json.object('schedule')),
      ),
      'task_archived' => CareEvent.taskArchived(
        meta: meta,
        taskId: json.string('task_id'),
        baseVersion: json.integer('base_version'),
      ),
      'task_done' => CareEvent.taskDone(
        meta: meta,
        taskId: json.string('task_id'),
        slotAt: json.date('slot_at'),
      ),
      'task_skipped' => CareEvent.taskSkipped(
        meta: meta,
        taskId: json.string('task_id'),
        slotAt: json.date('slot_at'),
        reasonId: json.string('reason'),
        note: json.optionalString('note'),
      ),
      'circle_created' => CareEvent.circleCreated(
        meta: meta,
        recipientName: json.string('recipient_name'),
        isSample: json.optionalBool('is_sample') ?? false,
      ),
      'skip_reason_added' => CareEvent.skipReasonAdded(
        meta: meta,
        reasonId: json.string('reason_id'),
        label: json.string('label'),
      ),
      'skip_reason_hidden' => CareEvent.skipReasonHidden(
        meta: meta,
        reasonId: json.string('reason_id'),
      ),
      'skip_reason_shown' => CareEvent.skipReasonShown(
        meta: meta,
        reasonId: json.string('reason_id'),
      ),
      'member_invited' => CareEvent.memberInvited(
        meta: meta,
        memberId: json.string('member_id'),
        name: json.string('name'),
        role: json.oneOf('role', _roles),
        colorIndex: json.integer('color_index'),
      ),
      'invitation_revoked' => CareEvent.invitationRevoked(
        meta: meta,
        memberId: json.string('member_id'),
      ),
      'member_joined' => CareEvent.memberJoined(
        meta: meta,
        memberId: json.string('member_id'),
      ),
      'access_recovered' => CareEvent.accessRecovered(
        meta: meta,
        memberId: json.string('member_id'),
      ),
      'role_changed' => CareEvent.roleChanged(
        meta: meta,
        memberId: json.string('member_id'),
        baseVersion: json.integer('base_version'),
        role: json.oneOf('role', _roles),
      ),
      'member_removed' => CareEvent.memberRemoved(
        meta: meta,
        memberId: json.string('member_id'),
        baseVersion: json.integer('base_version'),
      ),
      'member_left' => CareEvent.memberLeft(
        meta: meta,
        memberId: json.string('member_id'),
      ),
      'conflict_acknowledged' => CareEvent.conflictAcknowledged(
        meta: meta,
        conflictKey: json.string('conflict_key'),
      ),
      // Written by a newer app version, not malformed: the format
      // version only changes for incompatible changes, not new types.
      _ => throw const _NewerVersion(),
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

  static Map<String, Object?> _encodeAppointment(AppointmentDetails details) =>
      {
        'title': details.title,
        'starts_at': _date(details.startsAt),
        'doctor': details.doctor,
        'location': details.location,
        'questions': details.questions,
      };

  static AppointmentDetails _decodeAppointment(_Reader json) =>
      AppointmentDetails(
        title: json.string('title'),
        startsAt: json.date('starts_at'),
        doctor: json.string('doctor'),
        location: json.string('location'),
        questions: json.string('questions'),
      );

  static Map<String, Object?> _encodeTask(TaskDetails details) => {
    'name': details.name,
    'note': details.note,
  };

  static TaskDetails _decodeTask(_Reader json) =>
      TaskDetails(name: json.string('name'), note: json.string('note'));

  static Map<String, Object?> _encodeTaskSchedule(TaskSchedule schedule) => {
    'minutes_of_day': schedule.minutesOfDay,
    'weekdays': schedule.weekdays.toList()..sort(),
  };

  static TaskSchedule _decodeTaskSchedule(_Reader json) => TaskSchedule(
    minutesOfDay: json.integers('minutes_of_day'),
    weekdays: json.integers('weekdays').toSet(),
  );

  static Map<String, Object?> _encodeProfile(RecipientProfile profile) => {
    'name': profile.name,
    'birth_date': profile.birthDate.let(_date),
    'allergies': profile.allergies,
    'conditions': profile.conditions,
    'doctors': [for (final c in profile.doctors) _encodeContact(c)],
    'contacts': [for (final c in profile.contacts) _encodeContact(c)],
    'notes': profile.notes,
  };

  static RecipientProfile _decodeProfile(_Reader json) => RecipientProfile(
    name: json.string('name'),
    birthDate: json.optionalDate('birth_date'),
    allergies: json.string('allergies'),
    conditions: json.string('conditions'),
    doctors: [for (final c in json.objects('doctors')) _decodeContact(c)],
    contacts: [for (final c in json.objects('contacts')) _decodeContact(c)],
    notes: json.string('notes'),
  );

  static Map<String, Object?> _encodeContact(CareContact contact) => {
    'name': contact.name,
    'role': contact.role,
    'phone': contact.phone,
  };

  static CareContact _decodeContact(_Reader json) => CareContact(
    name: json.string('name'),
    role: json.string('role'),
    phone: json.string('phone'),
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

  static const Map<String, MemberRole> _roles = {
    'admin': MemberRole.admin,
    'caregiver': MemberRole.caregiver,
    'helper': MemberRole.helper,
    'viewer': MemberRole.viewer,
  };
}

/// An event this app version cannot read because a newer one wrote it.
class _NewerVersion implements Exception {
  const _NewerVersion();
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

  bool? optionalBool(String key) => _field<bool?>(key);

  int integer(String key) => _field<int>(key);

  int? optionalInteger(String key) => _field<int?>(key);

  double number(String key) => _field<num>(key).toDouble();

  DateTime date(String key) => _parseDate(key, string(key));

  DateTime? optionalDate(String key) =>
      optionalString(key).let((value) => _parseDate(key, value));

  _Reader object(String key) => _Reader(_field<Map<String, Object?>>(key));

  List<String> strings(String key) => _list<String>(key);

  List<_Reader> objects(String key) => [
    for (final item in _list<Map<String, Object?>>(key)) _Reader(item),
  ];

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
