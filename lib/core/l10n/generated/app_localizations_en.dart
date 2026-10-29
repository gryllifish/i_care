// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'ICare';

  @override
  String get retry => 'Try again';

  @override
  String get todayTitle => 'Today';

  @override
  String get medicalDisclaimer =>
      'ICare helps caregivers keep track together. It does not give medical advice: follow the instructions of the treating doctor or pharmacist.';

  @override
  String get errorLoadData => 'We couldn\'t read the saved data.';

  @override
  String get errorNotFound => 'We couldn\'t find that item.';

  @override
  String get errorUnexpected => 'Something went wrong. Please try again.';

  @override
  String get errorOffline =>
      'You\'re offline. Changes are saved on this device and sync when the connection is back.';

  @override
  String get errorTimeout => 'This is taking too long. Please try again.';

  @override
  String get errorServer =>
      'The sync service is having trouble. Try again soon.';
}
