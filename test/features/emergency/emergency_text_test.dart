import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/features/care/domain/entities/recipient_profile.dart';
import 'package:i_care/features/care/domain/projections/care_log.dart';
import 'package:i_care/features/emergency/controllers/emergency_card.dart';
import 'package:i_care/features/emergency/presentation/widgets/emergency_text.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../care/helpers/care_events.dart';

void main() {
  final l10n = lookupAppLocalizations(const Locale('en'));

  // The app's localizations load date formats; a unit test must do it.
  setUpAll(() => initializeDateFormatting('en'));

  test('lists allergies first, then medications and who to call', () {
    final events = EventFactory();
    final card = buildEmergencyCard(
      CareLog([
        events.created('m1'),
        events.profile(
          RecipientProfile(
            name: 'Elena Rossi',
            birthDate: DateTime(1942, 3, 14),
            allergies: 'Penicillin\nLatex',
            conditions: 'High blood pressure',
            doctors: const [
              CareContact(
                name: 'Dr. Pérez',
                role: 'Cardiology',
                phone: '+54 11 5555-0101',
              ),
            ],
            contacts: const [CareContact(name: 'Ana', role: 'Daughter')],
          ),
        ),
      ]),
    );

    expect(
      emergencyText(card, l10n, locale: 'en', today: DateTime(2026, 11, 2)),
      'EMERGENCY CARD: Elena Rossi, 84 years old\n'
      'ALLERGIES: Penicillin, Latex\n'
      'Conditions: High blood pressure\n'
      'Medications:\n'
      '- Enalapril 10 mg: 08:00 · 20:00 · Every day\n'
      'Doctors:\n'
      '- Dr. Pérez (Cardiology): +54 11 5555-0101\n'
      'Emergency contacts:\n'
      '- Ana (Daughter)',
    );
  });

  test('says so when there are no known allergies', () {
    final events = EventFactory();
    final card = buildEmergencyCard(
      CareLog([events.profile(const RecipientProfile(name: 'Elena'))]),
    );

    expect(
      emergencyText(card, l10n, locale: 'en', today: DateTime(2026)),
      'EMERGENCY CARD: Elena\nALLERGIES: No known allergies',
    );
  });
}
