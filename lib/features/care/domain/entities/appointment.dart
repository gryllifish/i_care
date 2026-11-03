import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';

part 'appointment.freezed.dart';

/// What caregivers enter about a medical appointment.
@freezed
abstract class AppointmentDetails with _$AppointmentDetails {
  const factory AppointmentDetails({
    /// Specialty or reason, e.g. "Cardiology".
    required String title,

    /// Wall-clock time in the care recipient's time zone.
    required DateTime startsAt,
    @Default('') String doctor,
    @Default('') String location,

    /// Questions to ask, one per line.
    @Default('') String questions,
  }) = _AppointmentDetails;

  const AppointmentDetails._();

  /// [questions] stored one per line, blank ones left out.
  static String joinQuestions(Iterable<String> questions) => [
    for (final question in questions)
      if (question.trim().isNotEmpty) question.trim(),
  ].join('\n');

  /// [questions] as a list, blank lines left out.
  List<String> get questionList => [
    for (final line in questions.split('\n'))
      if (line.trim().isNotEmpty) line.trim(),
  ];
}

/// An appointment as projected from the event log.
@freezed
abstract class Appointment with _$Appointment {
  const factory Appointment({
    required String id,
    required AppointmentDetails details,

    /// Notes from the visit, oldest first, by whoever wrote them.
    @Default(<VisitNoteAdded>[]) List<VisitNoteAdded> notes,

    /// Links to studies, results or reports, oldest first; removed ones
    /// left out. Each one's id is its event's.
    @Default(<DocumentLinked>[]) List<DocumentLinked> documents,
    @Default(false) bool isCancelled,

    /// Number of changes applied, as for medications.
    @Default(0) int version,
  }) = _Appointment;

  const Appointment._();

  DateTime get startsAt => details.startsAt;
}
