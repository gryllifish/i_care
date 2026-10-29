import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/features/care/domain/entities/conflict.dart';
import 'package:i_care/features/care/domain/entities/recipient_profile.dart';
import 'package:i_care/features/care/domain/projections/care_log.dart';

import '../helpers/care_events.dart';

void main() {
  final elena = RecipientProfile(
    name: 'Elena',
    birthDate: DateTime(1942, 3, 14),
  );

  test('age counts whole years, the birthday included', () {
    expect(elena.ageOn(DateTime(2026, 3, 13)), 83);
    expect(elena.ageOn(DateTime(2026, 3, 14)), 84);
    expect(const RecipientProfile(name: 'X').ageOn(DateTime(2026)), isNull);
  });

  test('the latest profile is projected with its version', () {
    final events = EventFactory();
    final log = CareLog([
      events.profile(elena),
      events.profile(elena.copyWith(allergies: 'Penicillin'), baseVersion: 1),
    ]);

    expect(log.profile?.allergies, 'Penicillin');
    expect(log.profileVersion, 2);
    expect(log.conflicts, isEmpty);
  });

  test('concurrent profile edits conflict', () {
    final events = EventFactory();
    final log = CareLog([
      events.profile(elena),
      events.profile(elena.copyWith(notes: 'A'), baseVersion: 1),
      events.profile(elena.copyWith(notes: 'B'), baseVersion: 1, by: 'martin'),
    ]);

    expect(
      log.conflicts.single,
      isA<EditConflict>().having(
        (c) => c.entityId,
        'entityId',
        CareLog.profileId,
      ),
    );
  });
}
