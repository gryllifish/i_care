import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/features/care/domain/entities/appointment.dart';

void main() {
  test('questions are stored one per line, blank ones left out', () {
    expect(
      AppointmentDetails.joinQuestions([' Dose? ', '', '  ', 'Next visit?']),
      'Dose?\nNext visit?',
    );
  });

  test('stored questions read back as the same list', () {
    final details = AppointmentDetails(
      title: 'Cardiology',
      startsAt: DateTime(2026, 11, 3, 10),
      questions: AppointmentDetails.joinQuestions(['Dose?', 'Next visit?']),
    );

    expect(details.questionList, ['Dose?', 'Next visit?']);
  });
}
