import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/features/care/domain/entities/member.dart';
import 'package:i_care/features/care/domain/permissions.dart';

import '../helpers/care_events.dart';

void main() {
  late EventFactory events;
  final eight = DateTime(2026, 11, 2, 8);

  setUp(() => events = EventFactory());

  test('follows the matrix in docs/roles.md', () {
    Set<MemberRole> allowed(CareAction action) => {
      for (final role in MemberRole.values)
        if (can(role, action)) role,
    };
    const admin = MemberRole.admin;
    const caregiver = MemberRole.caregiver;
    const helper = MemberRole.helper;

    expect(allowed(CareAction.recordCare), {admin, caregiver, helper});
    expect(allowed(CareAction.removeOwnRecord), {admin, caregiver, helper});
    expect(allowed(CareAction.removeAnyRecord), {admin});
    expect(allowed(CareAction.reviewConflict), {admin, caregiver});
    expect(allowed(CareAction.manageMedications), {admin, caregiver});
    expect(allowed(CareAction.manageTasks), {admin, caregiver});
    expect(allowed(CareAction.manageAppointments), {admin, caregiver});
    expect(allowed(CareAction.editEmergencyCard), {admin, caregiver});
    expect(allowed(CareAction.manageMembers), {admin});
    expect(allowed(CareAction.resetDemo), {admin});
    expect(allowed(CareAction.leaveCircle), MemberRole.values.toSet());
  });

  group('actionOf', () {
    test('a record is care; documents and notes are appointments', () {
      expect(
        actionOf(events.given('m1', at: eight), authorId: 'ana'),
        CareAction.recordCare,
      );
      expect(
        actionOf(events.document('a1', 'ECG'), authorId: 'ana'),
        CareAction.manageAppointments,
      );
    });

    test("an undo is one's own, someone else's, or part of a review", () {
      final given = events.given('m1', at: eight, by: 'rosa');
      final undo = events.undone(given);

      expect(
        actionOf(undo, authorId: 'rosa', targetAuthorId: 'rosa'),
        CareAction.removeOwnRecord,
      );
      expect(
        actionOf(undo, authorId: 'ana', targetAuthorId: 'rosa'),
        CareAction.removeAnyRecord,
      );
      expect(
        actionOf(
          undo.copyWith(conflictKey: 'dose:m1:x'),
          authorId: 'martin',
          targetAuthorId: 'rosa',
        ),
        CareAction.reviewConflict,
      );
    });

    test('only the server writes that someone joined', () {
      expect(
        actionOf(events.memberJoined('rosa'), authorId: 'rosa'),
        isNull,
      );
    });
  });

  test('facts are records about the person cared for', () {
    expect(isFact(CareAction.recordCare), isTrue);
    expect(isFact(CareAction.removeOwnRecord), isTrue);
    expect(isFact(CareAction.removeAnyRecord), isFalse);
    expect(isFact(CareAction.manageMedications), isFalse);
    expect(isFact(null), isFalse);
  });

  test("a helper reads care, not the team's appointments and notes", () {
    expect(audienceOf(events.given('m1', at: eight)), Audience.care);
    expect(audienceOf(events.task('t1')), Audience.care);
    expect(audienceOf(events.memberInvited('lucia')), Audience.care);
    expect(audienceOf(events.note('a1', 'Same dose')), Audience.team);
    expect(audienceOf(events.document('a1', 'ECG')), Audience.team);

    expect(audiencesFor(MemberRole.helper), {Audience.care});
    expect(audiencesFor(MemberRole.viewer), Audience.values.toSet());
  });
}
