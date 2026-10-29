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

  @override
  String get sampleData => 'Sample data';

  @override
  String syncedAt(String time) {
    return 'Synced at $time';
  }

  @override
  String get syncNever => 'Not synced yet';

  @override
  String get syncOffline => 'Offline';

  @override
  String syncPending(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count changes waiting to sync',
      one: '1 change waiting to sync',
    );
    return '$_temp0';
  }

  @override
  String get nextDose => 'Next dose';

  @override
  String get allDoneToday => 'All of today\'s doses are recorded.';

  @override
  String get fromYesterday => 'From yesterday';

  @override
  String get dayPartMorning => 'Morning';

  @override
  String get dayPartMidday => 'Midday';

  @override
  String get dayPartAfternoon => 'Afternoon';

  @override
  String get dayPartNight => 'Night';

  @override
  String get asNeeded => 'As needed';

  @override
  String get statusUpcoming => 'Upcoming';

  @override
  String get statusDue => 'Due now';

  @override
  String get statusOverdue => 'Late';

  @override
  String get statusGiven => 'Given';

  @override
  String get statusSkipped => 'Skipped';

  @override
  String get statusGivenTwice => 'Given twice';

  @override
  String recordedBy(String name, String time) {
    return '$name at $time';
  }

  @override
  String lastDose(String time, String name) {
    return 'Last dose: $time, by $name';
  }

  @override
  String get noDoseYet => 'No doses recorded';

  @override
  String stockDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days left',
      one: '1 day left',
      zero: 'Runs out today',
    );
    return '$_temp0';
  }

  @override
  String get stockOut => 'Out of stock';

  @override
  String get doubleDoseBody =>
      'Recorded as given more than once. If in doubt, ask the doctor or pharmacist.';

  @override
  String get markGiven => 'Mark as given';

  @override
  String get markGivenAnyway => 'Mark as given anyway';

  @override
  String get skipDose => 'Skip this dose';

  @override
  String get skipReasonTitle => 'Why is it skipped?';

  @override
  String get skipRefused => 'Refused it';

  @override
  String get skipAsleep => 'Was asleep';

  @override
  String get skipUnwell => 'Felt unwell';

  @override
  String get skipDoctorAdvice => 'Doctor\'s advice';

  @override
  String get skipOther => 'Other reason';

  @override
  String skippedBy(String name, String reason) {
    return 'Skipped by $name: $reason';
  }

  @override
  String doseRecordedGiven(String medication) {
    return '$medication recorded as given';
  }

  @override
  String doseRecordedSkipped(String medication) {
    return '$medication recorded as skipped';
  }

  @override
  String get undo => 'Undo';

  @override
  String get checkBeforeGiving => 'Check before giving it';

  @override
  String warningAlreadyGiven(String name, String time) {
    return '$name already recorded it at $time.';
  }

  @override
  String warningTooSoon(String last, String next) {
    return 'The last dose was at $last. With the interval you entered, the next one is from $next.';
  }

  @override
  String warningDailyLimit(int given, int max) {
    return '$given of $max doses given today, the maximum you entered.';
  }

  @override
  String warningOutOfDate(String time) {
    return 'This phone last synced at $time: someone may have given it already.';
  }

  @override
  String get warningNeverSynced =>
      'This phone has not synced yet: someone may have given it already.';

  @override
  String scheduledAt(String time) {
    return 'Scheduled at $time';
  }

  @override
  String get recordedToday => 'Recorded today';

  @override
  String get recordedForThisDose => 'Recorded for this dose';

  @override
  String get unknownCaregiver => 'Someone';

  @override
  String get whoAreYou => 'Who are you?';

  @override
  String phoneOf(String name) {
    return '$name\'s phone';
  }

  @override
  String get networkOn => 'Connected';

  @override
  String get networkOff => 'Offline';

  @override
  String get demoHint =>
      'Two caregivers\' phones, synced through a simulated server. Turn one offline and record the same dose on both.';

  @override
  String careOf(String name) {
    return 'Caring for $name';
  }

  @override
  String get yesterday => 'Yesterday';

  @override
  String get notSyncedYet => 'Not synced yet';

  @override
  String conflictSlotTitle(String medication, String time, int count) {
    return '$medication at $time was recorded $count times';
  }

  @override
  String conflictCloseTitle(String medication) {
    return '$medication: doses too close together';
  }

  @override
  String get conflictExplanation =>
      'They were recorded on different phones, without seeing each other\'s record.';

  @override
  String conflictQuestion(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Did $name get all $count doses?',
      two: 'Did $name get both doses?',
    );
    return '$_temp0';
  }

  @override
  String get conflictOnlyOne => 'No, only one';

  @override
  String conflictAllGiven(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Yes, all were given',
      two: 'Yes, both were given',
    );
    return '$_temp0';
  }

  @override
  String get conflictNotSure => 'I don\'t know yet';

  @override
  String get conflictResolvedOne => 'Repeated record cancelled';

  @override
  String conflictArrived(String medication) {
    return '$medication was recorded more than once';
  }

  @override
  String get review => 'Review';

  @override
  String get warningOffline =>
      'This phone is offline: someone may have given it already.';

  @override
  String doseRecordedOffline(String medication) {
    return '$medication saved on this phone. It will sync when the connection is back.';
  }

  @override
  String recordedByToday(String name, String time) {
    return '$name, today at $time';
  }
}
