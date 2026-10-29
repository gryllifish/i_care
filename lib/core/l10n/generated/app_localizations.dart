import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'ICare'**
  String get appTitle;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// No description provided for @todayTitle.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayTitle;

  /// No description provided for @medicalDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'ICare helps caregivers keep track together. It does not give medical advice: follow the instructions of the treating doctor or pharmacist.'**
  String get medicalDisclaimer;

  /// No description provided for @errorLoadData.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t read the saved data.'**
  String get errorLoadData;

  /// No description provided for @errorNotFound.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find that item.'**
  String get errorNotFound;

  /// No description provided for @errorUnexpected.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorUnexpected;

  /// No description provided for @errorOffline.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline. Changes are saved on this device and sync when the connection is back.'**
  String get errorOffline;

  /// No description provided for @errorTimeout.
  ///
  /// In en, this message translates to:
  /// **'This is taking too long. Please try again.'**
  String get errorTimeout;

  /// No description provided for @errorServer.
  ///
  /// In en, this message translates to:
  /// **'The sync service is having trouble. Try again soon.'**
  String get errorServer;

  /// No description provided for @sampleData.
  ///
  /// In en, this message translates to:
  /// **'Sample data'**
  String get sampleData;

  /// No description provided for @syncedAt.
  ///
  /// In en, this message translates to:
  /// **'Synced at {time}'**
  String syncedAt(String time);

  /// No description provided for @syncNever.
  ///
  /// In en, this message translates to:
  /// **'Not synced yet'**
  String get syncNever;

  /// No description provided for @syncOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get syncOffline;

  /// No description provided for @syncPending.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 change waiting to sync} other{{count} changes waiting to sync}}'**
  String syncPending(int count);

  /// No description provided for @fromYesterday.
  ///
  /// In en, this message translates to:
  /// **'From yesterday'**
  String get fromYesterday;

  /// No description provided for @dayPartMorning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get dayPartMorning;

  /// No description provided for @dayPartMidday.
  ///
  /// In en, this message translates to:
  /// **'Midday'**
  String get dayPartMidday;

  /// No description provided for @dayPartAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Afternoon'**
  String get dayPartAfternoon;

  /// No description provided for @dayPartNight.
  ///
  /// In en, this message translates to:
  /// **'Night'**
  String get dayPartNight;

  /// No description provided for @asNeeded.
  ///
  /// In en, this message translates to:
  /// **'As needed'**
  String get asNeeded;

  /// No description provided for @statusUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get statusUpcoming;

  /// No description provided for @statusDue.
  ///
  /// In en, this message translates to:
  /// **'Due now'**
  String get statusDue;

  /// No description provided for @statusOverdue.
  ///
  /// In en, this message translates to:
  /// **'Late'**
  String get statusOverdue;

  /// No description provided for @statusGiven.
  ///
  /// In en, this message translates to:
  /// **'Given'**
  String get statusGiven;

  /// No description provided for @statusSkipped.
  ///
  /// In en, this message translates to:
  /// **'Skipped'**
  String get statusSkipped;

  /// No description provided for @statusGivenTwice.
  ///
  /// In en, this message translates to:
  /// **'Given twice'**
  String get statusGivenTwice;

  /// No description provided for @recordedBy.
  ///
  /// In en, this message translates to:
  /// **'{name} at {time}'**
  String recordedBy(String name, String time);

  /// No description provided for @lastDose.
  ///
  /// In en, this message translates to:
  /// **'Last dose: {time}, by {name}'**
  String lastDose(String time, String name);

  /// No description provided for @noDoseYet.
  ///
  /// In en, this message translates to:
  /// **'No doses recorded'**
  String get noDoseYet;

  /// No description provided for @stockDays.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =0{Runs out today} =1{1 day left} other{{days} days left}}'**
  String stockDays(int days);

  /// No description provided for @stockOut.
  ///
  /// In en, this message translates to:
  /// **'Out of stock'**
  String get stockOut;

  /// No description provided for @doubleDoseBody.
  ///
  /// In en, this message translates to:
  /// **'Recorded as given more than once. If in doubt, ask the doctor or pharmacist.'**
  String get doubleDoseBody;

  /// No description provided for @markGiven.
  ///
  /// In en, this message translates to:
  /// **'Mark as given'**
  String get markGiven;

  /// No description provided for @markGivenAnyway.
  ///
  /// In en, this message translates to:
  /// **'Mark as given anyway'**
  String get markGivenAnyway;

  /// No description provided for @skipDose.
  ///
  /// In en, this message translates to:
  /// **'Skip this dose'**
  String get skipDose;

  /// No description provided for @skipReasonTitle.
  ///
  /// In en, this message translates to:
  /// **'Why is it skipped?'**
  String get skipReasonTitle;

  /// No description provided for @skipRefused.
  ///
  /// In en, this message translates to:
  /// **'Refused it'**
  String get skipRefused;

  /// No description provided for @skipAsleep.
  ///
  /// In en, this message translates to:
  /// **'Was asleep'**
  String get skipAsleep;

  /// No description provided for @skipUnwell.
  ///
  /// In en, this message translates to:
  /// **'Felt unwell'**
  String get skipUnwell;

  /// No description provided for @skipDoctorAdvice.
  ///
  /// In en, this message translates to:
  /// **'Doctor\'s advice'**
  String get skipDoctorAdvice;

  /// No description provided for @skipOther.
  ///
  /// In en, this message translates to:
  /// **'Other reason'**
  String get skipOther;

  /// No description provided for @skippedBy.
  ///
  /// In en, this message translates to:
  /// **'Skipped by {name}: {reason}'**
  String skippedBy(String name, String reason);

  /// No description provided for @doseRecordedGiven.
  ///
  /// In en, this message translates to:
  /// **'{medication} recorded as given'**
  String doseRecordedGiven(String medication);

  /// No description provided for @doseRecordedSkipped.
  ///
  /// In en, this message translates to:
  /// **'{medication} recorded as skipped'**
  String doseRecordedSkipped(String medication);

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @checkBeforeGiving.
  ///
  /// In en, this message translates to:
  /// **'Check before giving it'**
  String get checkBeforeGiving;

  /// No description provided for @warningAlreadyGiven.
  ///
  /// In en, this message translates to:
  /// **'{name} already recorded it at {time}.'**
  String warningAlreadyGiven(String name, String time);

  /// No description provided for @warningTooSoon.
  ///
  /// In en, this message translates to:
  /// **'The last dose was at {last}. With the interval you entered, the next one is from {next}.'**
  String warningTooSoon(String last, String next);

  /// No description provided for @warningDailyLimit.
  ///
  /// In en, this message translates to:
  /// **'{given} of {max} doses given today, the maximum you entered.'**
  String warningDailyLimit(int given, int max);

  /// No description provided for @warningOutOfDate.
  ///
  /// In en, this message translates to:
  /// **'This phone last synced at {time}: someone may have given it already.'**
  String warningOutOfDate(String time);

  /// No description provided for @warningNeverSynced.
  ///
  /// In en, this message translates to:
  /// **'This phone has not synced yet: someone may have given it already.'**
  String get warningNeverSynced;

  /// No description provided for @scheduledAt.
  ///
  /// In en, this message translates to:
  /// **'Scheduled at {time}'**
  String scheduledAt(String time);

  /// No description provided for @recordedToday.
  ///
  /// In en, this message translates to:
  /// **'Recorded today'**
  String get recordedToday;

  /// No description provided for @recordedForThisDose.
  ///
  /// In en, this message translates to:
  /// **'Recorded for this dose'**
  String get recordedForThisDose;

  /// No description provided for @unknownCaregiver.
  ///
  /// In en, this message translates to:
  /// **'Someone'**
  String get unknownCaregiver;

  /// No description provided for @whoAreYou.
  ///
  /// In en, this message translates to:
  /// **'Who are you?'**
  String get whoAreYou;

  /// No description provided for @phoneOf.
  ///
  /// In en, this message translates to:
  /// **'{name}\'s phone'**
  String phoneOf(String name);

  /// No description provided for @networkOn.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get networkOn;

  /// No description provided for @networkOff.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get networkOff;

  /// No description provided for @demoHint.
  ///
  /// In en, this message translates to:
  /// **'Two phones synced through a simulated server. To simulate a dose recorded late: turn Martín\'s phone off, mark the same dose on both and turn it back on.'**
  String get demoHint;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @notSyncedYet.
  ///
  /// In en, this message translates to:
  /// **'Not synced yet'**
  String get notSyncedYet;

  /// No description provided for @conflictSlotTitle.
  ///
  /// In en, this message translates to:
  /// **'{medication} at {time} was recorded {count} times'**
  String conflictSlotTitle(String medication, String time, int count);

  /// No description provided for @conflictCloseTitle.
  ///
  /// In en, this message translates to:
  /// **'{medication}: doses too close together'**
  String conflictCloseTitle(String medication);

  /// No description provided for @conflictExplanation.
  ///
  /// In en, this message translates to:
  /// **'They were recorded on different phones, without seeing each other\'s record.'**
  String get conflictExplanation;

  /// No description provided for @conflictQuestion.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =2{Did {name} get both doses?} other{Did {name} get all {count} doses?}}'**
  String conflictQuestion(String name, int count);

  /// No description provided for @conflictOnlyOne.
  ///
  /// In en, this message translates to:
  /// **'No, only one'**
  String get conflictOnlyOne;

  /// No description provided for @conflictAllGiven.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =2{Yes, both were given} other{Yes, all were given}}'**
  String conflictAllGiven(int count);

  /// No description provided for @conflictNotSure.
  ///
  /// In en, this message translates to:
  /// **'I don\'t know yet'**
  String get conflictNotSure;

  /// No description provided for @conflictResolvedOne.
  ///
  /// In en, this message translates to:
  /// **'Repeated record cancelled'**
  String get conflictResolvedOne;

  /// No description provided for @conflictArrived.
  ///
  /// In en, this message translates to:
  /// **'{medication} was recorded more than once'**
  String conflictArrived(String medication);

  /// No description provided for @review.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get review;

  /// No description provided for @warningOffline.
  ///
  /// In en, this message translates to:
  /// **'This phone is offline: someone may have given it already.'**
  String get warningOffline;

  /// No description provided for @doseRecordedOffline.
  ///
  /// In en, this message translates to:
  /// **'{medication} saved on this phone. It will sync when the connection is back.'**
  String doseRecordedOffline(String medication);

  /// No description provided for @recordedByToday.
  ///
  /// In en, this message translates to:
  /// **'{name}, today at {time}'**
  String recordedByToday(String name, String time);

  /// No description provided for @givenWhen.
  ///
  /// In en, this message translates to:
  /// **'When was it given?'**
  String get givenWhen;

  /// No description provided for @givenNow.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get givenNow;

  /// No description provided for @givenMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min ago'**
  String givenMinutesAgo(int minutes);

  /// No description provided for @givenHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{hours, plural, =1{1 hour ago} other{{hours} hours ago}}'**
  String givenHoursAgo(int hours);

  /// No description provided for @givenPickTime.
  ///
  /// In en, this message translates to:
  /// **'Pick a time'**
  String get givenPickTime;

  /// No description provided for @givenAtTime.
  ///
  /// In en, this message translates to:
  /// **'At {time}'**
  String givenAtTime(String time);

  /// No description provided for @navToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get navToday;

  /// No description provided for @navMedications.
  ///
  /// In en, this message translates to:
  /// **'Medications'**
  String get navMedications;

  /// No description provided for @navActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get navActivity;

  /// No description provided for @durationMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String durationMinutes(int minutes);

  /// No description provided for @durationHours.
  ///
  /// In en, this message translates to:
  /// **'{hours} h'**
  String durationHours(int hours);

  /// No description provided for @durationHoursMinutes.
  ///
  /// In en, this message translates to:
  /// **'{hours} h {minutes} min'**
  String durationHoursMinutes(int hours, int minutes);

  /// No description provided for @nextIn.
  ///
  /// In en, this message translates to:
  /// **'Next dose · in {duration}'**
  String nextIn(String duration);

  /// No description provided for @nextDueNow.
  ///
  /// In en, this message translates to:
  /// **'Next dose · due now'**
  String get nextDueNow;

  /// No description provided for @nextLate.
  ///
  /// In en, this message translates to:
  /// **'Late by {duration}'**
  String nextLate(String duration);

  /// No description provided for @nextFromYesterday.
  ///
  /// In en, this message translates to:
  /// **'From yesterday · late'**
  String get nextFromYesterday;

  /// No description provided for @moreOptions.
  ///
  /// In en, this message translates to:
  /// **'More options'**
  String get moreOptions;

  /// No description provided for @dayDone.
  ///
  /// In en, this message translates to:
  /// **'All of today\'s doses are recorded'**
  String get dayDone;

  /// No description provided for @dayProgress.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} doses recorded today'**
  String dayProgress(int done, int total);

  /// No description provided for @medicationsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 active medication} other{{count} active medications}}'**
  String medicationsCount(int count);

  /// No description provided for @everyDay.
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get everyDay;

  /// No description provided for @minIntervalText.
  ///
  /// In en, this message translates to:
  /// **'at least {duration} apart'**
  String minIntervalText(String duration);

  /// No description provided for @maxPerDayText.
  ///
  /// In en, this message translates to:
  /// **'up to {count} a day'**
  String maxPerDayText(int count);

  /// No description provided for @stockNotCounted.
  ///
  /// In en, this message translates to:
  /// **'Stock not counted'**
  String get stockNotCounted;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @activityEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing recorded yet'**
  String get activityEmpty;

  /// No description provided for @activityCreated.
  ///
  /// In en, this message translates to:
  /// **'{name} added {medication}'**
  String activityCreated(String name, String medication);

  /// No description provided for @activityUpdated.
  ///
  /// In en, this message translates to:
  /// **'{name} edited {medication}'**
  String activityUpdated(String name, String medication);

  /// No description provided for @activityScheduleChanged.
  ///
  /// In en, this message translates to:
  /// **'{name} changed the schedule of {medication}'**
  String activityScheduleChanged(String name, String medication);

  /// No description provided for @activityArchived.
  ///
  /// In en, this message translates to:
  /// **'{name} archived {medication}'**
  String activityArchived(String name, String medication);

  /// No description provided for @activityGiven.
  ///
  /// In en, this message translates to:
  /// **'{name} gave {medication}'**
  String activityGiven(String name, String medication);

  /// No description provided for @activityGivenSlot.
  ///
  /// In en, this message translates to:
  /// **'{name} gave the {time} {medication}'**
  String activityGivenSlot(String name, String medication, String time);

  /// No description provided for @activitySkipped.
  ///
  /// In en, this message translates to:
  /// **'{name} skipped the {time} {medication}: {reason}'**
  String activitySkipped(
    String name,
    String medication,
    String time,
    String reason,
  );

  /// No description provided for @activityUndone.
  ///
  /// In en, this message translates to:
  /// **'{name} cancelled a record of {medication}'**
  String activityUndone(String name, String medication);

  /// No description provided for @activityCounted.
  ///
  /// In en, this message translates to:
  /// **'{name} counted {medication}: {units}'**
  String activityCounted(String name, String medication, String units);

  /// No description provided for @activityRefilled.
  ///
  /// In en, this message translates to:
  /// **'{name} added {units} of {medication}'**
  String activityRefilled(String name, String medication, String units);

  /// No description provided for @activityReviewed.
  ///
  /// In en, this message translates to:
  /// **'{name} reviewed a dose recorded twice'**
  String activityReviewed(String name);

  /// No description provided for @unknownMedication.
  ///
  /// In en, this message translates to:
  /// **'a medication'**
  String get unknownMedication;

  /// No description provided for @givenAtLabel.
  ///
  /// In en, this message translates to:
  /// **'given at {time}'**
  String givenAtLabel(String time);

  /// No description provided for @caringFor.
  ///
  /// In en, this message translates to:
  /// **'Caring for'**
  String get caringFor;

  /// No description provided for @stockUnitsCount.
  ///
  /// In en, this message translates to:
  /// **'{units} units'**
  String stockUnitsCount(String units);

  /// No description provided for @stockLasts.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{Lasts 1 day} other{Lasts {days} days}}'**
  String stockLasts(int days);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
