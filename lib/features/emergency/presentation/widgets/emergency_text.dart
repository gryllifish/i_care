import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/medication.dart';
import 'package:i_care/features/care/domain/entities/recipient_profile.dart';
import 'package:i_care/features/emergency/controllers/emergency_card.dart';
import 'package:i_care/shared/l10n/schedule_text.dart';

/// Lines of free text ("one per line" fields), blank ones left out.
List<String> linesOf(String text) => [
  for (final line in text.split('\n'))
    if (line.trim().isNotEmpty) line.trim(),
];

/// "Dra. Pérez (Cardiology): +54 11 5555-0101".
String contactLine(CareContact contact) => [
  if (contact.role.isEmpty)
    contact.name
  else
    '${contact.name} (${contact.role})',
  if (contact.phone.isNotEmpty) contact.phone,
].join(': ');

/// The card as plain text, to paste in a message or show at a hospital.
/// Allergies come first: they matter most to whoever reads it.
String emergencyText(
  EmergencyCard card,
  AppLocalizations l10n, {
  required String locale,
  required DateTime today,
}) {
  final profile = card.profile;
  if (profile == null) return l10n.emergencyCard.toUpperCase();
  final age = profile.ageOn(today);
  final allergies = linesOf(profile.allergies);
  final conditions = linesOf(profile.conditions);
  final allergyText = allergies.isEmpty
      ? l10n.noAllergies
      : allergies.join(', ');

  String medicationLine(Medication medication) {
    final details = medication.details;
    final name = [
      details.name,
      if (details.strength.isNotEmpty) details.strength,
    ].join(' ');
    return '- $name: ${medication.schedule.describe(l10n, locale)}';
  }

  return [
    [
      '${l10n.emergencyCard.toUpperCase()}: ${profile.name}',
      if (age != null) l10n.ageYears(age),
    ].join(', '),
    '${l10n.allergiesTitle.toUpperCase()}: $allergyText',
    if (conditions.isNotEmpty)
      '${l10n.conditionsTitle}: ${conditions.join(', ')}',
    if (card.medications.isNotEmpty) ...[
      '${l10n.medicationsTitle}:',
      for (final medication in card.medications) medicationLine(medication),
    ],
    if (profile.doctors.isNotEmpty) ...[
      '${l10n.doctorsTitle}:',
      for (final doctor in profile.doctors) '- ${contactLine(doctor)}',
    ],
    if (profile.contacts.isNotEmpty) ...[
      '${l10n.contactsTitle}:',
      for (final contact in profile.contacts) '- ${contactLine(contact)}',
    ],
    if (profile.notes.trim().isNotEmpty)
      '${l10n.notesTitle}: ${profile.notes.trim()}',
  ].join('\n');
}

/// Summary of a profile change, for the conflict card.
String profileChangeSummary(CareEvent change) => switch (change) {
  RecipientProfileUpdated(:final profile) => [
    profile.name,
    ...linesOf(profile.allergies),
  ].join(' · '),
  _ => '',
};
